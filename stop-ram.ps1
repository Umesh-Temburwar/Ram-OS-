# Stop RAM OS - terminate python venv process and release port 7777.
$killed = $false
Get-CimInstance Win32_Process -Filter "Name='python.exe'" -ErrorAction SilentlyContinue | Where-Object {
  $_.CommandLine -like '*server\main.py*'
} | ForEach-Object {
  Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
  Write-Host "  - Stopped python PID $($_.ProcessId)"
  $killed = $true
}
Get-NetTCPConnection -LocalPort 7777 -State Listen -ErrorAction SilentlyContinue | ForEach-Object {
  Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue
  Write-Host "  - Stopped PID $($_.OwningProcess) on port 7777"
  $killed = $true
}
if (-not $killed) { Write-Host '  (No running server found)' }
exit 0

