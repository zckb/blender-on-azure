# download blender bin, examples and extract

$path = "C:\dist"
$extractedPath = "$path\extracted"
$blenderUrl = "https://www.blend4web.com/blender/release/Blender2.79/blender-2.79-windows64.zip"
$exampleFileUrl = "https://download.blender.org/demo/test/BMW27_2.blend.zip"
$openglLibUrl = "http://download.blender.org/ftp/sergey/softwaregl/win64/opengl32.dll"

If (!(test-path $path)) {
    New-Item -ItemType Directory -Force -Path $path
}

Import-Module BitsTransfer

function DownloadFile ([string] $url) {
    $fileName = [System.IO.Path]::GetFileName($url);
    $destination = Join-Path $path ($url | Split-Path -Leaf)
    $start_time = Get-Date
    Write-Host "Downloading $fileName"
    Start-BitsTransfer -Source $url -Destination $destination
    Write-Host "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

    return $destination
}

function ExpandArchive ([string] $filePath) {
    Write-Host "Extracting $filePath"
    Expand-Archive $filePath -DestinationPath $path\extracted
}

$filePath = DownloadFile($blenderUrl)
ExpandArchive($filePath)

$filePath = DownloadFile($exampleFileUrl)
ExpandArchive($filePath)

$filePath = DownloadFile($openglLibUrl)
Copy-Item $filePath $extractedPath\blender-2.79-windows64