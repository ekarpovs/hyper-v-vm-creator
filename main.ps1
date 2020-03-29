########################################
#
# Runs all 3 scripts sequentially 
#
# Requires PowerShell Version 5
#
# Usage: .\main.ps1
#
########################################

# Include functions
. .\functions.ps1

Clear-Host

.\unpack.ps1 unpack.json
Get-Status

.\convert.ps1 convert.json vbm
Get-Status

.\create-vm.ps1 create-vm.json
Get-Status

Write-Host "Done!"
exit(0)