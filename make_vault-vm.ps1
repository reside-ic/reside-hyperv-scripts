
$vmname = "vault-vm"
$FQDN = "vault-vm.dide.ic.ac.uk"
$cores = 1
$max_memory = 4GB
$start_memory = 1GB
$disk_size = 50GB
$os = "D:\ISOs\ubuntu-20.04-server-cloudimg-amd64.img"
$mac = "00:15:5d:1a:84:01"
$rootpassword = "ubuntu"
$switch = "External Switch"

./tools/New-VMFromUbuntuImage.ps1 -SourcePath $os -VMName $vmname -RootPassword $rootpassword -FQDN $FQDN -VHDXSizeBytes $disk_size  -MemoryStartupBytes $start_memory -EnableDynamicMemory -ProcessorCount $cores -SwitchName $switch -MacAddress $mac -InstallDocker
