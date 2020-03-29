Function Get-Status {
  if( $LASTEXITCODE -eq 0 ) {
    Write-Output "Command executed successfully"
    # do something, like `Restart-Computer -Force`
  } else {
    Write-Output "Last command failed"
    exit(1)
  } 
}

Function Wait-UserInput {
  Write-Host "Press 'y' to continue or any other key to terminate"
  While (!$KeyInfo.VirtualKeyCode -Or $Ignore -Contains $KeyInfo.VirtualKeyCode) {
    $KeyInfo = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
  #  Write-Host "Pressed: " $KeyInfo.Character
    if ($KeyInfo.Character -eq 'y') {
      Show-Step "Continue..."
      break
    }
    Show-Step "Terminate..."
    exit(0)
  }
}

Function Show-Step {
  Param($mess)
  Write-Host
  Write-Host $mess
  Write-Host  
}

Function Show-UnpackParameters {
  Write-Host
  Write-Host "The process will be executed with the following parameters:"
  Write-Host "Source :" $SrcPath\$SrcFile
  Write-Host "Destination :" $DstPath\$DstFile
  Write-Host
}

Function Update-UnpackConfig {
  Param($cfg)
  # Replace default values
  if (!$cfg.src.path) {
    Write-Host "SRC path - default value will be used"
  } else {
    ([ref]$SrcPath).value = $cfg.src.path
  }

  if (!$cfg.src.file) {
    Write-Host "SRC file - default value will be used"
  } else {
    ([ref]$SrcFile).value = $cfg.src.file
  }

  if (!$cfg.dst.path) {
    Write-Host "DST path - default value will be used"
  } else {
    ([ref]$DstPath).value = $cfg.dst.path
  }

  if (!$cfg.dst.file) {
    Write-Host "DST file - default value will be used"
  } else {
    ([ref]$DstFile).value = $cfg.dst.file
  }
}


Function Show-ConvParameters {
  Write-Host
  Write-Host "The process will be executed with the following parameters:"
  Write-Host "MDK File :" $MDKPath\$MDKName
  Write-Host "VHD File :" $VHDPath\$VHDName
  if ($Converter -eq "msc") {
    Write-Host "Converter: " $MsVmConverter
  } else {
    Write-Host "Conveter: " $VBManager
  }
  Write-Host
}

Function Update-ConvConfig {
  Param($cfg)
  # Define the Microsoft VM Converter Powershell Module
  ([ref]$MsVmConverter).value = $cfg.converter
  # Define Virtual Box Manager
  ([ref]$VBManager).value = $cfg.vbman

  # Replace default values
  if (!$cfg.mdk.path) {
    Write-Host "MDK path - default value will be used"
  } else {
    ([ref]$MDKPath).value = $cfg.mdk.path
  }

  if (!$cfg.mdk.file) {
    Write-Host "MDK file - default value will be used"
  } else {
    ([ref]$MDKFile).value = $cfg.mdk.file
  }

  if (!$cfg.vhd.path) {
    Write-Host "VHD path - default value will be used"
  } else {
    ([ref]$VHDPath).value = $cfg.vhd.path
  }

  if (!$cfg.vhd.file) {
    Write-Host "VHD name - default value will be used"
  } else {
    ([ref]$VHDFile).value = $cfg.vhd.file
  }
}



Function Show-VmParameters {
  Write-Host
  Write-Host "The new Hyper-V VM will be created with the following parameters:"
  Write-Host "Virtual Switch Name:" $VSWName
  Write-Host "Virtual Machine Name :" $VMName
  Write-Host "Virtual Machine Generation :" $VMGeneration
  Write-Host "VHD File :" $VHDPath\$VHDName
  Write-Host "Memory Startup Size :" $MemoryStartupSize
  Write-Host
}

Function Update-VmConfig {
  Param($cfg)
  # Replace default values
  if (!$cfg.hyperv.vswitch.name) {
    Write-Host "Switch name - default value will be used"
  } else {
    ([ref]$VSWName).value = $cfg.hyperv.vswitch.name
  }

  if (!$cfg.hyperv.vm.name) {
    Write-Host "VM name - default value will be used"
  } else {
    ([ref]$VMName).value = $cfg.hyperv.vm.name
  }

  if (!$cfg.hyperv.vm.generation) {
    Write-Host "VM generation - default value will be used"
  } else {
    ([ref]$VMGeneration).value = $cfg.hyperv.vm.generation
  }

  if (!$cfg.hyperv.vm.vhdpath) {
    Write-Host "VHD path - default value will be used"
  } else {
    ([ref]$VHDPath).value = $cfg.hyperv.vm.vhdpath
  }

  if (!$cfg.hyperv.vm.vhd) {
    Write-Host "VHD name - default value will be used"
  } else {
    ([ref]$VHDName).value = $cfg.hyperv.vm.vhd
  }

  if (!$cfg.hyperv.vm.memory) {
    Write-Host "VM start memory size- default value will be used"
  } else {
    $size_in_bytes = Invoke-Expression $cfg.hyperv.vm.memory
    ([ref]$MemoryStartupSize).value = $size_in_bytes
  }
}


