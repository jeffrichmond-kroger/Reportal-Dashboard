param (
    [string]$OutputPath = (Join-Path $PSScriptRoot 'PHASE_4_COMPARISON.csv')
)

$ErrorActionPreference = 'Stop'
$culture = [Globalization.CultureInfo]::InvariantCulture
$weeklyPath = Join-Path $PSScriptRoot 'PHASE_4_Q1.txt'
$ytdPath = Join-Path $PSScriptRoot 'PHASE_4_Q2.txt'
$hasFullWeekly = Test-Path $weeklyPath
$hasFullYtd = Test-Path $ytdPath
if (-not $hasFullWeekly) { $weeklyPath = Join-Path $PSScriptRoot 'PHASE_3_Q5.txt' }
if (-not $hasFullYtd) { $ytdPath = Join-Path $PSScriptRoot 'PHASE_3_Q6.txt' }
$weekly = @(Import-Csv $weeklyPath -Delimiter "`t")
$ytd = @(Import-Csv $ytdPath -Delimiter "`t")
$weeklySource = @(Import-Csv (Join-Path $PSScriptRoot 'PHASE_3_Q2.txt') -Delimiter "`t")
$ytdSource = @(Import-Csv (Join-Path $PSScriptRoot 'PHASE_3_Q1.txt') -Delimiter "`t" |
    Where-Object { $_.'[FiscalWeekKey]' -eq '202640' })
$results = [Collections.Generic.List[object]]::new()
$goalPath = Join-Path $PSScriptRoot 'PHASE_4_Q7.txt'
$currentGoals = if (Test-Path $goalPath) { @(Import-Csv $goalPath -Delimiter "`t") } else { @() }

function Add-Comparison {
    param ($Category, $Metric, $Period, $Field, $Expected, $Actual, [bool]$Available = $true, [double]$Tolerance = 0, [string]$LegacyReference = '')
    $expectedText = [string]$Expected
    $actualText = [string]$Actual
    $difference = ''
    $status = 'NOT TESTED'
    if ($Available) {
        $matches = $expectedText -ceq $actualText
        $expectedNumber = 0.0
        $actualNumber = 0.0
        if ($expectedText.Length -gt 0 -and $actualText.Length -gt 0 -and
            [double]::TryParse($expectedText, [Globalization.NumberStyles]::Float, $culture, [ref]$expectedNumber) -and
            [double]::TryParse($actualText, [Globalization.NumberStyles]::Float, $culture, [ref]$actualNumber)) {
            $difference = $actualNumber - $expectedNumber
            $matches = [Math]::Abs($difference) -le $Tolerance
        }
        elseif ($matches) { $difference = 0 }
        else { $difference = 'Mismatch' }
        $status = if ($matches) { 'PASS' } else { 'FAIL' }
    }
    $results.Add([pscustomobject][ordered]@{
        Category = $Category
        Metric = $Metric
        Period = $Period
        Field = $Field
        'Legacy expected' = $(if ($Category -like 'Screenshot*') { $expectedText } else { '' })
        'Source / contract expected' = $(if ($Category -notlike 'Screenshot*') { $expectedText } else { '' })
        'Legacy goal reference (not authoritative)' = $LegacyReference
        'Power BI actual' = $(if ($Available) { $actualText } else { 'NOT EXPORTED' })
        Difference = $difference
        'Pass/Fail' = $status
    })
}

$targets = @(
    @{ Key=17; Name='Total Overall'; YtdScore='65'; YtdDisplay='65'; Scores=@('64','65','66','65'); Display=@('64','65','66','65'); Goal='85' }
    @{ Key=3; Name='Care'; YtdScore='72'; YtdDisplay='72'; Scores=@('66','69','70','69'); Display=@('66','69','70','69'); Goal='85' }
    @{ Key=89; Name='Left Nav Clinical Impact [NS]'; YtdScore=''; YtdDisplay='80.5%'; Scores=@('','','',''); Display=@('80.2%','80.4%','79.1%','81.0%'); Goal='25.0%' }
    @{ Key=88; Name='PEQ Clinical Impact'; YtdScore='0'; YtdDisplay='20.2%'; Scores=@('0','0','0','0'); Display=@('14.4%','19.5%','24.2%','20.6%'); Goal='80.0%' }
    @{ Key=90; Name='Completed Clinical Interactions [NS]'; YtdScore=''; YtdDisplay='459,526'; Scores=@('','','',''); Display=@('13,853','15,165','16,263','15,062'); Goal='' }
    @{ Key=87; Name='Auto Refill'; YtdScore='94'; YtdDisplay='61.2%'; Scores=@('94','94','94','94'); Display=@('61.2%','61.2%','61.1%','61.1%'); Goal='75.0%' }
    @{ Key=38; Name='90-day'; YtdScore='85'; YtdDisplay='55.57%'; Scores=@('71','80','82','79'); Display=@('41.56%','46.30%','49.25%','45.48%'); Goal='54.50%' }
    @{ Key=21; Name='Return to Stock'; YtdScore='92'; YtdDisplay='14.89%'; Scores=@('80','80','80','80'); Display=@('19.13%','19.42%','19.61%','19.49%'); Goal='7.23%' }
    @{ Key=2; Name='Service'; YtdScore='83'; YtdDisplay='83'; Scores=@('86','86','87','87'); Display=@('86','86','87','87'); Goal='85' }
    @{ Key=19; Name='Pharmacist PE'; YtdScore='85'; YtdDisplay='167.40%'; Scores=@('85','85','85','85'); Display=@('141.83%','162.41%','153.46%','134.43%'); Goal='6.00%' }
    @{ Key=20; Name='Technician PE'; YtdScore='86'; YtdDisplay='124.2%'; Scores=@('86','86','86','86'); Display=@('110.7%','116.5%','115.4%','108.8%'); Goal='100.0%' }
    @{ Key=45; Name='Overall Satisfaction'; YtdScore='75'; YtdDisplay='78%'; Scores=@('87','87','92','92'); Display=@('88%','89%','92%','92%'); Goal='42%' }
    @{ Key=7; Name='Ready Rate'; YtdScore='73'; YtdDisplay='84.46%'; Scores=@('73','73','73','73'); Display=@('84.14%','84.32%','84.61%','83.44%'); Goal='86.00%' }
    @{ Key=51; Name='Automation'; YtdScore='100'; YtdDisplay='40.81%'; Scores=@('100','100','100','100'); Display=@('41.15%','41.24%','41.31%','41.45%'); Goal='30.00%' }
    @{ Key=4; Name='Share'; YtdScore='45'; YtdDisplay='45'; Scores=@('45','45','45','44'); Display=@('45','45','45','44'); Goal='85' }
    @{ Key=12; Name='Rx Sold'; YtdScore='88'; YtdDisplay='248.24M'; Scores=@('90','90','90','88'); Display=@('6.79M','6.75M','6.79M','6.93M'); Goal='6.51M' }
    @{ Key=39; Name='Vaccines'; YtdScore='2'; YtdDisplay='182,438'; Scores=@('0','0','0','0'); Display=@('2,490','1,990','2,240','1,990'); Goal='3.24M' }
)
$sampleColors = @{ 17='red'; 3='red'; 2='green'; 4='red'; 87='green'; 90=''; 12='green'; 89=''; 88='red'; 38='yellow'; 21='yellow'; 19='green'; 20='green'; 45='green'; 7='red'; 51='green'; 39='red' }

$expectedWeeklyRows = if ($hasFullWeekly) { 68 } else { 28 }
$expectedYtdRows = if ($hasFullYtd) { 17 } else { 7 }
Add-Comparison 'Structure' 'ALL' 'P10 2026' 'Weekly exported rows' $expectedWeeklyRows $weekly.Count
Add-Comparison 'Structure' 'ALL' 'P10 2026' 'YTD exported rows' $expectedYtdRows $ytd.Count
Add-Comparison 'Structure' 'ALL' 'P10 2026' 'Unique weekly metric/week groups' $expectedWeeklyRows @($weekly | Group-Object { $_.'Metric[MetricKey]' + '/' + $_.'Fiscal Week[FiscalWeekKey]' }).Count
Add-Comparison 'Structure' 'ALL' 'P10 2026' 'Unique YTD metric groups' $expectedYtdRows @($ytd | Group-Object { $_.'Metric[MetricKey]' }).Count
$metricMetadata = @(Import-Csv (Join-Path $PSScriptRoot 'PHASE_3_Q3.txt') -Delimiter "`t" |
    Where-Object { $_.'[MetricKey]' -match '^\d+$' } | Sort-Object { [int]$_.'[SortNumber]' })
Add-Comparison 'Metadata' 'Dashboard' 'P10 2026' 'Source metric order' ($targets.Key -join '/') ($metricMetadata.'[MetricKey]' -join '/')
function Get-ExpectedGoalDisplay {
    param ($RawText, $MetricKey)
    $text = ([string]$RawText).Trim()
    if ($text.Length -eq 0) { return '' }
    $hasPercent = $text.EndsWith('%')
    $numericText = if ($hasPercent) { $text.Substring(0,$text.Length - 1) } else { $text }
    $number = [decimal]0
    if (-not [decimal]::TryParse($numericText, [Globalization.NumberStyles]::Number, $culture, [ref]$number)) { return [string]$RawText }
    $metadata = @($metricMetadata | Where-Object { $_.'[MetricKey]' -eq [string]$MetricKey })
    if ($metadata.Count -ne 1) { throw "Missing unique metric formatting metadata: $MetricKey" }
    $places = if ([string]::IsNullOrWhiteSpace($metadata[0].'[SummaryRoundingNumber]')) { 0 } else { [int]$metadata[0].'[SummaryRoundingNumber]' }
    $pattern = '#,0' + $(if ($places -gt 0) { '.' + ('0' * $places) } else { '' })
    if ($hasPercent -or $metadata[0].'[SummaryFormatMask]' -eq '%') { return $number.ToString($pattern,$culture) + '%' }
    if ([string]$MetricKey -eq '12' -and [Math]::Abs($number) -ge 1000000) { return ($number / 1000000).ToString('0.00',$culture) + 'M' }
    return $number.ToString($pattern,$culture)
}
Add-Comparison 'Current goal' 'ALL dashboard metrics' 'Year 2026' 'Exported goal rows' 17 @($currentGoals).Count (Test-Path $goalPath)
foreach ($target in $targets) {
    $actualYtd = @($ytd | Where-Object { $_.'Metric[MetricKey]' -eq [string]$target.Key })
    $hasYtd = $actualYtd.Count -eq 1
    $ytdRow = if ($hasYtd) { $actualYtd[0] } else { $null }
    Add-Comparison 'Screenshot' $target.Name 'YTD W40' 'Score' $target.YtdScore $ytdRow.'[YTD score]' $hasYtd
    Add-Comparison 'Screenshot' $target.Name 'YTD W40' 'Display text' $target.YtdDisplay $ytdRow.'[YTD display text]' $hasYtd
    $goalMatches = @($currentGoals | Where-Object { $_.'Metric[MetricKey]' -eq [string]$target.Key })
    $hasGoal = $goalMatches.Count -eq 1
    $goalRow = if ($hasGoal) { $goalMatches[0] } else { $null }
    $expectedGoalDisplay = if ($hasGoal) { Get-ExpectedGoalDisplay $goalRow.'[Source goal text]' $target.Key } else { '' }
    Add-Comparison 'Current goal' $target.Name 'Year 2026' 'Unique source rows' 1 $goalRow.'[Source rows]' $hasGoal
    Add-Comparison 'Current goal' $target.Name 'Year 2026' 'Raw goal text' $goalRow.'[Source goal text]' $goalRow.'[Current goal raw text]' $hasGoal
    Add-Comparison 'Current goal' $target.Name 'Year 2026' 'Display goal text' $expectedGoalDisplay $goalRow.'[Current goal display text]' $hasGoal -LegacyReference $target.Goal
    Add-Comparison 'Current goal' $target.Name 'Year 2026' 'Goal year' 2026 $goalRow.'[Goal year]' $hasGoal
    Add-Comparison 'Current goal' $target.Name 'Year 2026' 'Scope' 'ALL' $goalRow.'[Scope]' $hasGoal
    if ($sampleColors.ContainsKey($target.Key)) {
        $expectedColor = switch ($target.Key) { 2 { 'yellow' } 45 { 'yellow' } 38 { 'green' } 21 { 'green' } default { $sampleColors[$target.Key] } }
        $visibleColor = if ($ytdRow.'[YTD color]' -ceq 'hide') { '' } else { $ytdRow.'[YTD color]' }
        Add-Comparison 'Screenshot color' $target.Name 'YTD W40' 'Visible status color' $expectedColor $visibleColor $hasYtd
    }
    for ($weekIndex = 0; $weekIndex -lt 4; $weekIndex++) {
        $weekKey = [string](202637 + $weekIndex)
        $actualWeekly = @($weekly | Where-Object { $_.'Metric[MetricKey]' -eq [string]$target.Key -and $_.'Fiscal Week[FiscalWeekKey]' -eq $weekKey })
        $hasWeekly = $actualWeekly.Count -eq 1
        $weeklyRow = if ($hasWeekly) { $actualWeekly[0] } else { $null }
        Add-Comparison 'Screenshot' $target.Name $weekKey 'Score' $target.Scores[$weekIndex] $weeklyRow.'[Weekly score]' $hasWeekly
        Add-Comparison 'Screenshot' $target.Name $weekKey 'Display text' $target.Display[$weekIndex] $weeklyRow.'[Weekly display text]' $hasWeekly
        if ($sampleColors.ContainsKey($target.Key)) {
            $expectedColor = if ($target.Key -eq 38 -and $weekIndex -eq 0) { 'red' } else { $sampleColors[$target.Key] }
            $visibleColor = if ($weeklyRow.'[Weekly color]' -ceq 'hide') { '' } else { $weeklyRow.'[Weekly color]' }
            Add-Comparison 'Screenshot color' $target.Name $weekKey 'Visible status color' $expectedColor $visibleColor $hasWeekly
        }
    }
}

$weeklyFields = @{'[Weekly score]'='[ScoreValue]'; '[Weekly display value]'='[DisplayValue]'; '[Weekly underlying value]'='[UnderlyingValue]'; '[Weekly goal text]'='[GoalText]'; '[Weekly color]'='[ColorCode]'; '[Weekly arrow]'='[ArrowCode]'}
$sourceColumns = @{'[ScoreValue]'='[Source score]'; '[DisplayValue]'='[Source display value]'; '[UnderlyingValue]'='[Source underlying value]'; '[GoalText]'='[Source goal text]'; '[GoalValue]'='[Source goal value]'; '[ColorCode]'='[Source color]'; '[ArrowCode]'='[Source arrow]'}
$percentageKeys = @($metricMetadata | Where-Object { $_.'[SummaryFormatMask]' -eq '%' } | ForEach-Object { $_.'[MetricKey]' })
function Get-EmbeddedSource {
    param ($Row)
    $values = @{}
    foreach ($column in $sourceColumns.Keys) { $values[$column] = $Row.($sourceColumns[$column]) }
    [pscustomobject]$values
}
foreach ($row in $weekly) {
    $match = if ($hasFullWeekly) { @(Get-EmbeddedSource $row) } else { @($weeklySource | Where-Object { $_.'[MetricKey]' -eq $row.'Metric[MetricKey]' -and $_.'[FiscalWeekKey]' -eq $row.'Fiscal Week[FiscalWeekKey]' }) }
    $match = @($match)
    if ($match.Count -ne 1) { throw 'Weekly export has no unique source match.' }
    foreach ($field in ($weeklyFields.Keys | Sort-Object)) {
        $tolerance = if (($field -eq '[Weekly display value]' -and $row.'Metric[MetricKey]' -in $percentageKeys) -or
            ($field -eq '[Weekly underlying value]' -and $row.'Metric[MetricKey]' -notin @('90','39'))) { 0.000001 } else { 0 }
        Add-Comparison 'Source retrieval' $row.'Metric[MetricName]' $row.'Fiscal Week[FiscalWeekKey]' $field $match[0].($weeklyFields[$field]) $row.$field $true $tolerance
    }
    Add-Comparison 'Context' $row.'Metric[MetricName]' $row.'Fiscal Week[FiscalWeekKey]' 'Scope' 'ALL' $row.'[Scope]'
    Add-Comparison 'Context' $row.'Metric[MetricName]' $row.'Fiscal Week[FiscalWeekKey]' 'Weekly rows' 1 $row.'[Weekly rows]'
    Add-Comparison 'Context' $row.'Metric[MetricName]' $row.'Fiscal Week[FiscalWeekKey]' 'YTD endpoint' 202640 $row.'[YTD endpoint]'
    $endpoint = @($ytd | Where-Object { $_.'Metric[MetricKey]' -eq $row.'Metric[MetricKey]' })
    if ($endpoint.Count -gt 1) { throw 'Duplicate YTD export match.' }
    Add-Comparison 'Context' $row.'Metric[MetricName]' $row.'Fiscal Week[FiscalWeekKey]' 'YTD under week filter' $endpoint[0].'[YTD score]' $row.'[YTD score under week filter]' ($endpoint.Count -eq 1)
}
$ytdFields = @{'[YTD score]'='[ScoreValue]'; '[YTD display value]'='[DisplayValue]'; '[YTD underlying value]'='[UnderlyingValue]'; '[YTD goal value]'='[GoalValue]'; '[YTD color]'='[ColorCode]'}
foreach ($row in $ytd) {
    $match = if ($hasFullYtd) { @(Get-EmbeddedSource $row) } else { @($ytdSource | Where-Object { $_.'[MetricKey]' -eq $row.'Metric[MetricKey]' }) }
    $match = @($match)
    if ($match.Count -ne 1) { throw 'YTD export has no unique source match.' }
    foreach ($field in ($ytdFields.Keys | Sort-Object)) {
        $tolerance = if (($field -eq '[YTD underlying value]' -and $row.'Metric[MetricKey]' -notin @('90','39')) -or
            ($field -eq '[YTD display value]' -and $row.'Metric[MetricKey]' -in $percentageKeys)) { 0.000001 } else { 0 }
        Add-Comparison 'Source retrieval' $row.'Metric[MetricName]' 'YTD W40' $field $match[0].($ytdFields[$field]) $row.$field $true $tolerance
    }
    Add-Comparison 'Context' $row.'Metric[MetricName]' 'YTD W40' 'Period label' 'Period 10 2026' $row.'[Period label]'
    Add-Comparison 'Context' $row.'Metric[MetricName]' 'YTD W40' 'YTD rows' 1 $row.'[YTD rows]'
    Add-Comparison 'Context' $row.'Metric[MetricName]' 'YTD W40' 'Scope' 'ALL' $row.'[Scope]'
    Add-Comparison 'Context' $row.'Metric[MetricName]' 'YTD W40' 'Endpoint' 202640 $row.'[YTD endpoint]'
}

$guards = @(Import-Csv (Join-Path $PSScriptRoot 'PHASE_3_Q7.txt') -Delimiter "`t")
foreach ($row in $guards) {
    Add-Comparison 'Context guards' $row.'[Test]' 'Invalid context' 'Actual blank result' '' $row.'[Actual]'
}

$integrityPath = Join-Path $PSScriptRoot 'PHASE_4_Q3.txt'
if (Test-Path $integrityPath) {
    $integrity = @(Import-Csv $integrityPath -Delimiter "`t")
    Add-Comparison 'Global fact integrity' 'Both facts' 'Loaded model' 'Fact result rows' 2 $integrity.Count
    foreach ($row in $integrity) {
        Add-Comparison 'Global fact integrity' $row.'[Fact]' 'Loaded model' 'Nonempty fact' 'True' ([long]$row.'[Source rows]' -gt 0)
        Add-Comparison 'Global fact integrity' $row.'[Fact]' 'Loaded model' 'Distinct grains' $row.'[Source rows]' $row.'[Distinct grains]'
        foreach ($field in @('[Duplicate grains]','[Missing grain keys]','[Orphan metric keys]','[Orphan week keys]','[Period mismatches]')) {
            Add-Comparison 'Global fact integrity' $row.'[Fact]' 'Loaded model' $field 0 $row.$field
        }
    }
}
else { Add-Comparison 'Global fact integrity' 'Both facts' 'Loaded model' 'Q3 runtime evidence' 'PASS' '' $false }

foreach ($test in @(@{ Number=4; Category='Organization retrieval'; Count=16 }, @{ Number=5; Category='Missing and zero'; Count=3 }, @{ Number=8; Category='Goal year and scope'; Count=144 }, @{ Number=10; Category='Goal period and guards'; Count=224 })) {
    $testPath = Join-Path $PSScriptRoot ("PHASE_4_Q{0}.txt" -f $test.Number)
    if (Test-Path $testPath) {
        $testRows = @(Import-Csv $testPath -Delimiter "`t")
        Add-Comparison $test.Category 'Runtime checks' 'P10 2026' 'Result rows' $test.Count $testRows.Count
        foreach ($row in $testRows) {
            $label = switch ($test.Number) {
                4 { $row.'[Expected scope]' + '/metric ' + $row.'[Test metric key]' }
                8 { $row.'[Test year]' + '/' + $row.'[Expected scope]' + '/metric ' + $row.'[Test metric key]' }
                10 { $row.'[Test]' + '/' + $row.'[Period key]' + '/metric ' + $row.'[Metric key]' }
                default { $row.'[Test]' }
            }
            Add-Comparison $test.Category $label 'Runtime check' 'Pass/Fail' 'PASS' $row.'[Pass/Fail]' ($row.'[Pass/Fail]' -ne 'NOT TESTED')
        }
    }
    else { Add-Comparison $test.Category 'Runtime checks' 'P10 2026' 'Runtime evidence' 'PASS' '' $false }
}

$goalIntegrityPath = Join-Path $PSScriptRoot 'PHASE_4_Q9.txt'
if (Test-Path $goalIntegrityPath) {
    $goalIntegrity = @(Import-Csv $goalIntegrityPath -Delimiter "`t")
    Add-Comparison 'Goal integrity' 'Annual Goal' 'Loaded model' 'Integrity result rows' 1 $goalIntegrity.Count
    foreach ($row in $goalIntegrity) {
        Add-Comparison 'Goal integrity' 'Annual Goal' 'Loaded model' 'Nonempty source' 'True' ([long]$row.'[Source rows]' -gt 0)
        Add-Comparison 'Goal integrity' 'Annual Goal' 'Loaded model' 'Distinct grains' $row.'[Source rows]' $row.'[Distinct grains]'
        foreach ($field in @('[Duplicate grains]','[Missing grain keys]','[Orphan metric keys]')) {
            Add-Comparison 'Goal integrity' 'Annual Goal' 'Loaded model' $field 0 $row.$field
        }
    }
}
else { Add-Comparison 'Goal integrity' 'Annual Goal' 'Loaded model' 'Integrity evidence' 'PASS' '' $false }

$historicalExceptions = @{
    'Weekly Score' = @{ Keys='10/15/24/44/47/67'; Rows=682765; Count=6 }
    'YTD Score' = @{ Keys='10/15/24/44/67'; Rows=697762; Count=5 }
}
$orphanPath = Join-Path $PSScriptRoot 'PHASE_4_Q6.txt'
$orphanEvidence = if (Test-Path $orphanPath) { @(Import-Csv $orphanPath -Delimiter "`t") } else { @() }
foreach ($result in $results) {
    $gateDecision = if ($result.'Pass/Fail' -eq 'PASS') { 'PASS' } else { 'BLOCKED' }
    if ($result.Category -eq 'Global fact integrity' -and $result.Field -eq '[Orphan metric keys]' -and $historicalExceptions.ContainsKey($result.Metric)) {
        $approved = $historicalExceptions[$result.Metric]
        $evidence = @($orphanEvidence | Where-Object { $_.'[Fact]' -eq $result.Metric } | Sort-Object { [int]$_.'[Metric key]' })
        $affectedRows = 0L
        $period10Rows = 0L
        foreach ($row in $evidence) { $affectedRows += [long]$row.'[Affected rows]'; $period10Rows += [long]$row.'[Period 10 ALL rows]' }
        if ($evidence.Count -eq $approved.Count -and ($evidence.'[Metric key]' -join '/') -ceq $approved.Keys -and
            $affectedRows -eq $approved.Rows -and $period10Rows -eq 0 -and [string]$result.'Power BI actual' -eq [string]$approved.Count) {
            $gateDecision = 'APPROVED HISTORICAL EXCEPTION 2026-11-18'
        }
    }
    $result | Add-Member -NotePropertyName 'Gate decision' -NotePropertyValue $gateDecision
}
$results | Export-Csv $OutputPath -NoTypeInformation -Encoding UTF8
$results | Group-Object Category,'Pass/Fail' | Select-Object Name,Count | Format-Table -AutoSize
Write-Output "Comparison evidence: $OutputPath"
Write-Output 'Raw FAIL evidence is preserved. Only the exact historical findings approved on 2026-11-18 are excepted; new failures or changed orphan evidence block the gate. This script does not query Desktop.'