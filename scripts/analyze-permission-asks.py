#!/usr/bin/env python3
"""Reproducible OpenCode permission-ask attribution.

Parses ~/.local/share/opencode/log/opencode.log for `message=asking` lines,
joins each ask to the nearest prior session-created line on the same run id,
and tallies asks by day, permission type, repo, and session kind (subagent
vs primary). For bash asks, also tallies command heads (git subcommands,
cmdlets, binaries).

Usage:
  python scripts/analyze-permission-asks.py [--log PATH] [--days N]

Stdlib only. Read-only.
"""

import argparse
import json
import os
import re
import sys
from collections import Counter
from datetime import datetime, timedelta, timezone

ASK_RE = re.compile(
    r'timestamp=(\S+) .*run=(\S+) message=asking id=\S+ permission=(\S+) patterns="(.*)"\s*$'
)
CREATED_RE = re.compile(
    r'run=(\S+) message=created id=\S+ .*directory="([^"]*)".*?parentID=(\S+).*?title="([^"]*)"'
)


def head_of(pattern: str) -> str:
    toks = pattern.strip().split()
    if not toks:
        return "?"
    h = toks[0].strip('"')
    if h.lower() == "git" and len(toks) > 1:
        t1 = toks[1].strip('"')
        h = "git -C ..." if t1 == "-C" else f"git {t1}"
    return h


def parse_patterns(raw: str):
    try:
        return json.loads(json.loads('"' + raw + '"'))
    except Exception:
        return re.findall(r'\\"(.*?)\\"', raw)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--log",
        default=os.path.join(
            os.environ.get("USERPROFILE", os.path.expanduser("~")),
            ".local", "share", "opencode", "log", "opencode.log",
        ),
    )
    ap.add_argument("--days", type=int, default=0, help="only last N days (0 = all)")
    args = ap.parse_args()

    if not os.path.exists(args.log):
        print(f"log not found: {args.log}", file=sys.stderr)
        return 1

    run_sessions = {}
    asks = []
    with open(args.log, encoding="utf-8", errors="replace") as f:
        for line in f:
            m = CREATED_RE.search(line)
            if m:
                run_sessions[m.group(1)] = (m.group(2), m.group(3) != "undefined")
                continue
            m = ASK_RE.search(line.strip())
            if m:
                # join at append time: run_sessions[run] is the nearest prior
                # created session on this run in file order
                directory, is_sub = run_sessions.get(m.group(2), ("?", False))
                asks.append((m.group(1), m.group(2), m.group(3), m.group(4), directory, is_sub))

    if args.days > 0:
        cutoff = datetime.now(timezone.utc).replace(tzinfo=None) - timedelta(days=args.days)
        asks = [
            a for a in asks
            if datetime.strptime(a[0][:19], "%Y-%m-%dT%H:%M:%S") >= cutoff
        ]

    by_day_type = Counter()
    by_ctx = Counter()
    bash_heads = Counter()
    bash_head_examples = {}

    for ts, run, ptype, raw, directory, is_sub in asks:
        day = ts[:10]
        by_day_type[(day, ptype)] += 1
        repo = directory.replace("\\", "/").rstrip("/").split("/")[-1] or "?"
        kind = "subagent" if is_sub else "primary"
        by_ctx[(day, repo, kind, ptype)] += 1
        if ptype == "bash":
            for p in parse_patterns(raw):
                h = head_of(p)
                bash_heads[h] += 1
                bash_head_examples.setdefault(h, p[:110])

    print(f"total asks: {len(asks)}  (window: {args.days or 'all'} days)")
    print("\nby day/type:")
    for (d, t), n in sorted(by_day_type.items()):
        print(f"  {d}  {t:20s} {n}")

    print("\nby day/repo/session-kind/type:")
    for k, n in sorted(by_ctx.items()):
        print(f"  {k[0]}  {k[1][:24]:24s} {k[2]:9s} {k[3]:20s} {n}")

    print("\nbash ask heads:")
    for h, n in bash_heads.most_common(40):
        print(f"  {n:4d}  {h:32s} e.g. {bash_head_examples[h]}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
