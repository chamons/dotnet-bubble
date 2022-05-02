$macios="/Users/donblas/Programming/xamarin-macios"
$root="/Users/donblas/Programming/dotnet-bubble"
$package=$root + "/package"
Import-Module $macios"/tools/devops/automation/scripts/VSTS.psm1"

$buildID="6095618"

$org="devdiv"
$project="DevDiv"
$token=Get-Content /Users/donblas/.vsts_pat
$vsts = New-VSTS -Org $org -Project $project -Token $token
$artifacts = $vsts.Artifacts.GetArtifacts($buildID)

if (!(Test-Path $package)) {
    New-Item $package -ItemType "directory"
}

foreach($a in $artifacts){
    if ($a.GetName() -eq "package") {
        $vsts.Artifacts.DownloadArtifact($a, $package)
    }   
}
Expand-Archive $package"/package.zip" $root
