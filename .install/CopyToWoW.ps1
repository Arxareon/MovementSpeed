<# RESOURCES #>

# List of directories to copy from this project
$addons = Get-Content "$PSScriptRoot\.config\AddonNamespaces.txt" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

# List of clients (signified by client directory tags: _retail_, _classic_, _ptr_ etc.) to install to
$clients = Get-Content "$PSScriptRoot\.config\WoWClients.txt" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

# Destination path template
$destination = Join-Path (Get-Content "$PSScriptRoot\.config\WoWDirectory.txt") "#CLIENT\Interface\Addons\"


<# INSTALLATION #>

foreach ($addon in $addons) {
	$addon = Get-ChildItem -Directory -Filter $addon | Select-Object -First 1

	if (-not $addon) { continue }

	foreach ($client in $clients) {
		$destinationPath = Join-Path ($destination -replace "#CLIENT", $client) $addon.Name
		Remove-Item $destinationPath -Recurse -Force -ErrorAction SilentlyContinue
		Copy-Item $addon.FullName -Destination $destinationPath -Recurse -Force
	}
}