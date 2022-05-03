$config = Get-Content variables.json | ConvertFrom-Json

$downloads=$config.root + "/downloads"
$package=$config.root + "/package"
$module=$config.macios + "/tools/devops/automation/scripts/VSTS.psm1"
Import-Module $module

$org="devdiv"
$project="DevDiv"
$token=Get-Content $config.vsts_pat_location
$vsts = New-VSTS -Org $org -Project $project -Token $token
$artifacts = $vsts.Artifacts.GetArtifacts($config.macios_build_id)

if (!(Test-Path $package)) {
    $null = New-Item $package -ItemType "directory"
}

if (!(Test-Path $downloads)) {
    $null = New-Item $downloads -ItemType "directory"
}

foreach($a in $artifacts){
    if ($a.GetName() -eq "package" -and !(Test-Path $downloads/"package.zip")) {
        Write-Host "Downloading:" $a.GetName()
        $vsts.Artifacts.DownloadArtifact($a, $downloads)
    }
    if ($a.GetName() -eq "package-internal" -and !(Test-Path $downloads/"package-internal.zip")) {
        Write-Host "Downloading:" $a.GetName()
        $vsts.Artifacts.DownloadArtifact($a, $downloads)
    }
}

Expand-Archive $downloads"/package.zip" $config.root
Expand-Archive $downloads"/package-internal.zip" $config.root

$artifacts = $vsts.Artifacts.GetArtifacts($config.maui_build_id)
foreach($a in $artifacts){
    if ($a.GetName() -eq "nuget-macos" -and !(Test-Path $downloads/"nuget-macos.zip")) {
        Write-Host "Downloading:" $a.GetName()
        $vsts.Artifacts.DownloadArtifact($a, $downloads)
    }
}

Expand-Archive $downloads"/nuget-macos.zip" $config.root
