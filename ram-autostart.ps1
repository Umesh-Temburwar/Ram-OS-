param([string]$Action = "status")

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Startup = [Environment]::GetFolderPath("Startup")
$RunKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$Approved = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
$Name = "RamOS"

switch ($Action.ToLower()) {
  "install" {
    $vbs = Join-Path $Root "start-ram.vbs"
    if (-not (Test-Path $vbs)) {
      Write-Host "start-ram.vbs not found."
      exit 1
    }
    $cmd = "wscript.exe //nologo `"$vbs`" /open"
    if (-not (Test-Path $RunKey)) { New-Item -Path $RunKey -Force | Out-Null }
    Set-ItemProperty -Path $RunKey -Name $Name -Value $cmd
    Write-Host "RAM OS autostart enabled on Windows login."
  }
  "uninstall" {
    Remove-ItemProperty -Path $RunKey -Name $Name -ErrorAction SilentlyContinue
    Write-Host "RAM OS autostart disabled."
  }
  default {
    $val = (Get-ItemProperty -Path $RunKey -Name $Name -ErrorAction SilentlyContinue).$Name
    if ($val) {
      Write-Host "RAM OS autostart: ENABLED ($val)"
    } else {
      Write-Host "RAM OS autostart: DISABLED"
    }
  }
}

