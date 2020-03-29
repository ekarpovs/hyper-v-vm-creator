# Hyper-V Virtual Machine batch creator (Windows 10)
  
* version: "0.5.0",
* author: "Evgeny Karpovsky @ekarpovs",

Set of Power shell scripts for create Hyper-V Virtual Machine from ova.zip (ova) file.

* unpack.ps1 - unpacks an ova.zip file.
* convert.ps1 - converts a vmdk file to vhd format.
* create-vm.ps1 - creates new Hyper-V VM.
* main.ps1 - runs all 3 scripts sequentially.

Requires PowerShell Version 5

Tested on Microsoft Windows 10 Pro only

## 1. Unpack OVA.ZIP file

Usage:

```bash
  .\unpack.ps1 unpack.json
```

Configuration:

```bash
  {
    "src": {
      "path": "Path to directory where the ova.zip file is located",
      "file": "Your ova.zip file name"
    },
    "dst": {
      "path": "Path to directory where to the vmdk file will be placed",
      "file": "Your vmdk file name"
    }
  }
```

  The script unpacks the OVA.ZIP (OVA) file by three steps:

* Unpack ova.zip to ova - optional

* OVA is just a tar file, so before unpack it, change 'ova' extension to 'tar'

* Unpack the tar - has to be produced VMDK file

## 2. Convert from VMDK to VHD

Usage:

```bash
  .\convert.ps1 convert.json  [msc | vbm]
  where:
    msc - Microsoft VM Converter Powershell Module
    vbm - Oracle VM Virtual Box Manager
  default - vbm
```

Configuration:

```bash
  {
    "converter": "Path to MvmcCmdlet.psd1",
    "vbman": "Path to  VBoxManage.exe",
    "mdk": {
      "path": "Path to directory where the vmdk file is located",
      "file": "Your vmdk file name"
    },
    "vhd": {
      "path": "Path to directory where to the vhd file will be placed",
      "file": "Your vhd file name"
    }
  }
```

  The script may to use one of two different tools for OVA VMDK convertion

1. Microsoft VM Converter Powershell Module
2. Oracle VM Virtual Box Manager in command line mode

## 3. Create New Hyper-V Virtual Machine

Usage:

```bash
  .\create-vm.ps1 create-vm.json
```

Configuration:

```bash
  {
    "hyperv": {
      "vswitch": {
        "name": "Your Virtual Switch name"
      },
      "vm": {
        "name": "new hyper-V VM name",
        "memory": "VM memory size in GB)",
        "generation": "1",
        "vhdpath": "Path to directory where the VHD file is located",
        "vhd": "Your VHD file name"
      }
    }
  }
```

NOTE: (for Microsoft VM Converter Powershell Module)

Install from: https://www.microsoft.com/en-us/download/details.aspx?id=42497

How to resolve issue like The entry xxxxxx is not a supported disk database entry for the descriptor

From: https://www.hashmat00.com/convertto-mvmcvirtualharddisk-vmware-to-hypverv-error/

* download dsfok tool from: https://www.mysysadmintips.com/-downloads-/Windows/Servers/dsfok.zip
* Extract VMDK descriptor by running:

```bash
  dsfo.exe “Full PathTo VMDK\your.vmdk” 512 1024 “Full PathTo VMDK\descriptor.txt”
```

* Open descriptor.txt with Notepad++ or other text editor.
* Find the line that appeared in the error above and comment it out by adding '#' in front of the line.
* Save the file.
* Save VMDK descriptor back int VMDK file by running:

```bash
 dsfi.exe “Full PathTo VMDK\your.vmdk” 512 1024 “Full PathTo VMDK\descriptor.txt”
```

  The error above will only list the first entry, so you may need to repeat the process few times
until you find and remove all problematic entries.
