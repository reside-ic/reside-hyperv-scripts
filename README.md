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

| Machine                 | Cores | RAM | Disk | MAC | IP        |
|-------------------------|-------|-----|------|-----|-----------|
| wpia-vault              |   1   | 4   |  50  | 01  | dide      |
| wpia-mint               |   2   | 16  | 500  | 02  | dide      |
| wpia-data               |   2   | 2   | 100  | 03  | dide      |
| wpia-bots               |   1   | 2   | 100  | 05  | dide      |
|                         |       |     |      | 36  | 14.0.0.36 |
| wpia-mint-dev           |   2   | 16  | 500  | 06  | dide      |
| wpia-covid19-forecasts  |   6   | 32  | 1000 | 08  | dide      |
| wpia-comet              |   2   | 8   | 100  | 09  | dide      |
| wpia-hermod-dev         |   2   | 16  | 100  | 07  | dide      |
|                         |       |     |      | 37  | 14.0.0.20 |
| wpia-hermod-1           |   2   | 16  | 100  | 34  | 14.0.0.21 |
| wpia-hermod-2           |   2   | 16  | 100  | 35  | 14.0.0.21 |
| wpia-wodin-dev          |   2   | 4   | 200  | 12  | dide      |
| wpia-epimodels          |   12  | 64  | 200  | 13  | dide      |
| wpia-beebop             |   10  | 64  | 500  | 14  | dide      |
| wpia-malaria-orderly    |   2   | 64  | 1000 | 15  | dide      |
| wpia-orderly            |   4   | 32  | 500  | 16  | dide      |
| wpia-packit-dev         |   4   |  8  | 500  | 17  | dide      |
| wpia-shiny-dev          |   4   |  8  | 500  | 18  | dide      |
| wpia-shiny-dev-worker1  |   2   |  2  | 100  | 38  | dide      |
| wpia-shiny-dev-worker2  |   2   |  2  | 100  | 39  | dide      |
| reside-bk1              |   1   | 16  | 100  | 20  | 14.0.0.2  |
| reside-bk2              |   1   | 16  | 100  | 21  | 14.0.0.3  |
| reside-bk3              |   1   | 16  | 100  | 22  | 14.0.0.4  |
| reside-bk4              |   1   | 16  | 100  | 23  | 14.0.0.5  |
| reside-bk5              |   1   | 16  | 100  | 24  | 14.0.0.6  |
| reside-bk6              |   1   | 16  | 100  | 25  | 14.0.0.7  |
| reside-bk7              |   1   | 16  | 100  | 26  | 14.0.0.8  |
| reside-bk8              |   1   | 16  | 100  | 27  | 14.0.0.9  |
| reside-deploy1          |   1   | 1   | 100  | 28  | 14.0.0.10 |
| reside-bk-browser-test1 |   4   | 64  | 100  | 29  | 14.0.0.11 |
| reside-bk-multicore1    |   4   | 64  | 100  | 30  | 14.0.0.12 |
| reside-bk-multicore2    |   4   | 64  | 100  | 31  | 14.0.0.13 |
| reside-bk-multicore3    |   4   | 64  | 100  | 32  | 14.0.0.14 |
| reside-privilege-walk   |  2    | 32  | 100  | 33  | dide      |

## Usage of whole machine:

|                      | Total     | VM allocated | Spare |
|----------------------|-----------|--------------|-------|
| Cores (logical)      |    96     | 87           | 9     |
| RAM (Gb)             |  1024     | 744          | 152   |
| DISK (D: SSD) (Tb)   |  11.6     | 8.5          | 3.1   |

## Retired VMs

| Machine                | Cores | RAM | Disk | MAC |     IP   |
|------------------------|-------|-----|------|-----|----------|
| wpia-monkeypox         |   4   | 64  | 200  | 11  |   dide   |
| wpia-db-experiment     |   2   | 128 | 2000 | 10  |   dide   |
| wpia-ncov-dev          |   10  | 64  | 1000 | 07  |   dide   |


Note:

* Hyperthreading is turned on, as recommended for Hyper-V. So this
  machine has 48 physical cores, 96 logical ones. We'll perhaps see
  how that performs if we fill the machine. For now, we seem to
  be within physical core usage.
* Figures represent allocated resources; looking at task manager
  will give smaller usage figures, as Hyper-V will only allocate
  real resources when they are demanded. Disk usage will grow as
  the VM fills it.
* Note that RAM is also shared with operating system - hard to
  estimate how much the OS really needs. 16Gb perhaps?
* DISK is not shared with OS though - the D: is separate. Remember
  to allocate for the disk-space for the VM, and also its RAM, since
  the VM swap/hibernation files are also written to the disk.

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

### For Ubuntu 20 and earlier:-
* Restart the VM, and... 
```
sudo growpart /dev/sda 3
sudo resize2fs /dev/sda3
```

### For Ubuntu 22:-

Ubuntu 22 changed something about logical volumes, and an extra
step might be needed. 

* Restart the VM, then `sudo lsblk`.

If you see something like this:

```
sda                         8:0    0   500G  0 disk
├─sda1                      8:1    0     1M  0 part
├─sda2                      8:2    0     2G  0 part /boot
└─sda3                      8:3    0   126G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0    63G  0 lvm  /
```

then you first have to make `sda3` as big as `sda`. 

``` 
sudo growpart /dev/sda 3
sudo lsblk
```

and hopefully you now see something like 

```
sda                         8:0    0   500G  0 disk
├─sda1                      8:1    0     1M  0 part
├─sda2                      8:2    0     2G  0 part /boot
└─sda3                      8:3    0   498G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0    63G  0 lvm  /
```

Now, we need to make the ubuntu--vg as big as sda3. 

```
sudo lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
sudo lsblk
```


and hopefully the partition has now grown:-

```
sda                         8:0    0   500G  0 disk
├─sda1                      8:1    0     1M  0 part
├─sda2                      8:2    0     2G  0 part /boot
└─sda3                      8:3    0   498G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0   498G  0 lvm  /
```

## Diagnostics / Monitoring with a GUI

* Run `Hyper-V Manager` from the Start bar.
* You'll immediately see the VMs and their status, and right clicking on them
will get you to their settings, or options to connect to them, turn them off/on, etc.
* Deleting a VM through this interface does not delete the VM's disk(s), which is
probably a good thing. If you do want to really purge the VM and start again, then
delete the drives manually from `D:\VMs\vmname`, and then the `vmname` folder.
