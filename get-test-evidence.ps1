param(
    [string[]]$TestCaseIds = @(10666, 10667, 10668, 10669),
    [int]$PlanId = 10659,
    [int]$SuiteId = 10660
)

$org = "AutoregPR"
$project = "Motorambar"

# Get PAT
$config = Get-Content "$env:APPDATA\Code\User\mcp.json" -Raw | ConvertFrom-Json
$pat = $config.servers.ado.env.AZURE_DEVOPS_EXT_PAT

$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))
}

$evidenceData = @{}

foreach ($tcId in $TestCaseIds) {
    Write-Host "Procesando TC $tcId..." -ForegroundColor Yellow
    
    # Get test points
    $pointsUrl = "https://dev.azure.com/$org/$project/_apis/test/plans/$PlanId/suites/$SuiteId/points?testCaseId=$tcId&api-version=7.0"
    
    try {
        $points = Invoke-RestMethod -Uri $pointsUrl -Headers $headers
        
        if ($points.value -and $points.value.Count -gt 0) {
            $point = $points.value[0]
            
            if ($point.lastResultId -and $point.lastRunId) {
                # Get attachments
                $attachUrl = "https://dev.azure.com/$org/$project/_apis/test/runs/$($point.lastRunId)/results/$($point.lastResultId)/attachments?api-version=7.0"
                
                try {
                    $attachments = Invoke-RestMethod -Uri $attachUrl -Headers $headers
                    
                    if ($attachments.value) {
                        Write-Host "  ✅ $($attachments.value.Count) attachment(s)" -ForegroundColor Green
                        
                        $evidenceData[$tcId] = @{
                            RunId = $point.lastRunId
                            ResultId = $point.lastResultId
                            Attachments = @()
                        }
                        
                        foreach ($att in $attachments.value) {
                            $evidenceData[$tcId].Attachments += @{
                                Id = $att.id
                                FileName = $att.fileName
                                Url = $att.url
                            }
                        }
                    }
                }
                catch {
                    Write-Host "  ⚠️  Error obteniendo attachments" -ForegroundColor Red
                }
            }
        }
    }
    catch {
        Write-Host "  ❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Save to JSON
$outputPath = ".\evidence-data.json"
$evidenceData | ConvertTo-Json -Depth 10 | Out-File $outputPath -Encoding UTF8

Write-Host ""
Write-Host "✅ Datos guardados en: $outputPath" -ForegroundColor Green
Write-Host ""
Write-Host "Resumen:" -ForegroundColor Cyan
$totalAttachments = 0
foreach ($tcId in $TestCaseIds) {
    if ($evidenceData[$tcId]) {
        $count = $evidenceData[$tcId].Attachments.Count
        $totalAttachments += $count
        Write-Host "  TC $tcId - $count attachment(s)" -ForegroundColor Yellow
    }
}
Write-Host ""
Write-Host "Total: $totalAttachments attachments" -ForegroundColor Cyan
