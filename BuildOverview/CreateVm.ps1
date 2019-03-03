

$vm = New-AzVm `
    -ResourceGroupName "myResourceGroup" `
    -Name "myVM" `
    -Location "East US" `
    -VirtualNetworkName "myVnet" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIpAddress" `
    -OpenPorts 80,3389


$publicSettings = @{
  OctopusServerUrl = "https://octopus.example.com";
  Environments = @("Env1", "Env2");
  Roles = @("app-server", "web-server");
  CommunicationMode = "Listen";
  Port = 10933
}

$privateSettings = @{"ApiKey" = "<MY SECRET API KEY>"}

Set-AzureRmVMExtension -ResourceGroupName "<resource-group-name>" `
    -Location "Australia East" `
    -VMName "<vm-name>" `
    -Name "OctopusDeployWindowsTentacle" `
    -Publisher "OctopusDeploy.Tentacle" `
    -TypeHandlerVersion "2.0" `
    -Settings $publicSettings `
    -ProtectedSettings $privateSettings `
    -ExtensionType "OctopusDeployWindowsTentacle"

# optional - add an NSG rule to allow the Octopus Server to contact the Tentacle
# only required in Listening mode
$vm = Get-AzureRmVm -Name "<vm-name>" -ResourceGroupName "<resource-group-name>"
$nic = Get-AzureRmNetworkInterface -ResourceGroupName "<resource-group-name>" | ? { $_.VirtualMachine.Id -eq $vm.Id -and $_.Primary }
$secGrp = Get-AzureRmNetworkSecurityGroup -ResourceGroupName "<resource-group-name>" | ? { $_.Id -eq $nic.NetworkSecurityGroup.Id }
$secGrp | Add-AzureRmNetworkSecurityRuleConfig `
    -Name "AllowTentacleInBound" `
    -Description "Allow inbound traffic to Tentacle" `
    -Protocol TCP `
    -SourcePortRange "*" `
    -SourceAddressPrefix "*" `
    -DestinationPortRange 10933 `
    -DestinationAddressPrefix "*" `
    -Access Allow `
    -Priority 999 `
    -Direction Inbound
$secGrp | Set-AzureRmNetworkSecurityGroup
i