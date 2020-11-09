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

| Machine      | Cores | RAM | Disk | MAC |     IP   |
|--------------|-------|-----|------|-----|----------|
| wpia-vault   |   1   |  4  |  50  |  01 |   dide   |
| wpia-mint    |   2   | 16  | 500  |  02 |   dide   |
| wpia-data    |   2   | 16  | 100  |  03 |   dide   |
| build-kite1  |   1   | 16  | 100  |  20 | 14.0.0.2 |
| build-kite2  |   1   | 16  | 100  |  21 | 14.0.0.3 |
| build-kite3  |   1   | 16  | 100  |  22 | 14.0.0.4 |
| build-kite4  |   1   | 16  | 100  |  23 | 14.0.0.5 |
| build-kite5  |   1   | 16  | 100  |  24 | 14.0.0.6 |
| reside-test8 |   8   |  64 |  -   |  04 | 14.0.0.8 | 

## How to create a new VM with this repo

* If this VM is to be accessible to DIDE, inform Chris of the `wpia-newname`
and MAC address, and request an IP address. Note that all machines and VMs needed
to start with `wpia-` for their official name, but we can create friendly aliases
for those names, which will work for all purposes (ssh, browsing, certs). Ask Chris
at the same time for an alias to the machine. 

* This might take 30 minutes to come live, at which point you should be able to ping 
`wpia-newname.dide.ic.ac.uk` (and if any alias you made to it) and see an IP address 
resolved. If not, talk to Chris before continuing, because probably bad things will
happen if the new VM doesn't get an IP address.

* Remote Desktop to `wpia-reside1.dide.ic.ac.uk` with DIDE details, and run Powershell
from the desktop icon, which should put you in this folder.

* We're now using vagrant for creating hyperv VMs. See the `reside-test8` folder 
for an example. The only disadvantage compared to Powershell is the inability
to set a maximum disk size, which is probably not critical. The example has
simple variables for the CPU, RAM, IP, MAC and hostname. 

* Then you should be able to connect to the new VM. For a local non-dide machine, use
Putty on wpia-reside1 to that IP address; for DIDE machines, any DIDE machine will do.
Login with `vagrant` / `vagrant`. 

## Diagnostics / Monitoring with a GUI

* Run `Hyper-V Manager` from the Start bar.
* You'll immediately see the VMs and their status, and right clicking on them
will get you to their settings, or options to connect to them, turn them off/on, etc.
* Deleting a VM through this interface does not delete the VM's disk(s), which is 
probably a good thing. If you do want to really purge the VM and start again, then
delete the drives manually from `D:\VMs\vmname`, and then the `vmname` folder.
