$names=Select-Xml -Path ./package/vs-workload.props -XPath '//WorkloadPackages'  | ForEach-Object { $_.Node.Include | Out-String }
$versions=Select-Xml -Path ./package/vs-workload.props -XPath '//WorkloadPackages'  | ForEach-Object { $_.Node.Version }

$suffixentry=Select-Xml -Path ./package/vs-workload.props -XPath '//ShortNames' | ForEach-Object { $_.Node } | Where-Object Include -match '-' | Select-Object -Property Include  -First 1
$suffix=$suffixentry.Include.Split("-")[1]

$output = @{}

for (($i = 0); $i -lt $names.Count; $i++) {
    $name=$names[$i]
    $name_bits=$names[$i].Split(".").ToLower()    
    $output.Add("microsoft.net.sdk." + $name_bits[3], $versions[$i] + "-" + $suffix)
}

$output | ConvertTo-Json | Out-File -FilePath WorkloadRollback.json