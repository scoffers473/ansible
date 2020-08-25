 <#
.NAME
	Get-VMDetails.ps1
.SYNOPSIS
	Gets the VM Details
.AUTHOR
	Chris Scoffield
.DATE
	22 / 09 / 2017
.VERSION
	1.0
.CHANGELOG
    31 / 07 / 2020 - v1.0 - Initial Script (Chris Scoffield)
	
#>

# Variables
param(
[string]$vC,
[string]$vCUser,
[string]$vCPassword
)


Import-Module -Name VMware.VimAutomation.Core 
$VerbosePreference = 'Continue'

#Connect to vCenter
Connect-VIServer $vC -User $vCUser -Password $vCPassword #-WarningAction 0

$VMs = Get-VM | Sort-Object -Property Name
$VMDetails = @()

foreach ($VM in $VMs ) {
    $name = $VM.Name
    $powerstate = $VM.Powerstate
    $cpu = $VM.NumCPU
    $mem = $VM.MemoryGB
    $disks = $VM.Guest.Disks
    $IPs = $VM.Guest.IPAddress
    $OS= $VM.Guest.OSFullName
    $formattedDisks = ""
    $formattedIPs=""
    $OutName = $vC + ".csv"
    
    foreach ($disk in $disks) {
            $path=$disk.path
            $size = $disk.capacity / 1073741824 | % { '{0:0.##}' -f $_ }
            $workingdisk = $path + "--" + $size
            $formattedDisks += $workingdisk
    }

    foreach ($IP in $IPS) {
        $formattedIPs += $IP
    }

    $details = @{            
        Name           = $name              
        PowerState     = $powerstate                 
        CPU            = $cpu
        Memory         = $mem
        OS             = $OS
        IP_Addresses   = $formattedIPs
        Disks          = $formattedDisks
    }

    $VMDetails += New-Object PSObject -Property $details
}


Disconnect-VIServer -Confirm:$false

$VMDetails | Export-Csv -Path $OutName