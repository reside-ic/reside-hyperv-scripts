# Currently assume this is run in its own directory.

if ($args.count -eq 0) {
  write-host "Syntax: ./build_agents <id> to build a single agent"
  write-host "    or  ./build_agents <id1> <id2> to build agents id1..id2 inclusive"
  exit 1
}

$agents_from = $args[0]
$agents_to = $agents_from

if ($args.count -eq 2) {
  $agents_to = $args[1]
}

$count_agents = 1 + ($agents_to - $agents_from)
write-host ""
write-host "Building $count_agents agent(s)"
write-host ""

$VAULT_ADDR = $env:VAULT_ADDR
$VAULT_AUTH_GITHUB_TOKEN = $env:VAULT_AUTH_GITHUB_TOKEN

if ($VAULT_ADDR -eq $null) {
  write-host "VAULT_ADDR not found in environment"
  $VAULT_ADDR = read-host "Enter VAULT_ADDR (eg, https://vault.myhost.com:8200) >"
  write-host ""
}

if ($VAULT_AUTH_GITHUB_TOKEN -eq $null) {
  write-host "VAULT_AUTH_GITHUB_TOKEN not found in environment"
  $VAULT_AUTH_GITHUB_TOKEN = read-host "Paste your token: >"
  write-host ""
}

# Can/should we do any validation here before spinning up the VMs?
# curl -H "Authorization: token OAUTH-TOKEN" https://api.github.com/users/codertocat -I

Set-Location "VMs"
Set-Content -Path "vault_config" -Value "VAULT_ADDR=$VAULT_ADDR"
Add-Content -Path "vault_config" -Value "VAULT_AUTH_GITHUB_TOKEN=$VAULT_AUTH_GITHUB_TOKEN"


# vagrant doesn't seem to support hot-wiring the network settings for hyper-v,
# so I don't think we can use multi-machine with it. Have to do that loop ourselves. 

for ($agent = $agents_from; $agent -le $agents_to; $agent++) {

  # Abort if there's a VM already existing with this id...
  
  if (Test-Path $agent) {
    write-host "Path VMs/$agent already exists. Aborting"
	Set-Location ".."
	exit 1
  }
  
  New-Item -ItemType Directory -Force -Path $agent
  Set-Location $agent
  
  # Create the setup_network file
  
  $ip = $agent + 1
  
  Set-Content -Path "setup-network.sh" -Value "sudo ip addr add 14.0.0.$ip/24 dev eth0"
  Add-Content -Path "setup-network.sh" -Value "sudo ip route add default via 14.0.0.1 dev eth0"
  Add-Content -Path "setup-network.sh" -Value "sudo ip link set eth0 up"
  
  # Work out MAC address. Start at $20 (decimal 32). ip for first host = 2
  
  $mac_end =  '{0:x}' -f (30 + $ip)
  $mac_address = "00:15:5d:1a:84:$mac_end"
  $host_name = "reside-bk$agent"
  
  # Copy main Vagrantfile
  
  Copy-Item "../Vagrantfile_template" -Destination "."
  
  # And fill in the blanks.
  
  (Get-Content "./Vagrantfile_template") | FOREACH-OBJECT {
    $_ -replace '<MAC>', $mac_address `
	   -replace '<HOSTNAME>', $host_name
  } | SET-CONTENT "./Vagrantfile"
  
  Remove-Item "./Vagrantfile_template"
  
  # Bring it up.
  
  # Start-Process -FilePath "vagrant" -ArgumentList "up"
    
  Set-Location ".."
}

Set-Location ".."
