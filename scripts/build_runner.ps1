# Run Drift / Riverpod code generation
# Usage: powershell -ExecutionPolicy Bypass -File scripts\build_runner.ps1
#        or: powershell -ExecutionPolicy Bypass -File scripts\build_runner.ps1 watch

$env:Path = "C:\flutter\bin;C:\flutter\bin\cache\dart-sdk\bin;C:\Windows\System32\WindowsPowerShell\v1.0;C:\Program Files\Git\bin;C:\Program Files\Git\cmd;" + $env:Path

Set-Location $PSScriptRoot\..

$mode = if ($args[0] -eq "watch") { "watch" } else { "build" }
$flags = if ($mode -eq "build") { "--delete-conflicting-outputs" } else { "" }

Write-Host "Running build_runner $mode ..."
& "C:\flutter\bin\cache\dart-sdk\bin\dart.exe" run build_runner $mode $flags
Write-Host "Done (exit $LASTEXITCODE)"
