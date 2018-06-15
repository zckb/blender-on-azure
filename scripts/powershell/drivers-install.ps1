Param (
    [string]$size
)

$path = "C:\drivers"

If (!(test-path $path)) {
    New-Item -ItemType Directory -Force -Path $path
}

if ($size -like '*NV*') {
    # NV instances - NVIDIA GRID drivers
    $gridDriversUrl = "https://go.microsoft.com/fwlink/?linkid=836843"
    Invoke-WebRequest $gridDriversUrl -outfile $path\setup.exe
    Start-Process -FilePath $path\setup.exe -ArgumentList '-s', '-noreboot' -Wait
}
else {
    # NC, NCv2, and ND instances - NVIDIA Tesla drivers
    $teslaDriverUrl = "http://us.download.nvidia.com/Windows/Quadro_Certified/385.54/385.54-tesla-desktop-winserver2016-international.exe"
    $fileName = [System.IO.Path]::GetFileName($teslaDriverUrl);
    Start-BitsTransfer -Source $teslaDriverUrl -Destination $path\$fileName
    Start-Process -FilePath $path\$fileName -ArgumentList '-s', '-noreboot' -Wait
}
