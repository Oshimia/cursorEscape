param()

$ErrorActionPreference = 'Stop'
$sessionsRoot = 'C:\Users\admin\.codex\sessions'
$outDir = Join-Path $PSScriptRoot '..\data'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$launchesPath = Join-Path $outDir 'launches.jsonl'
$bugPath = Join-Path $outDir 'bug-launches.jsonl'

function Get-SectionText([string]$text, [string]$title) {
    $pattern = '(?s)(?m)^## ' + [regex]::Escape($title) + '\s*\r?\n(.*?)(?=\r?\n## |\z)'
    $m = [regex]::Match($text, $pattern)
    if ($m.Success) { return $m.Groups[1].Value.Trim() }
    return $null
}

function Count-NumberedItems([string]$sectionText) {
    if ($null -eq $sectionText) { return $null }
    if ($sectionText -match '^(None|-|\s)*$') { return 0 }
    return [regex]::Matches($sectionText, '(?m)^\s*\d+\.\s').Count
}

$files = Get-ChildItem $sessionsRoot -Recurse -Filter *.jsonl -File
Write-Output ("Total session files scanned: {0}" -f $files.Count)

$prodMarker = 'You are the `production_readiness_reviewer` agent'
$bugMarker = 'You are the `bug_reviewer` agent'

$prodRecords = New-Object System.Collections.Generic.List[object]
$bugRecords = New-Object System.Collections.Generic.List[object]

foreach ($f in $files) {
    $raw = $null
    try { $raw = [System.IO.File]::ReadAllText($f.FullName) } catch { continue }
    if ($null -eq $raw) { continue }

    $isProd = $raw.Contains($prodMarker)
    $isBug = $raw.Contains($bugMarker)
    if (-not $isProd -and -not $isBug) { continue }

    # Timestamp from filename: rollout-YYYY-MM-DDTHH-MM-SS-<id>.jsonl
    $startedAt = $null
    $fnMatch = [regex]::Match($f.Name, 'rollout-(\d{4}-\d{2}-\d{2})T(\d{2})-(\d{2})-(\d{2})')
    if ($fnMatch.Success) {
        $startedAt = $fnMatch.Groups[1].Value + 'T' + $fnMatch.Groups[2].Value + ':' + $fnMatch.Groups[3].Value + ':' + $fnMatch.Groups[4].Value
    }

    $sessionId = $null; $parentThreadId = $null; $rootSessionId = $null; $cwd = $null
    $firstLine = ($raw -split "`n")[0]
    try {
        $meta = $firstLine | ConvertFrom-Json
        if ($meta.type -eq 'session_meta') {
            $sessionId = $meta.payload.id
            $parentThreadId = $meta.payload.parent_thread_id
            $rootSessionId = $meta.payload.session_id
            $cwd = $meta.payload.cwd
        }
    } catch {}

    # Collect messages
    $userEnvelope = $null
    $assistantTexts = New-Object System.Collections.Generic.List[string]
    $devIdentity = $null
    foreach ($line in ($raw -split "`n")) {
        if ($line -notlike '*"type":"response_item"*' -and $line -notlike '*"type":"event_msg"*') { continue }
        try { $obj = $line | ConvertFrom-Json } catch { continue }
        $p = $obj.payload
        if ($null -eq $p) { continue }
        if ($obj.type -eq 'response_item' -and $p.type -eq 'message') {
            $txt = ''
            foreach ($c in $p.content) { if ($c.text) { $txt += $c.text } }
            if ($p.role -eq 'assistant') { $assistantTexts.Add($txt) }
            elseif ($p.role -eq 'user' -and $txt.StartsWith('You are the `')) {
                if ($null -eq $userEnvelope) { $userEnvelope = $txt } else { $userEnvelope = $userEnvelope + "`n" + $txt }
            }
            elseif ($p.role -eq 'developer' -and $txt -match 'Its identity is `([a-z_]+)`') {
                $devIdentity = $Matches[1]
            }
        }
    }

    if ($isProd) {
        $finalOutput = $null
        for ($i = $assistantTexts.Count - 1; $i -ge 0; $i--) {
            if ($assistantTexts[$i].Contains('## Verdict')) { $finalOutput = $assistantTexts[$i]; break }
        }
        $failureText = $null
        if ($null -eq $finalOutput -and $assistantTexts.Count -gt 0) { $failureText = $assistantTexts[$assistantTexts.Count - 1] }

        $verdict = ''; $verdictClass = 'NO_OUTPUT'
        if ($null -ne $finalOutput) {
            $vm = [regex]::Match($finalOutput, '(?m)^## Verdict\s*\r?\n+(.+?)\s*$')
            if ($vm.Success) { $verdict = $vm.Groups[1].Value }
            if ($verdict -match '^APPROVED') { $verdictClass = 'APPROVED' }
            elseif ($verdict -match '^CHANGES REQUESTED') { $verdictClass = 'CHANGES REQUESTED' }
            elseif ($verdict) { $verdictClass = 'OTHER' }
        } elseif ($null -ne $failureText) {
            $verdictClass = 'STRUCTURAL_FAIL'
            $verdict = ($failureText -split "`n")[0]
        }

        $sections = @{}
        foreach ($s in @('Blocking findings','Non-blocking findings','Architecture alignment','Supersession closure','Lifecycle and naming closure','Regression matrix','Blocking test/docs','Batchable (deferred)','CI gate status')) {
            $sections[$s] = [bool]($finalOutput -and $finalOutput.Contains('## ' + $s))
        }

        $blk = $null; $nb = $null; $btd = $null; $bat = $null
        if ($finalOutput) {
            $blk = Get-SectionText $finalOutput 'Blocking findings'
            $nb = Get-SectionText $finalOutput 'Non-blocking findings'
            $btd = Get-SectionText $finalOutput 'Blocking test/docs'
            $bat = Get-SectionText $finalOutput 'Batchable (deferred)'
        }

        $iteration = $null
        if ($userEnvelope) {
            $im = [regex]::Match($userEnvelope, 'Review iteration[^0-9]*(\d+)')
            if ($im.Success) { $iteration = [int]$im.Groups[1].Value }
        }
        $gate = $null
        if ($userEnvelope) {
            $gm = [regex]::Match($userEnvelope, 'Completion gate[^\r\n]*')
            if ($gm.Success) { $gate = $gm.Value.Trim() }
        }
        $ciMode = $null
        if ($userEnvelope) {
            $cm = [regex]::Match($userEnvelope, '(?i)ci mode[^\r\n]*')
            if ($cm.Success) { $ciMode = $cm.Value.Trim() }
        }

        $rec = [ordered]@{
            file = $f.Name
            startedAt = $startedAt
            rootThreadId = $rootSessionId
            parentThreadId = $parentThreadId
            childThreadId = $sessionId
            repo = if ($cwd) { Split-Path $cwd -Leaf } else { $null }
            cwd = $cwd
            devIdentity = $devIdentity
            verdictClass = $verdictClass
            verdict = $verdict
            iteration = $iteration
            completionGate = $gate
            ciMode = $ciMode
            sections = $sections
            blockingCount = (Count-NumberedItems $blk)
            nonBlockingCount = (Count-NumberedItems $nb)
            blockingTestDocsCount = (Count-NumberedItems $btd)
            batchableCount = (Count-NumberedItems $bat)
            blockingHasFileLine = [bool]($blk -and $blk -match ':\d+')
            outputChars = if ($finalOutput) { $finalOutput.Length } else { 0 }
            failureFirstLine = if ($verdictClass -eq 'STRUCTURAL_FAIL') { $verdict } else { $null }
        }
        $prodRecords.Add([pscustomobject]$rec)
    }

    if ($isBug) {
        $bugFinal = $null
        for ($i = $assistantTexts.Count - 1; $i -ge 0; $i--) {
            if ($assistantTexts[$i].Contains('<answer>') -or $assistantTexts[$i].Contains('CLEAN')) { $bugFinal = $assistantTexts[$i]; break }
        }
        $bugClean = [bool]($bugFinal -and $bugFinal -match '(?m)^\s*CLEAN\s*$')
        $bugCount = $null
        if ($bugFinal) { $bugCount = [regex]::Matches($bugFinal, '<bug>').Count }
        $bugRecords.Add([pscustomobject][ordered]@{
            file = $f.Name
            startedAt = $startedAt
            rootThreadId = $rootSessionId
            parentThreadId = $parentThreadId
            childThreadId = $sessionId
            repo = if ($cwd) { Split-Path $cwd -Leaf } else { $null }
            clean = $bugClean
            findingCount = $bugCount
        })
    }
}

$prodRecords | ForEach-Object { $_ | ConvertTo-Json -Compress -Depth 5 } | Set-Content -Path $launchesPath -Encoding UTF8
$bugRecords | ForEach-Object { $_ | ConvertTo-Json -Compress -Depth 5 } | Set-Content -Path $bugPath -Encoding UTF8

Write-Output ("Production reviewer launch files: {0}" -f $prodRecords.Count)
Write-Output ("Bug reviewer launch files: {0}" -f $bugRecords.Count)
Write-Output ("Launches written to: {0}" -f $launchesPath)
