# Configuration
$driverName = "delete"
$infPath = "\\vmware-host\Shared Folders\delete\delete.inf"
$userApp = "\\vmware-host\Shared Folders\Agent\Agent.exe"
$hostDir = "D:\workspace\DELETE\x64\Debug\delete"
$destDir = "C:\Users\nbyaman\Desktop"

Copy-Item -Path "\\vmware-host\Shared Folders\delete" -Destination "C:\Users\nbyam\Desktop\minifilter" -Recurse -Force
Copy-Item -Path "\\vmware-host\Shared Folders\Agent" -Destination "C:\Users\nbyam\Desktop\agent" -Recurse -Force

# 1. Install MiniFilter driver
Write-Host "Installing MiniFilter..."
pnputil /add-driver $infPath /install

# 2. Load and Attach to volume of $hostDir
$volumeName = "E:"

Write-Host "Load MiniFilter $driverName..."
fltmc load $driverName 

Write-Host "Attach MiniFilter to $volumeName..."
fltmc attach $driverName $volumeName

# 3. Run user-mode program
Write-Host "Launching user-mode sync program..."
Start-Process -FilePath $userApp -ArgumentList "`"$hostDir`"", "`"$destDir`"" -Wait

# 4. Stop and remove service
Write-Host "Stopping and removing driver..."
fltmc unload $driverName
