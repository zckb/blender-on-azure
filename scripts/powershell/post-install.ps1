Param (
    [string]$size
)

Set-ExecutionPolicy Unrestricted -force

Write-Host "Starting post install"
Get-Date

Write-Host "Install Drivers"
$command = ".\drivers-install.ps1 -size $size"
Invoke-Expression $command

Write-Host "Install Blender"
Invoke-Expression ".\blender-install.ps1"

Write-Host "Completed post install"
Get-Date

Restart-Computer -Force -AsJob
