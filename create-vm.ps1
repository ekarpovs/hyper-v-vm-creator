########################################
#
# Create New Hyper-V VM
#
# Requires PowerShell Version 5
#
# Usage: .\create-vm.ps1 create-vm.json
#
# References:
# 1. Check and set Hyper-V support:
#   https://www.onmsft.com/how-to/how-to-install-a-virtual-machine-on-windows-10-using-hyper-v-now-even-easier-with-quick-create
#
# 2. Hyper-V commands:
#   https://docs.microsoft.com/en-us/powershell/module/hyper-v/?view=win10-ps
#
########################################

# Include functions
. .\functions.ps1

# Clear-Host

Show-Step "Start..."

# Default VM configuation
$VSWName = "virtSwitch"
$VMName = "vm"
$VMGeneration = 1
$VHDPath = ".\vhd"
$VHDName = "vm.vhd"
$MemoryStartupSize = 1GB

# Read configuration
$ConfigFile = $args[0]
Write-Host "Use configuration file :" $ConfigFile
$config=Get-Content -Path .\config\\$ConfigFile -Raw | ConvertFrom-Json

Update-VmConfig $config

Show-VmParameters

Wait-UserInput

# Create, start and show status of the new HyperV VM
$params = @{
  Name = $VMName
  MemoryStartupBytes = $MemoryStartupSize
  VHDPath = "$VHDPath\$VHDName"
  Generation = $VMGeneration
  SwitchName = $VSWName
}
New-VM @params
Start-VM $VMName
Get-VM $VMName

exit(0)

