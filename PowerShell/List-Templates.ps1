$Templates = Get-Template
$Inventory= ForEach ($Template in $Templates) {
    "" | Select-Object -Property @{N="Name";E={$Template.Name}},
    @{N="vCPU";E={$Template.ExtensionData.Config.Hardware.NumCPU}},
    @{N="Memory (MB)";E={$Template.ExtensionData.Config.Hardware.MemoryMB}},    
    @{N="Number of Hard Disks";E={($Template | Get-HardDisk | Measure-Object).Count}},
    @{N="Size of Hard Disks";E={[string]::Join(',',(($Template |Get-HardDisk).CapacityKB))}}
}

$Inventory