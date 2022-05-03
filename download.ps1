$macios="/Users/donblas/Programming/xamarin-macios"
$root="/Users/donblas/Programming/dotnet-bubble"
$downloads=$root + "/downloads"
$package=$root + "/package"
Import-Module $macios"/tools/devops/automation/scripts/VSTS.psm1"

$buildID="6089737"

$org="devdiv"
$project="DevDiv"
$token=Get-Content /Users/donblas/.vsts_pat
$vsts = New-VSTS -Org $org -Project $project -Token $token
$artifacts = $vsts.Artifacts.GetArtifacts($buildID)

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

Expand-Archive $downloads"/package.zip" $root
Expand-Archive $downloads"/package-internal.zip" $root
