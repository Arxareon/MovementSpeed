<# RESOURCES #>	

<# Addons #>

$addons = @()

#List of addon folders to copy from the source folder
$addons += "WidgetTools"
$addons += "MovementSpeed"

<# Clients #>

$clients = @()

#List of client tags used by Blizzard to target
$clients += "_retail_" #Dragonflight
$clients += "_ptr_" #Dragonflight PTR
$clients += "_ptr2_" #Dragonflight PTR 2
$clients += "_classic_" #Wrath of the Lich King
$clients += "_classic_ptr_" #Wrath of the Lick King PTR
$clients += "_classic_era_" #Classic


<# INSTALLATION #>

<# Assemble the paths #>

$source = Get-Location

#Path text file (Note: This is the root install location of World of Warcraft.)
$pathFile = Join-Path $source "\.vscode\WoWDirectory.txt"

#Source path to fill
$source = Join-Path $source "\[addon]\*"

#Destination path to fill
$destination = Get-Content -Path $pathFile
$destination = Join-Path $destination "\[client]\Interface\Addons\[addon]\"

<# Copy the files #>

foreach ($addon in $addons) {
	foreach ($client in $clients) {
		#Fill in the paths
		$sourcePath = $source -replace "\[addon\]", $addon
		$destinationPath = $destination -replace "\[client\]", $client -replace "\[addon\]", $addon
		#Install the addon
		if (!(Test-Path -Path $destinationPath)) { New-Item $destinationPath -Type Directory }
		Copy-Item $sourcePath -Destination $destinationPath -Recurse -Force
	}
}