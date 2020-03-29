########################################
#
# Unpack zip/tar 
#
# Requires PowerShell Version 5
#
# Usage: .\unpack.ps1 unpack.json
#
########################################

# Include functions
. .\functions.ps1

# Clear-Host

Show-Step "Start..."

# Default process configuation
$SrcPath = ".\src"
$SrcFile = "vm.ova.zip"
$DstPath = ".\dst"
$DstFile = "vm-d1.vmdk"

# Read configuration
$ConfigFile = $args[0]
Write-Host "Use configuration file :" $ConfigFile
$config=Get-Content -Path .\config\\$ConfigFile -Raw | ConvertFrom-Json

Update-UnpackConfig $config
Show-UnpackParameters

Wait-UserInput

if (Test-Path -Path $DstPath\$DstFile) {
  Show-Step "Destination $DstPath\$DstFile already exists. Done!"
  exit(0)
}

# Check arc format
if (Test-Path -Path $SrcPath\$SrcFile) {
  # If ova was zipped - unzip the file to OVA format
  Show-Step "Unzip $SrcFile to ova file..."
  Expand-7Zip -ArchiveFileName "$SrcPath\$SrcFile" -TargetPath "$DstPath"
}

$ovafile = $SrcFile.Substring(0, $SrcFile.length-4)
$ovaname = $ovafile.Substring(0, $ovafile.length-4)
$tarfile = "$ovaname.tar"

# Write-Host "ovafile: " $ovafile 
# Write-Host "ovaname: " $ovaname
# Write-Host "tarfile": "$tarfile"

# OVA is just a tar file, so before unpack it, change ova extension to tar
if (Test-Path -Path $DstPath\$ovafile) {
  Show-Step "Change the $ovafile to $tarfile"
  Rename-Item -Path "$DstPath\$ovafile" -NewName $tarfile
}
# Wait-UserInput

# Now unpack the ova(tar) file
# $tar = Split-Path -Path $DstPath\*.tar -Resolve -leaf
if (!(Test-Path -Path $DstPath\$tarfile)) {
  Show-Step "tar file does not exists..."
  exit(1)
}

Show-Step "Extract vmdk file from the $tarfile..."
Expand-7Zip -ArchiveFileName "$DstPath\$tarfile" -TargetPath $DstPath

# Get the vmdk file and rename in to new $MDKName
$vmdk = Split-Path -Path $DstPath\*.vmdk -Resolve -leaf

Show-Step "Rename $vmdk to $DstFile..."
Rename-Item -Path "$DstPath\$vmdk" -NewName $DstFile

exit(0)
