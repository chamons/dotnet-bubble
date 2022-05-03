$rollback = "./package-internal/WorkloadRollback.json"

$config = Get-Content variables.json | ConvertFrom-Json
$versionData = Get-Content $rollback | ConvertFrom-Json

$env:IOS_WORKLOAD_VERSION = Select-Object -ExpandProperty "microsoft.net.sdk.ios"
$env:TVOS_WORKLOAD_VERSION = Select-Object -ExpandProperty "microsoft.net.sdk.tvos"
$env:MACOS_WORKLOAD_VERSION = Select-Object -ExpandProperty "microsoft.net.sdk.macos"
$env:MACCATALYST_WORKLOAD_VERSION = Select-Object -ExpandProperty "microsoft.net.sdk.maccatalyst"


$rawsources = Select-Xml -Path ($config.macios +"/NuGet.config") -Xpath '//add' | ForEach-Object { $_.Node.Value } | Where-Object  { $_ -match "https" }
$sources = "--source :" + [system.String]::Join(" --source ", $rawsources)

bash ($config.root + "/donut.sh") workload install --from-rollback-file $rollback --source ./package $sources --verbosity diag ios tvos macos maccatalyst maui