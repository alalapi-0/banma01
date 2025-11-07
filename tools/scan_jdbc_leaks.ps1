param()
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$SrcDir = Join-Path $RepoRoot 'src\main\java'
$ReportDir = Join-Path $RepoRoot 'out'
$ReportFile = Join-Path $ReportDir 'jdbc_scan_report.txt'
if (-not (Test-Path $ReportDir)) { New-Item -ItemType Directory -Path $ReportDir | Out-Null }
function Get-MatchCount {
    param([string]$Pattern)
    $results = Select-String -Path (Get-ChildItem -Path $SrcDir -Filter '*.java' -Recurse).FullName -Pattern $Pattern -AllMatches -ErrorAction SilentlyContinue
    if (-not $results) { return 0 }
    return ($results | ForEach-Object { $_.Matches.Count } | Measure-Object -Sum).Sum
}
$prepareCount = Get-MatchCount 'prepareStatement\('
$executeQueryCount = Get-MatchCount 'executeQuery\('
$executeUpdateCount = Get-MatchCount 'executeUpdate\('
$tryConnectionCount = Get-MatchCount 'try \(Connection'
$manualClose = Select-String -Path (Get-ChildItem -Path $SrcDir -Filter '*.java' -Recurse).FullName -Pattern '\b(conn|ps|rs)\.close\(' -AllMatches -ErrorAction SilentlyContinue
"JDBC usage quick scan" | Out-File -FilePath $ReportFile -Encoding UTF8
"====================" | Out-File -FilePath $ReportFile -Append
"prepareStatement occurrences : $prepareCount" | Out-File -FilePath $ReportFile -Append
"executeQuery occurrences     : $executeQueryCount" | Out-File -FilePath $ReportFile -Append
"executeUpdate occurrences    : $executeUpdateCount" | Out-File -FilePath $ReportFile -Append
"try-with Connection patterns : $tryConnectionCount" | Out-File -FilePath $ReportFile -Append
"" | Out-File -FilePath $ReportFile -Append
"Manual close hotspots" | Out-File -FilePath $ReportFile -Append
"---------------------" | Out-File -FilePath $ReportFile -Append
if ($manualClose) {
    $manualClose | ForEach-Object { "{0}:{1}" -f $_.Path, $_.LineNumber } | Out-File -FilePath $ReportFile -Append
} else {
    "(no manual close() calls detected)" | Out-File -FilePath $ReportFile -Append
}
Write-Output "Report written to $ReportFile"
