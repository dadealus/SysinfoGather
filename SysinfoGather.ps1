#    Author         : Ryan Gilbert @xelnaga15
#    GitHub         : https://github.com/dadealus
#    Version        : 1.02
Write-Host "Dade's SystemInfoGather"
Function Get-SystemInfo {
    # Get Processor information
    $processor = Get-WmiObject Win32_Processor | Select-Object Name

    # Get GPU information
    $gpu = Get-WmiObject Win32_VideoController | Select-Object Caption

    # Get Installed RAM
    $ram = Get-WmiObject Win32_ComputerSystem | Select-Object TotalPhysicalMemory

    # Output the information to the console
    Write-Host "Processor Type: $($processor.Name)"
    Write-Host "GPU Name: $($gpu.Caption)"
    Write-Host "Installed RAM: $([math]::Round($ram.TotalPhysicalMemory / 1GB, 2)) GB"
}

Function Get-PartitionInfo {
    param (
        [string]$DriveLetter
    )

    # Get partition information for the specified drive
    $partitions = Get-WmiObject Win32_DiskPartition | Where-Object { $_.DeviceID -like "$DriveLetter*" } | Sort-Object DeviceID

    foreach ($partition in $partitions) {
        $partitionLetter = $partition.DeviceID
        $partitionSizeGB = [math]::Round($partition.Size / 1GB, 2)
        $partitionFreeSpaceGB = [math]::Round(($partition.Size - $partition.TotalVirtualMemorySize) / 1GB, 2)

        Write-Host "  Partition Letter: $partitionLetter"
        Write-Host "  Partition Size: $partitionSizeGB GB"
        Write-Host "  Free Space: $partitionFreeSpaceGB GB"
    }
}

Function Get-DriveInfo {
    # Get drive information
    $drives = Get-WmiObject Win32_DiskDrive | Where-Object { $_.MediaType -ne "USB" } | Sort-Object MediaType, InterfaceType | Select-Object DeviceID, Model, Size, InterfaceType

    # Output drive information to the console
    foreach ($drive in $drives) {
        $driveLetter = $drive.DeviceID
        $driveModel = $drive.Model
        $totalSpaceGB = [math]::Round($drive.Size / 1GB, 2)
        $interfaceType = $drive.InterfaceType

        Write-Host "Drive Letter: $driveLetter"
        Write-Host "Drive Model: $driveModel"
        Write-Host "Total Space: $totalSpaceGB GB"
        Write-Host "Interface Type: $interfaceType"
        Write-Host "-------------------------"
    }
}


Function Get-MotherboardInfo {
    # Get motherboard information
    $motherboard = Get-WmiObject Win32_BaseBoard | Select-Object Product

    # Output the motherboard model to the console
    Write-Host "Motherboard Model: $($motherboard.Product)"
}


sleep 2
# Display system information
Write-Host "----- System Information -----"
Get-SystemInfo

# Display drive information
Write-Host "----- Drive Information -----"
Get-DriveInfo

# Display partition information for each drive
$drives = Get-WmiObject Win32_DiskDrive | Where-Object { $_.MediaType -ne "USB" } | Sort-Object MediaType, InterfaceType | Select-Object -ExpandProperty DeviceID


    Write-Host "----- Partition Information for Drives -----"
    Get-PartitionInfo
    Write-Host "-------------------------"

# Display motherboard information
Write-Host "----- Motherboard Information -----"
Get-MotherboardInfo
