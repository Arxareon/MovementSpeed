<# RESOURCES #>

# List of directories to copy from this project
$addons = @()
$addons += "WidgetTools"
$addons += "MovementSpeed"

# List of clients (signified by client directory tags: _retail_, _classic_, _ptr_ etc.) to install to
$clients = Get-Content "$PSScriptRoot\.config\WoWClients.txt" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

# Source path template
$source = Join-Path (Get-Location) "[addon]\*"

# Destination path template
$destination = Join-Path (Get-Content "$PSScriptRoot\.config\WoWDirectory.txt") "[client]\Interface\Addons\[addon]\"


<# INSTALLATION #>

<# Clear the directories & Copy the files #>

foreach ($addon in $addons) {
	foreach ($client in $clients) {
		# Fill in the paths
		$sourcePath = $source -replace "\[addon\]", $addon
		$destinationPath = $destination -replace "\[client\]", $client -replace "\[addon\]", $addon

		# Clear the directory
		Remove-Item $destinationPath -Include *.* -Recurse -Force

		# Install the addon
		if (!(Test-Path -Path $destinationPath)) { New-Item $destinationPath -Type Directory }
		Copy-Item $sourcePath -Destination $destinationPath -Recurse -Force
	}
}