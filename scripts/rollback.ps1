$rollback = "./package-internal/WorkloadRollback.json"

$versionData = Get-Content $rollback | ConvertFrom-Json

$env:IOS_WORKLOAD_VERSION = Select-Object -ExpandProperty "microsoft.net.sdk.ios"
$env:TVOS_WORKLOAD_VERSION = Select-Object -ExpandProperty "microsoft.net.sdk.tvos"
$env:MACOS_WORKLOAD_VERSION = Select-Object -ExpandProperty "microsoft.net.sdk.macos"
$env:MACCATALYST_WORKLOAD_VERSION = Select-Object -ExpandProperty "microsoft.net.sdk.maccatalyst"

bash ./donut.sh workload install --from-rollback-file $rollback --source ./package --source ./nuget-macos/ --source "https://pkgs.dev.azure.com/dnceng/public/_packaging/darc-pub-dotnet-runtime-a21b9a2d/nuget/v3/index.json" --source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-public/nuget/v3/index.json" --source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-eng/nuget/v3/index.json" --source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-tools/nuget/v3/index.json" --source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet6/nuget/v3/index.json" --source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet7/nuget/v3/index.json" --source "https://pkgs.dev.azure.com/xamarin/public/_packaging/macios-dependencies/nuget/v3/index.json" --source "https://pkgs.dev.azure.com/azure-public/vside/_packaging/xamarin-impl/nuget/v3/index.json" --verbosity diag ios tvos macos maccatalyst maui