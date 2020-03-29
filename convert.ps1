
########################################
#
# Convert VM to Hyper-V VHD
#
# Requires PowerShell Version 5
#
# Usage: .\convert.ps1 convert.json [msc | vbm]
#
########################################

# Include functions
. .\functions.ps1

# Clear-Host

Show-Step "Start..."

# Microsoft VM Converter Powershell Module
$MsVmConverter = ""
# Virtual-Box Manager
$VBManager = ""
# Default process configuation
# Input
$MDKPath = ".\mdk"
$MDKFile = "vm.vmdk"
# Output
$VHDPath = ".\vhd"
$VHDFile = "vm.vhd"

# Read cmd arguments
$ConfigFile = $args[0]
$Converter = $args[1]
if (!$Converter) {
  # Use Virtual Box Manager converter by the default
  $Converter = "vbm"
}
Write-Host "Use configuration file :" $ConfigFile
Write-Host "Use convertor :" $Converter
# Read configuration
$config=Get-Content -Path .\config\\$ConfigFile -Raw | ConvertFrom-Json

Update-ConvConfig $config

Show-ConvParameters

Wait-UserInput
Show-Step "Convert vmdk to vhd format..."

if ($Converter -eq "msc") {
  # Import the Microsoft VM Converter Powershell Module.
  Import-Module $MsVmConverter
  # Use it
  ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath "$MDKPath\$MDKFile" -DestinationLiteralPath $VHDPath -VhdType DynamicHardDisk -VhdFormat Vhd
} else {
  $arglist = "clonemedium $MDKPath\$MDKFile $VHDPath\$VHDFile --format vhd"
  $proc = Start-Process -FilePath $VBManager -NoNewWindow -PassThru -ArgumentList $arglist
  Wait-Process -InputObject $proc 
}

exit(0)

