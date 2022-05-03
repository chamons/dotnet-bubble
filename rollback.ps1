$names=Select-Xml -Path ./package/vs-workload.props -XPath '//WorkloadPackages'  | ForEach-Object { $_.Node.Include | Out-String }
$versions=Select-Xml -Path ./package/vs-workload.props -XPath '//WorkloadPackages'  | ForEach-Object { $_.Node.Version }

$suffixentry=Select-Xml -Path ./package/vs-workload.props -XPath '//ShortNames' | ForEach-Object { $_.Node } | Where-Object Include -match '-' | Select-Object -Property Include  -First 1
$suffix=$suffixentry.Include.Split("-")[1]

$output = @{}

for (($i = 0); $i -lt $names.Count; $i++) {
    $name=$names[$i]
    $name_bits=$names[$i].Split(".").ToLower()
    $final_name=$name_bits[3]
    $final_version = $versions[$i].Split('.')[0,1,2] -join '.'
    $version = $final_version + "-" + $suffix
    $output.Add("microsoft.net.sdk." + $final_name, $version)
}

$output | ConvertTo-Json | Out-File -FilePath WorkloadRollback.json

$versionData = Get-Content WorkloadRollback.json | ConvertFrom-Json

$iOSVersion = $versionData | Select-Object -ExpandProperty "microsoft.net.sdk.ios"
$env:IOS_WORKLOAD_VERSION = $iOSVersion

$tvOSVersion = $versionData | Select-Object -ExpandProperty "microsoft.net.sdk.tvos"
$env:TVOS_WORKLOAD_VERSION = $tvOSVersion

$macVersion = $versionData | Select-Object -ExpandProperty "microsoft.net.sdk.macos"
$env:MACOS_WORKLOAD_VERSION = $macVersion

$catalystVersion = $versionData | Select-Object -ExpandProperty "microsoft.net.sdk.maccatalyst"
$env:MACCATALYST_WORKLOAD_VERSION = $catalystVersion

bash ./donut.sh workload install --from-rollback-file WorkloadRollback.json --source ./package --source "https://pkgs.dev.azure.com/dnceng/public/_packaging/darc-pub-dotnet-runtime-a21b9a2d/nuget/v3/index.json" --source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-public/nuget/v3/index.json" --source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-eng/nuget/v3/index.json" --source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-tools/nuget/v3/index.json" --source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet6/nuget/v3/index.json" --source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet7/nuget/v3/index.json" --source "https://pkgs.dev.azure.com/xamarin/public/_packaging/macios-dependencies/nuget/v3/index.json" --source "https://pkgs.dev.azure.com/azure-public/vside/_packaging/xamarin-impl/nuget/v3/index.json" --verbosity diag ios tvos macos maccatalyst