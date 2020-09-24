
$vmname = "wpia-mint"
$FQDN = "wpia-mint.dide.ic.ac.uk"
$cores = 2
$max_memory = 16GB
$start_memory = 1GB
$disk_size = 500GB
$os = "D:\ISOs\ubuntu-20.04-server-cloudimg-amd64.img"
$mac = "00:15:5d:1a:84:02"
$rootpassword = "ubuntu"
$switch = "External Switch"

./tools/New-VMFromUbuntuImage.ps1 -SourcePath $os -VMName $vmname -RootPassword $rootpassword -FQDN $FQDN -VHDXSizeBytes $disk_size  -MemoryStartupBytes $start_memory -EnableDynamicMemory -ProcessorCount $cores -SwitchName $switch -MacAddress $mac -InstallDocker
