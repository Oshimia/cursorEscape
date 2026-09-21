#Requires -Version 7.0
# cursorEscape-managed:v1 source="overlays/codex/hooks/subagent_reminder.ps1"; standalone generated Codex hook.
# Stateless Codex Stop reminder. No agent inventory or persistent state.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    $rawInput = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($rawInput)) { exit 0 }

    $payload = $rawInput | ConvertFrom-Json
    $eventName = $payload.PSObject.Properties['hook_event_name']
    if ($null -eq $eventName -or [string]$eventName.Value -ne 'Stop') { exit 0 }

    $stopHookActive = $payload.PSObject.Properties['stop_hook_active']
    if ($null -ne $stopHookActive -and [bool]$stopHookActive.Value) { exit 0 }

    $reminder = 'Before finishing, review spawned subagents. Close any finished agents that are no longer needed with the available multi-agent close tool; retain agents that are still required.'
    [Console]::Out.Write(([ordered]@{
        decision = 'block'
        reason = $reminder
    } | ConvertTo-Json -Compress))
}
catch {
    # A reminder must never trap the Codex turn loop.
}

exit 0
