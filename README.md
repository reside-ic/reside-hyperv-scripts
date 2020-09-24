# reside-hyperv-scripts

These scripts relate so far to `wpia-reside1` - a VM host we will be using
to run lots of VMs.

## The Host Machine Specs

* SuperMicro SYS-1029-TN12RV (Motherboard X11DPU-V)
* Dual Intel Xeon Platinum 8628, 24 cores at 2.90GHz, multi-threaded to 48 each.
* 1Tb of 2933MHz RAM
* Quad Intel X710/X557-AT network team
* 240Gb dual SSD for the OS (RAID 1)
* ~12Tb usable NVMe storage (Storage space with redundency)

## Operating System Config

* The system runs Windows Server 2019 with Hyper-V. The `C:` is for Operating System
only, whereas `D:` is the large NVMe space. 
* ISOs for the VM operating systems are in `D:\ISOs`
* Disks for the VMs will be in the form `D:\VMs\vmname\base.vhdx` - should any other
important vm-specific files or notes be needed, put them in that folder too.
* This repo will be sitting in `D:\reside-hyperv-scripts`
* NotePad++ is installed for slightly less painful editing of files. 
* And the command prompt is rigged up with most of the GNU tools.
* For disaster/diagnostics, the IPMI for wpia-reside1 is on `13.0.0.220`, accessible
from wpia-didenas2.

## Staying Sane in the Command Line

* Windows Command line and Powershell are not too bad once you get used to them.
* I've also wired most of the standard GNU tools are wired in. (`diff`, `grep`, 
`tail`, `more`, `cat` - etc. Ask me if any are missing that you want.)
* Also, `edit file.txt` will spawn a NotePad++ editor, which is fairly pleasant.
* All the Hyper-V functionality can be done through either a GUI, or through scripted
PowerShell. The exception is the auto-configuration of Ubuntu, which requires building an ISO
and adding it to the install, which is better done scripted, as below.

## Current VMs

We will statically decide what the MAC addresses is for each virtual machine - all
the MAC addresses will be in the form `00:15:5d:1a:84:xx`. Those existing so far:-

<center>

| Machine    | Cores | RAM | Disk | MAC |
|------------|-------|-----|------|------
| vault-vm   |   1   |  4  |  50  |  01 |

</center>


## How to create a new VM with this repo.

* Choose a unique last pair of digits for the MAC address, decide on the
specs, and add an entry to the table above.

* If this VM is to be accessible to DIDE, inform Chris of the `new-vm-name`
and MAC address, and request an IP address. This might take 30 minutes to come 
live, at which point you should be able to ping `new-vm-name.dide.ic.ac.uk` and 
see an IP address resolved.

* Customise one of the existing scripts, which are in the form `make_new-vm-name.ps1`;
the start contains the config, which may end up looking like this:-
```
$vmname = "new-vm-name"
$FQDN = "new-vm-name.dide.ic.ac.uk"
$cores = 1
$max_memory = 4GB
$start_memory = 1GB
$disk_size = 50GB
$os = "D:\ISOs\ubuntu-20.04-server-cloudimg-amd64.img"
$mac = "00:15:5d:1a:84:02"
$rootpassword = "ubuntu"
$switch = "External Switch"
```

* Run the script by running Powershell as administrator (desktop shortcut), and
(for example) `./make_new-vm-name.ps1` - it will take a couple of minutes.

* Then you should be able to connect with Putty/ssh from any DIDE machine,
and login with user `ubuntu`, and whatever password you specificed in the script.

## Diagnostics / Monitoring with a GUI

* Run `Hyper-V Manager` from the Start bar.
* You'll immediately see the VMs and their status, and right clicking on them
will get you to their settings, or options to connect to them, turn them off/on, etc.
* Deleting a VM through this interface does not delete the VM's disk(s), which is 
probably a good thing. If you do want to really purge the VM and start again, then
delete the drives manually from `D:\VMs\vmname`, and then the `vmname` folder.
