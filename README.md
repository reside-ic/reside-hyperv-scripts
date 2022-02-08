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
the MAC addresses will be in the form `00:15:5d:1a:84:xx`. IP address will either be
local, with `14.0.0.1` as the gateway, or a DIDE assigned IP address. Those existing so far:-

| Machine                | Cores | RAM | Disk | MAC |     IP   |
|------------------------|-------|-----|------|-----|----------|
| wpia-vault             |   1   |  4  |  50  |  01 |   dide   |
| wpia-mint              |   2   | 16  | 500  |  02 |   dide   |
| wpia-data              |   2   | 16  | 100  |  03 |   dide   |
| wpia-bots              |   1   |  2  | 100  |  05 |   dide   |
| wpia-mint-dev          |   2   | 16  | 500  |  06 |   dide   |
| wpia-ncov-dev          |   10  | 64  | 1000 |  07 |   dide   |
| wpia-covid19-forecasts |   6   | 32  | 1000 |  08 |   dide   |
| wpia-comet             |   2   |  8  | 100  |  09 |   dide   |
| wpia-db-experiment     |   2   | 64  | 500  |  10 |   dide   |
| build-kite1            |   1   | 16  | 100  |  20 | 14.0.0.2 |
| build-kite2            |   1   | 16  | 100  |  21 | 14.0.0.3 |
| build-kite3            |   1   | 16  | 100  |  22 | 14.0.0.4 |
| build-kite4            |   1   | 16  | 100  |  23 | 14.0.0.5 |
| build-kite5            |   1   | 16  | 100  |  24 | 14.0.0.6 |
| build-kite6            |   1   | 16  | 100  |  25 | 14.0.0.7 |
| build-kite7            |   1   | 16  | 100  |  26 | 14.0.0.8 |
| build-kite8            |   1   | 16  | 100  |  27 | 14.0.0.9 |

## How to create a new VM with this repo

* Note that wpia-vault, wpia-mint and wpia-data were created with a legacy method.
  We'll let them be, but for new VMs, use the Vagrant methods below.

### For machines that don't need a DIDE IP address

* Skip the next paragraph about contacting Chris, and then copy defaults
  from the `build-kite` folder instead of bots.

### For machines that need a DIDE IP address

* The VM  should be named `wpia-something`. Create a PR on this repo, updating
  the table above with a MAC address. Contact Chris in IT and ask for an IP address,
  providing him with the MAC address, the `wpia-something` name, and letting him
  know this will be a VM running on wpia-reside1. You may also want to request that
  he creates an alias for `wpia-something` called just `something`. This may take
  15 or 30 minutes - wait until you can ping `wpia-something.dide.ic.ac.uk` before
  continuing.

* Remote Desktop to `wpia-reside1.dide.ic.ac.uk` with DIDE details; there should be
  a `Command Prompt` icon on the desktop, which has been made as linux-compatible
  as possible. You can also use `edit` to fire up `Notepad++` for a reasonably
  sane editing experience.

* Make a new directory for the new machine, copying the defaults from the `bots`
  folder. (Or if you don't need a DIDE IP address, the `build-kite` folder.

```
  D:\reside-hyperv-scripts> md something
  D:\reside-hyperv-scripts> cd something
  D:\reside-hyperv-scripts\something> copy ..\bots\Vagrantfile
          1 file(s) copied.
  D:\reside-hyperv-scripts\something> md vm_scripts
  D:\reside-hyperv-scripts\something> copy ..\bots\vm_scripts vm_scripts
  D:\reside-hyperv-scripts\something> edit Vagrantfile
```

* Edit the Vagrantfile. The resources required are at the top, and scripts to
  provision the VM a bit lower.

* `vagrant up` from that folder.

* Then you should be able to connect to the new VM. For a local non-dide machine, use
Putty on wpia-reside1 to the IP address you gave the VM; for DIDE machines, any DIDE
machine will do. Login for the first time with `vagrant` / `vagrant`.

## Disk sizes

* Vagrant does not seem able to manage default disk size with Hyper-V.
* After building a VM, power it off, and use Hyper-V manager to edit
the disk size:- Right click on the VM, Settings, find IDE Controller 0
and Hard-Drive. Edit button, Next, Expand, Next, choose the size.
Next. Finish!
* Restart the VM, and... `sudo growpart /dev/sda 3` followed by
`sudo resize2fs /dev/sda3` will sort it out.

## Diagnostics / Monitoring with a GUI

* Run `Hyper-V Manager` from the Start bar.
* You'll immediately see the VMs and their status, and right clicking on them
will get you to their settings, or options to connect to them, turn them off/on, etc.
* Deleting a VM through this interface does not delete the VM's disk(s), which is
probably a good thing. If you do want to really purge the VM and start again, then
delete the drives manually from `D:\VMs\vmname`, and then the `vmname` folder.
