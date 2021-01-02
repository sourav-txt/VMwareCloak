#################################################
## VMwareCloak.ps1: A script that attempts to hide the VMware Workstation hypervisor from malware by modifying registry keys, killing associated processes, and removing uneeded driver/system files.
## Written and tested on Windows 7 and Windows 10.
## Many thanks to pafish for some of these ideas :) - https://github.com/a0rtega/pafish
##################################################
## Author: d4rksystem
## Version: 0.1
##################################################

# Define command line parameters
param (
    [switch]$all = $false,
    [switch]$reg = $false,
    [switch]$procs = $false,
    [switch]$files = $false
)

if ($all) {
    $reg = $true
    $procs = $true
    $files = $true
}

# Menu / Helper stuff
Write-Output 'VMwareCloak.ps1 by @d4rksystem (Kyle Cucci)'
Write-Output 'Usage: VMwareCloak.ps1 -<option>'
Write-Output 'Example Usage: VMwareCloak.ps1 -all'
Write-Output 'Options:'
Write-Output 'all: Enable all options.'
Write-Output 'reg: Make registry changes.'
Write-Output 'procs: Kill processes.'
Write-Output 'files: Make file system changes.'
Write-Output 'Make sure to run as Admin!'
Write-Output '*****************************************'

# Stop VMware Processes
if ($procs) {

    Write-Output '[*] Attempting to kill VMware processes...'

    $vmtoolsd = Get-Process "vmtoolsd" -ErrorAction SilentlyContinue

    if ($vmtoolsd) {
        $vmtoolsd | Stop-Process -Force
        Write-Output '[*] vmtoolsd process killed!'
    }

    if (!$vmtools) {
        Write-Output '[!] vmtoolsd process does not exist!'
    }

    $vm3dservice = Get-Process "vm3dservice" -ErrorAction SilentlyContinue

    if ($vm3dservice) {
        $vm3dservice | Stop-Process -Force
        Write-Output '[*] vm3dservice process killed!'
    }

    if (!$vm3dservice) {
        Write-Output '[!] vm3dservice process does not exist!'
    }

    $VGAuthService = Get-Process "VGAuthService" -ErrorAction SilentlyContinue

    if ($VGAuthService) {
        $VGAuthService | Stop-Process -Force
        Write-Output '[*] VGAuthServiceprocess killed!'
    }

    if (!$VGAuthService) {
        Write-Output '[!] VGAuthService process does not exist!'
    }
}

# Modify VMware registry keys
if ($reg) {

    # Modify system BIOS information

    if (Get-ItemProperty -Path "HKLM:\HARDWARE\Description\System" -Name "SystemBiosVersion" -ErrorAction SilentlyContinue) {

        Write-Output "[*] Modifying Reg Key HKLM:\HARDWARE\Description\System\SystemBiosVersion..."
        Set-ItemProperty -Path "HKLM:\HARDWARE\Description\System" -Name "SystemBiosVersion" -Value "LOLBIOSv2"

        Write-Output "[*] Modifying Reg Key HKLM:\HARDWARE\Description\System\BIOS\BIOSVendor..."
        Set-ItemProperty -Path "HKLM:\HARDWARE\Description\System\BIOS" -Name "BIOSVendor" -Value "Nope, Inc."

        Write-Output "[*] Modifying Reg Key HKLM:\HARDWARE\Description\System\BIOS\BIOSVersion..."
        Set-ItemProperty -Path "HKLM:\HARDWARE\Description\System\BIOS" -Name "BIOSVersion" -Value "LOLBIOSv2"

        Write-Output "[*] Modifying Reg Key HKLM:\HARDWARE\Description\System\BIOS\SystemManufacturer..."
        Set-ItemProperty -Path "HKLM:\HARDWARE\Description\System\BIOS" -Name "SystemManufacturer" -Value "Nope, Inc."

        Write-Output "[*] Modifying Reg Key HKLM:\HARDWARE\Description\System\BIOS\SystemProductName..."
        Set-ItemProperty -Path "HKLM:\HARDWARE\Description\System\BIOS" -Name "SystemProductName" -Value "LOLBIOSv2"

    } Else {

        Write-Output '[!] Reg Key HKLM:\HARDWARE\Description\System\SystemBiosVersion does not seem to exist! Skipping this one...'
    }

   # Remove VMware RunKeys in Registry

   if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "VMware User Process" -ErrorAction SilentlyContinue) {

        Write-Output "[*] Removing Reg Key HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\VMware User Process..."
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "VMware User Process"

     } Else {

        Write-Output '[!] Reg Key HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\VMware User Process does not seem to exist! Skipping this one...'
    }

    if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "VMware VM3DService Process" -ErrorAction SilentlyContinue) {

        Write-Output "[*] Removing Reg Key HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\VMware VM3DService Process..."
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "VMware VM3DService Process"

     } Else {

        Write-Output '[!] Reg Key HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\VMware VM3DService Process does not seem to exist! Skipping this one...'
    }

    # Rename VMware OEMID Reg Key

    if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Store\Configuration" -Name "OEMID" -ErrorAction SilentlyContinue) {

        Write-Output "[*] Modifying Reg Key HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Store\Configuration\OEMID"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Store\Configuration" -Name "OEMID" -Value "NOPE"

    } Else {

        Write-Output '[!] Reg Key HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Store\Configuration\OEMID does not seem to exist, or has already been renamed! Skipping this one...'
    }

    # Rename VMwareHostOpen Reg Key

    if (Get-Item -Path "HKLM:\SOFTWARE\Classes\Applications\VMwareHostOpen.exe" -ErrorAction SilentlyContinue) {

        Write-Output "[*] Modifying Reg Key HKLM:\SOFTWARE\Classes\Applications\VMwareHostOpen.exe"
        Rename-Item -Path "HKLM:\SOFTWARE\Classes\Applications\VMwareHostOpen.exe" -NewName "Nope.exe"

    } Else {

        Write-Output '[!] Reg Key HKLM:\SOFTWARE\Classes\Applications\VMwareHostOpen.exe does not seem to exist, or has already been renamed! Skipping this one...'
    }

     # Rename VMwareHostOpen AssocURL Reg Key

    if (Get-Item -Path "HKLM:\SOFTWARE\Classes\VMwareHostOpen.AssocURL" -ErrorAction SilentlyContinue) {

        Write-Output "[*] Modifying Reg Key HKLM:\SOFTWARE\Classes\VMwareHostOpen.AssocURL"
        Rename-Item -Path "HKLM:\SOFTWARE\Classes\VMwareHostOpen.AssocURL" -NewName "Nope.AssocURL"

    } Else {

        Write-Output '[!] Reg Key HKLM:\SOFTWARE\Classes\VMwareHostOpen.AssocURL does not seem to exist, or has already been renamed! Skipping this one...'
    }

    # Rename VMwareHostOpen Assoc Reg Key

    if (Get-Item -Path "HKLM:\SOFTWARE\Classes\VMwareHostOpen.AssocFile" -ErrorAction SilentlyContinue) {

        Write-Output "[*] Modifying Reg Key HKLM:\SOFTWARE\Classes\VMwareHostOpen.AssocFile"
        Rename-Item -Path "HKLM:\SOFTWARE\Classes\VMwareHostOpen.AssocFile" -NewName "Nope.AssocFile"

    } Else {

        Write-Output '[!] Reg Key HKLM:\SOFTWARE\Classes\VMwareHostOpen.AssocFile does not seem to exist, or has already been renamed! Skipping this one...'
    }

    # Rename VMware Software Reg Key

    if (Get-Item -Path "HKCU:\SOFTWARE\VMware, Inc." -ErrorAction SilentlyContinue) {

        Write-Output "[*] Modifying Reg Key HKCU:\SOFTWARE\VMware, Inc."
        Rename-Item -Path "HKCU:\SOFTWARE\VMware, Inc." -NewName "Nope, Inc."

    } Else {

        Write-Output '[!] Reg Key HKCU:\SOFTWARE\VMware, Inc. does not seem to exist, or has already been renamed! Skipping this one...'
    }

    if (Get-Item -Path "HKLM:\SOFTWARE\VMware, Inc." -ErrorAction SilentlyContinue) {

        Write-Output "[*] Modifying Reg Key HKLM:\SOFTWARE\VMware, Inc."
        Rename-Item -Path "HKLM:\SOFTWARE\VMware, Inc." -NewName "Nope, Inc."

    } Else {

        Write-Output '[!] Reg Key HKLM:\SOFTWARE\VMware, Inc. does not seem to exist, or has already been renamed! Skipping this one...'
    }

    # Rename VMware Registered Application Reg Key

    if (Get-ItemProperty -Path "HKLM:\SOFTWARE\RegisteredApplications" -Name "VMware Host Open" -ErrorAction SilentlyContinue) {

        Write-Output "[*] Removing Reg Key HKLM:\SOFTWARE\RegisteredApplications\VMware Host Open"
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\RegisteredApplications" -Name "VMware Host Open"

    } Else {

        Write-Output '[!] Reg Key HKLM:\SOFTWARE\RegisteredApplications\VMware Host Open does not seem to exist, or has already been renamed! Skipping this one...'
    }

    if (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\RegisteredApplications" -Name "VMware Host Open" -ErrorAction SilentlyContinue) {

        Write-Output "[*] Removing Reg Key HKLM:\SOFTWARE\WOW6432Node\RegisteredApplications\VMware Host Open"
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\RegisteredApplications" -Name "VMware Host Open"

    } Else {

        Write-Output '[!] Reg Key HKLM:\SOFTWARE\WOW6432Node\RegisteredApplications\VMware Host Open does not seem to exist, or has already been renamed! Skipping this one...'
    }
}

<#
    # Modify VMware Hardware Devicemap Values

    for ($i = 0 ; $i -le 5, $i++)
    {
        if (Get-Item -Path "HKLM:\HARDWARE\DEVICEMAP\Scsi\Scsi Port $i\Scsi Bus 0\Target Id 0\Logical Unit Id 0" -Name "Serial" -ErrorAction SilentlyContinue) {

        Write-Output "[*] Modifying Reg Key HKLM:\SOFTWARE\WOW6432Node\RegisteredApplicationss\VMware Host Open"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\RegisteredApplications" -Name "VMware Host Open" -Value "SOFTWARE\Nope, Inc.\NopeOpen\Capabilities"

        } Else {

        Write-Output '[!] Reg Key HKLM:\SOFTWARE\WOW6432Node\RegisteredApplications\VMware Host Open does not seem to exist, or has already been renamed! Skipping this one...'
        }

 #>

# Remove/Rename VMware System Files

if ($files) {

    Write-Output '[*] Attempting to rename C:\Program Files\Common Files\VMware directory...'

    $VMwareCommonFiles = "C:\Program Files\Common Files\VMware"

    if (Test-Path -Path $VMwareCommonFiles) {
        Rename-Item $VMwareCommonFiles "C:\Program Files\Common Files\Nope"
    }

    else {
        Write-Output '[!] C:\Program Files\Common Files\VMware directory does not exist!'
    }

    Write-Output '[*] Attempting to rename C:\Program Files\VMware directory...'

    $VMwareProgramDir = "C:\Program Files\VMware"

    if (Test-Path -Path $VMwareProgramDir) {
        Rename-Item $VMwareProgramDir "C:\Program Files\Nope"
    }

     else {
        Write-Output '[!] C:\Program Files\VMware directory does not exist!'
    }

    Write-Output '[*] Attempting to rename VMware driver files in C:\Windows\System32\drivers\...'
    # We are renaming these files, as opposed to removing them, because Windows doesn't care if we just rename them :)

    Rename-Item "C:\Windows\System32\drivers\vm3dmp-debug.sys" "C:\Windows\System32\drivers\nope1.sys"
    Rename-Item "C:\Windows\System32\drivers\vm3dmp-stats.sys" "C:\Windows\System32\drivers\nope2.sys"
    Rename-Item "C:\Windows\System32\drivers\vm3dmp.sys" "C:\Windows\System32\drivers\nope3.sys"
    Rename-Item "C:\Windows\System32\drivers\vm3dmp_loader.sys" "C:\Windows\System32\drivers\nope4.sys"
    Rename-Item "C:\Windows\System32\drivers\vmhgfs.sys" "C:\Windows\System32\drivers\nope5.sys"
    Rename-Item "C:\Windows\System32\drivers\vmmemctl.sys" "C:\Windows\System32\drivers\nope6.sys"
    Rename-Item "C:\Windows\System32\drivers\vmmouse.sys" "C:\Windows\System32\drivers\nope7.sys"
    Rename-Item "C:\Windows\System32\drivers\vmrawdsk.sys" "C:\Windows\System32\drivers\nope8.sys"
    Rename-Item "C:\Windows\System32\drivers\vmusbmouse.sys" "C:\Windows\System32\drivers\nope9.sys"

    Write-Output '[*] Attempting to rename system files in C:\Windows\System32\...'

    Rename-Item "C:\Windows\System32\vm3dco.dll" "C:\Windows\System32\nope1.dll"
    Rename-Item "C:\Windows\System32\vm3ddevapi64-debug.dll" "C:\Windows\System32\nope2.dll"
    Rename-Item "C:\Windows\System32\vm3ddevapi64-release.dll" "C:\Windows\System32\nope3.dll"
    Rename-Item "C:\Windows\System32\vm3ddevapi64-stats.dll" "C:\Windows\System32\nope4.dll"
    Rename-Item "C:\Windows\System32\vm3ddevapi64.dll" "C:\Windows\System32\nope5.dll"
    Rename-Item "C:\Windows\System32\vm3dgl64.dll" "C:\Windows\System32\nope6.dll"
    Rename-Item "C:\Windows\System32\vm3dglhelper64.dll" "C:\Windows\System32\nope7.dll"
    Rename-Item "C:\Windows\System32\vm3dservice.exe" "C:\Windows\System32\nope.exe"
    Rename-Item "C:\Windows\System32\vm3dum64-debug.dll" "C:\Windows\System32\nope8.dll"
    Rename-Item "C:\Windows\System32\vm3dum64-stats.dll" "C:\Windows\System32\nope9.dll"
    Rename-Item "C:\Windows\System32\vm3dum64.dll" "C:\Windows\System32\nope10.dll"
    Rename-Item "C:\Windows\System32\vm3dum64_10-debug.dll" "C:\Windows\System32\nope11.dll"
    Rename-Item "C:\Windows\System32\vm3dum64_10-stats.dll" "C:\Windows\System32\nope12.dll"
    Rename-Item "C:\Windows\System32\vm3dum64_10.dll" "C:\Windows\System32\nope13.dll"
    Rename-Item "C:\Windows\System32\vm3dum64_loader.dll" "C:\Windows\System32\nope14.dll"
    Rename-Item "C:\Windows\System32\vmGuestLib.dll" "C:\Windows\System32\nope15.dll"
    Rename-Item "C:\Windows\System32\vmGuestLibJava.dll" "C:\Windows\System32\nope16.dll"
    Rename-Item "C:\Windows\System32\vmhgfs.dll" "C:\Windows\System32\nope17.dll"
    Rename-Item "C:\Windows\System32\VMWSU.DLL" "C:\Windows\System32\nope18.dll"

    Write-Output '[*] Attempting to rename system files in C:\Windows\SysWOW64\...'

    Rename-Item "C:\Windows\SysWOW64\vm3ddevapi-debug.dll" "C:\Windows\SysWOW64\nope1.dll"
    Rename-Item "C:\Windows\SysWOW64\vm3ddevapi-release.dll" "C:\Windows\SysWOW64\nope2.dll"
    Rename-Item "C:\Windows\SysWOW64\vm3ddevapi-stats.dll" "C:\Windows\SysWOW64\nope3.dll"
    Rename-Item "C:\Windows\SysWOW64\vm3ddevapi.dll" "C:\Windows\SysWOW64\nope4.dll"
    Rename-Item "C:\Windows\SysWOW64\vm3dgl.dll" "C:\Windows\SysWOW64\nope5.dll"
    Rename-Item "C:\Windows\SysWOW64\vm3dglhelper.dll" "C:\Windows\SysWOW64\nope6.dll"
    Rename-Item "C:\Windows\SysWOW64\vm3dum-debug.dll" "C:\Windows\SysWOW64\nope7.dll"
    Rename-Item "C:\Windows\SysWOW64\vm3dum-stats.dll" "C:\Windows\SysWOW64\nope8.dll"
    Rename-Item "C:\Windows\SysWOW64\vm3dum.dll" "C:\Windows\SysWOW64\nope9.dll"
    Rename-Item "C:\Windows\SysWOW64\vm3dum_10-debug.dll" "C:\Windows\SysWOW64\nope10.dll"
    Rename-Item "C:\Windows\SysWOW64\vm3dum_10-stats.dll" "C:\Windows\SysWOW64\nope11.dll"
    Rename-Item "C:\Windows\SysWOW64\vm3dum_10.dll" "C:\Windows\SysWOW64\nope12.dll"
    Rename-Item "C:\Windows\SysWOW64\vm3dum_loader.dll" "C:\Windows\SysWOW64\nope13.dll"
    Rename-Item "C:\Windows\SysWOW64\vmGuestLib.dll" "C:\Windows\SysWOW64\nope14.dll"
    Rename-Item "C:\Windows\SysWOW64\vmGuestLibJava.dll" "C:\Windows\SysWOW64\nope15.dll"
    Rename-Item "C:\Windows\SysWOW64\vmhgfs.dll" "C:\Windows\SysWOW64\nope16.dll" 
}

Write-Output '** Done! Did you recieve a lot of errors? Try running as Admin!'
