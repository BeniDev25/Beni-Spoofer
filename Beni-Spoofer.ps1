$ScriptVersion = "1.0"
$UserName = Read-Host "Enter your name"
$ExtraPath = Join-Path $PSScriptRoot "EXTRA"
$SpoofFile = Join-Path $ExtraPath "tempspoofing.bat"
$PermSpoofFile = Join-Path $ExtraPath "permspoofing.bat"
$RevertFile = Join-Path $ExtraPath "revertspoofing.bat"
$BackupFile = Join-Path $PSScriptRoot "Serials_Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

function Write-Log {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [ValidateSet("Info", "Warning", "Error")]
        [string]$Level = "Info"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    $color = switch ($Level) {
        "Info" { "White" }
        "Warning" { "Yellow" }
        "Error" { "Red" }
    }
    Write-Host $logMessage -ForegroundColor $color
}

function Wait-ForKey {
    Write-Host "Press any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Show-Menu {
    Clear-Host
    $asciiArt = @"
  ____             _ __      ____                     __           
 | __ )  ___ _ __ (_)_/___  / ___| _ __   ___   ___  / _| ___ _ __ 
 |  _ \ / _ \ '_ \| | / __| \___ \| '_ \ / _ \ / _ \| |_ / _ \ '__|
 | |_) |  __/ | | | | \__ \  ___) | |_) | (_) | (_) |  _|  __/ |   
 |____/ \___|_| |_|_| |___/ |____/| .__/ \___/ \___/|_|  \___|_|   
                                  |_|                              
"@
    Write-Host $asciiArt -ForegroundColor Magenta
    Write-Host "          Welcome $UserName to Beni's Spoofer $ScriptVersion" -ForegroundColor Magenta
    Write-Host "          Also, if the spoofer isnt working its probably because of EAC or because of you!"-ForegroundColor Magenta
    Write-Host "          ==============================" -ForegroundColor DarkCyan
    Write-Host
    Write-Host "  [1] Temporary Spoof " -ForegroundColor Cyan
    Write-Host "  [2] Permanent Spoof" -ForegroundColor Cyan
    Write-Host "  [3] Revert Spoofing" -ForegroundColor Cyan
    Write-Host "  [4] Check Hardware Serials" -ForegroundColor Cyan
    Write-Host "  [5] Backup Hardware Serials" -ForegroundColor Cyan
    Write-Host "  [7] Check System Uptime (just added that j4f lol)" -ForegroundColor Cyan
    Write-Host "  [8] Credits" -ForegroundColor Cyan
    Write-Host "  [9] Exit" -ForegroundColor Red
    Write-Host
    Write-Host "Select an option:" -ForegroundColor White -NoNewline
}

function Get-ValidInput {
    do {
        $input = Read-Host
        if ($input -match '^[1-9]$') {
            return $input
        }
        Write-Log "Invalid input. Please enter a number between 1 and 9." -Level Warning
        Write-Host "Select an option:" -ForegroundColor White -NoNewline
    } while ($true)
}

function Confirm-Action {
    param($Prompt)
    Write-Host $Prompt -ForegroundColor Yellow
    $response = Read-Host "(Y/N)"
    return $response -match '^[Yy]$'
}

function Show-Credits {
    Clear-Host
    Write-Host '==================================' -ForegroundColor Magenta
    Write-Host '           CREDITS' -ForegroundColor Magenta
    Write-Host '==================================' -ForegroundColor Magenta
    Write-Host
    Write-Host "Beni's Spoofer v$ScriptVersion" -ForegroundColor Cyan
    Write-Host "Developed by:" -ForegroundColor Cyan
    Write-Host "  - BeniDev25" -ForegroundColor Green
    Write-Host "  - Bytedev0" -ForegroundColor Green
    Write-Host
    Write-Host "Thank you for using our tool!" -ForegroundColor Cyan
    Write-Host "We hope it serves you well. If you encounter any issues, it's probably EAC or user error! :)" -ForegroundColor Cyan
    Wait-ForKey
}

function Temp-Spoof {
    Clear-Host
    Write-Log "Initiating temporary spoofing..." -Level Info
    if (-not (Confirm-Action "Are you sure you want to temporarily spoof hardware IDs?")) {
        Write-Log "Temporary spoofing cancelled by user." -Level Warning
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
        return
    }

    Write-Log "Checking for tempspoofing.bat in: $ExtraPath" -Level Info
    try {
        if (-not (Test-Path $ExtraPath)) {
            throw "EXTRA folder not found at: $ExtraPath"
        }
        if (-not (Test-Path $SpoofFile)) {
            throw "tempspoofing.bat not found at: $SpoofFile"
        }
        Write-Log "Executing: $SpoofFile" -Level Info
        Write-Host "Running temporary spoofing... Please wait." -ForegroundColor Cyan
        Start-Process -FilePath $SpoofFile -Verb RunAs -Wait -ErrorAction Stop
        Write-Log "Temporary spoofing completed." -Level Info
        Write-Host "Temporary spoofing completed." -ForegroundColor Green
    } catch {
        Write-Log "Temporary spoofing failed: $($_.Exception.Message)" -Level Error
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Ensure the EXTRA folder and tempspoofing.bat exist." -ForegroundColor Red
    }
    Wait-ForKey
}

function Perm-Spoof {
    Clear-Host
    Write-Log "Initiating permanent spoofing..." -Level Info
    if (-not (Confirm-Action "Are you sure you want to permanently spoof hardware IDs? (Feature in development)")) {
        Write-Log "Permanent spoofing cancelled by user." -Level Warning
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
        return
    }

    Write-Log "Checking for permspoofing.bat in: $ExtraPath" -Level Info
    try {
        if (-not (Test-Path $ExtraPath)) {
            throw "EXTRA folder not found at: $ExtraPath"
        }
        if (-not (Test-Path $PermSpoofFile)) {
            throw "permspoofing.bat not found at: $PermSpoofFile"
        }
        Write-Log "Executing: $PermSpoofFile" -Level Info
        Write-Host "Running permanent spoofing... Please wait." -ForegroundColor Cyan
        Start-Process -FilePath $PermSpoofFile -Verb RunAs -Wait -ErrorAction Stop
        Write-Log "Permanent spoofing completed." -Level Info
        Write-Host "Permanent spoofing completed." -ForegroundColor Green
    } catch {
        Write-Log "Permanent spoofing failed: $($_.Exception.Message)" -Level Error
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Ensure the EXTRA folder and permspoofing.bat exist." -ForegroundColor Red
    }
    Wait-ForKey
}

function Revert-Spoof {
    Clear-Host
    Write-Log "Initiating revert spoofing..." -Level Info
    if (-not (Confirm-Action "Execute revertspoofing.bat from EXTRA folder?")) {
        Write-Log "Revert operation cancelled by user." -Level Warning
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
        return
    }

    Write-Log "Checking for revertspoofing.bat in: $ExtraPath" -Level Info
    try {
        if (-not (Test-Path $ExtraPath)) {
            throw "EXTRA folder not found at: $ExtraPath"
        }
        if (-not (Test-Path $RevertFile)) {
            throw "revertspoofing.bat not found at: $RevertFile"
        }
        Write-Log "Executing: $RevertFile" -Level Info
        Write-Host "Running revert operation... Please wait." -ForegroundColor Cyan
        Start-Process -FilePath $RevertFile -Verb RunAs -Wait -ErrorAction Stop
        Write-Log "Revert spoofing completed." -Level Info
        Write-Host "Revert spoofing completed." -ForegroundColor Green
    } catch {
        Write-Log "Revert spoofing failed: $($_.Exception.Message)" -Level Error
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Ensure the EXTRA folder and revertspoofing.bat exist." -ForegroundColor Red
    }
    Wait-ForKey
}

function Check-Serials {
    Clear-Host
    Write-Log "Checking hardware serials..." -Level Info
    Write-Host '========================================' -ForegroundColor Magenta
    Write-Host '         HARDWARE SERIAL CHECK' -ForegroundColor Magenta
    Write-Host '========================================' -ForegroundColor Magenta
    Write-Host
    try {
        # Helper function to determine spoofing status
        function Get-SpoofStatus {
            param(
                [string]$Serial,
                [string]$Type
            )
            if ([string]::IsNullOrWhiteSpace($Serial)) {
                return "Error: Missing"
            }
            switch ($Type) {
                "Disk" {
                    if ($Serial -match "^0+$" -or $Serial -eq "N/A") {
                        return "Possibly Spoofed"
                    }
                }
                "CPU" {
                    if ($Serial -eq "None" -or $Serial -eq "To Be Filled By O.E.M.") {
                        return "Possibly Spoofed"
                    }
                }
                "BIOS" {
                    if ($Serial -eq "None" -or $Serial -eq "To Be Filled By O.E.M.") {
                        return "Possibly Spoofed"
                    }
                }
                "Motherboard" {
                    if ($Serial -eq "None" -or $Serial -eq "To Be Filled By O.E.M.") {
                        return "Possibly Spoofed"
                    }
                }
                "UUID" {
                    if ($Serial -eq "00000000-0000-0000-0000-000000000000" -or $Serial -eq "Not Present") {
                        return "Possibly Spoofed"
                    }
                }
                "MAC" {
                    if ($Serial -match "00:00:00:00:00:00" -or $Serial -match "FF:FF:FF:FF:FF:FF") {
                        return "Possibly Spoofed"
                    }
                }
            }
            return "Original"
        }


        Write-Host '--- DISK DRIVES ---' -ForegroundColor Cyan
        $diskDrives = Get-CimInstance -ClassName Win32_DiskDrive | Select-Object -Property Model, SerialNumber
        foreach ($disk in $diskDrives) {
            $status = Get-SpoofStatus -Serial $disk.SerialNumber -Type "Disk"
            $color = if ($status -eq "Original") { "Green" } elseif ($status -eq "Possibly Spoofed") { "Yellow" } else { "Red" }
            Write-Host "Model: $($disk.Model)" -ForegroundColor Cyan
            Write-Host "Serial: $($disk.SerialNumber) [$status]" -ForegroundColor $color
            Write-Host
            Write-Log "Disk Drive ($($disk.Model)): $($disk.SerialNumber) [$status]" -Level Info
        }

        Write-Host '--- CPU ---' -ForegroundColor Cyan
        $cpuSerial = Get-CimInstance -ClassName Win32_Processor | Select-Object -ExpandProperty SerialNumber -First 1
        $cpuStatus = Get-SpoofStatus -Serial $cpuSerial -Type "CPU"
        $cpuColor = if ($cpuStatus -eq "Original") { "Green" } elseif ($cpuStatus -eq "Possibly Spoofed") { "Yellow" } else { "Red" }
        Write-Host "Serial: $cpuSerial [$cpuStatus]" -ForegroundColor $cpuColor
        Write-Host
        Write-Log "CPU Serial: $cpuSerial [$cpuStatus]" -Level Info

        Write-Host '--- BIOS ---' -ForegroundColor Cyan
        $biosSerial = Get-CimInstance -ClassName Win32_BIOS | Select-Object -ExpandProperty SerialNumber -First 1
        $biosStatus = Get-SpoofStatus -Serial $biosSerial -Type "BIOS"
        $biosColor = if ($biosStatus -eq "Original") { "Green" } elseif ($biosStatus -eq "Possibly Spoofed") { "Yellow" } else { "Red" }
        Write-Host "Serial: $biosSerial [$biosStatus]" -ForegroundColor $biosColor
        Write-Host
        Write-Log "BIOS Serial: $biosSerial [$biosStatus]" -Level Info

        Write-Host '--- MOTHERBOARD ---' -ForegroundColor Cyan
        $mbSerial = Get-CimInstance -ClassName Win32_BaseBoard | Select-Object -ExpandProperty SerialNumber -First 1
        $mbStatus = Get-SpoofStatus -Serial $mbSerial -Type "Motherboard"
        $mbColor = if ($mbStatus -eq "Original") { "Green" } elseif ($mbStatus -eq "Possibly Spoofed") { "Yellow" } else { "Red" }
        Write-Host "Serial: $mbSerial [$mbStatus]" -ForegroundColor $mbColor
        Write-Host
        Write-Log "Motherboard Serial: $mbSerial [$mbStatus]" -Level Info

        Write-Host '--- SMBIOS UUID ---' -ForegroundColor Cyan
        $uuid = Get-CimInstance -ClassName Win32_ComputerSystemProduct | Select-Object -ExpandProperty UUID -First 1
        $uuidStatus = Get-SpoofStatus -Serial $uuid -Type "UUID"
        $uuidColor = if ($uuidStatus -eq "Original") { "Green" } elseif ($uuidStatus -eq "Possibly Spoofed") { "Yellow" } else { "Red" }
        Write-Host "UUID: $uuid [$uuidStatus]" -ForegroundColor $uuidColor
        Write-Host
        Write-Log "smBIOS UUID: $uuid [$uuidStatus]" -Level Info

        Write-Host '--- MAC ADDRESS ---' -ForegroundColor Cyan
        $mac = getmac | Where-Object { $_ -match "([0-9A-F]{2}-){5}[0-9A-F]{2}" } | Select-Object -First 1
        $macStatus = Get-SpoofStatus -Serial $mac -Type "MAC"
        $macColor = if ($macStatus -eq "Original") { "Green" } elseif ($macStatus -eq "Possibly Spoofed") { "Yellow" } else { "Red" }
        Write-Host "MAC: $mac [$macStatus]" -ForegroundColor $macColor
        Write-Host
        Write-Log "MAC Address: $mac [$macStatus]" -Level Info

        Write-Host '========================================' -ForegroundColor Magenta
        Write-Host "Note: Spoofing detection is may not 100% accurate." -ForegroundColor Yellow
    } catch {
        Write-Log "Failed to retrieve hardware serials: $($_.Exception.Message)" -Level Error
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    Wait-ForKey
}

function Backup-Serials {
    Clear-Host
    Write-Log "Backing up serials to: $BackupFile" -Level Info
    try {
        $serialData = @"
=== Hardware Serials Backup ===

--- DISK DRIVES ---
$(Get-CimInstance -ClassName Win32_DiskDrive | Select-Object -Property Model, SerialNumber | Format-Table -AutoSize | Out-String)

--- CPU ---
$(Get-CimInstance -ClassName Win32_Processor | Select-Object -ExpandProperty SerialNumber)

--- BIOS ---
$(Get-CimInstance -ClassName Win32_BIOS | Select-Object -ExpandProperty SerialNumber)

--- Motherboard ---
$(Get-CimInstance -ClassName Win32_BaseBoard | Select-Object -ExpandProperty SerialNumber)

--- smBIOS UUID ---
$(Get-CimInstance -ClassName Win32_ComputerSystemProduct | Select-Object -ExpandProperty UUID)

--- MAC ADDRESS ---
$(getmac)
"@
        $serialData | Out-File -FilePath $BackupFile -Encoding UTF8
        Write-Log "Serials backed up to: $BackupFile" -Level Info
        Write-Host "Backup completed: $BackupFile" -ForegroundColor Green
    } catch {
        Write-Log "Backup failed: $($_.Exception.Message)" -Level Error
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    Wait-ForKey
}

function Reset-NetworkAdapters {
    Clear-Host
    Write-Log "Initiating network adapter reset..." -Level Info
    if (-not (Confirm-Action "Disable and re-enable all network adapters?")) {
        Write-Log "Network adapter reset cancelled." -Level Warning
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
        return
    }

    try {
        Write-Log "Disabling network adapters..." -Level Info
        Write-Host "Disabling network adapters..." -ForegroundColor Cyan
        Get-NetAdapter | Disable-NetAdapter -Confirm:$false -ErrorAction Stop
        Start-Sleep -Seconds 2
        Write-Log "Re-enabling network adapters..." -Level Info
        Write-Host "Re-enabling network adapters..." -ForegroundColor Cyan
        Get-NetAdapter | Enable-NetAdapter -Confirm:$false -ErrorAction Stop
        Write-Log "Network adapters reset successfully." -Level Info
        Write-Host "Network adapters reset successfully." -ForegroundColor Green
    } catch {
        Write-Log "Network adapter reset failed: $($_.Exception.Message)" -Level Error
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    Wait-ForKey
}

function Check-SystemUptime {
    Clear-Host
    Write-Log "Checking system uptime..." -Level Info
    Write-Host '==================================' -ForegroundColor Magenta
    Write-Host '       SYSTEM UPTIME' -ForegroundColor Magenta
    Write-Host '==================================' -ForegroundColor Magenta
    Write-Host
    try {
        $os = Get-CimInstance -ClassName Win32_OperatingSystem
        $uptime = (Get-Date) - $os.LastBootUpTime
        $uptimeString = "System Uptime: $($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes, $($uptime.Seconds) seconds"
        Write-Host $uptimeString -ForegroundColor Cyan
        Write-Log $uptimeString -Level Info
    } catch {
        Write-Log "Failed to retrieve system uptime: $($_.Exception.Message)" -Level Error
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    Wait-ForKey
}

Write-Host "Welcome $UserName!" -ForegroundColor Green
Start-Sleep -Seconds 1

if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Log "PowerShell version 5.1 or higher required." -Level Error
    Write-Host "Error: PowerShell version 5.1 or higher required." -ForegroundColor Red
    Wait-ForKey
    exit
}

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Log "Script must be run as Administrator." -Level Error
    Write-Host "Error: This script requires Administrator privileges." -ForegroundColor Red
    Wait-ForKey
    exit
}

do {
    Show-Menu
    $input = Get-ValidInput

    switch ($input) {
        '1' { Temp-Spoof }
        '2' { Perm-Spoof }
        '3' { Revert-Spoof }
        '4' { Check-Serials }
        '5' { Backup-Serials }
        '6' { Reset-NetworkAdapters }
        '7' { Check-SystemUptime }
        '8' { Show-Credits }
        '9' {
            Write-Host "Goodbye $UserName!" -ForegroundColor Green
            Start-Sleep -Seconds 1
            exit 0
        }
    }
} while ($true)