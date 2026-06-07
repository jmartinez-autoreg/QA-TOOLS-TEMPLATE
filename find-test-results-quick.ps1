$org = "AutoregPR"
$project = "Motorambar"
$targetTCs = @(10666, 10667, 10668, 10669)

# Get PAT
$config = Get-Content "$env:APPDATA\Code\User\mcp.json" -Raw | ConvertFrom-Json
$pat = $config.servers.ado.env.AZURE_DEVOPS_EXT_PAT
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))
}

Write-Host "Buscando Test Results..." -ForegroundColor Cyan
Write-Host ""

$found = @{}

# Get recent runs
$runsUrl = "https://dev.azure.com/$org/$project/_apis/test/runs?api-version=7.0&`$top=50"
$runs = Invoke-RestMethod -Uri $runsUrl -Headers $headers

foreach ($run in $runs.value) {
    $resultsUrl = "https://dev.azure.com/$org/$project/_apis/test/runs/$($run.id)/results?api-version=7.0"
    
    try {
        $results = Invoke-RestMethod -Uri $resultsUrl -Headers $headers
        
        foreach ($tcId in $targetTCs) {
            if (-not $found[$tcId]) {
                $match = $results.value | Where-Object { $_.testCase.id -eq $tcId.ToString() }
                
                if ($match) {
                    $url = "https://dev.azure.com/$org/$project/_testManagement/runs?_a=resultSummary&runId=$($run.id)&resultId=$($match.id)"
                    
                    $found[$tcId] = @{
                        RunId = $run.id
                        ResultId = $match.id
                        Outcome = $match.outcome
                        Url = $url
                    }
                    
                    Write-Host "✅ TC $tcId - Run: $($run.id), Result: $($match.id)" -ForegroundColor Green
                }
            }
        }
        
        if ($found.Count -eq $targetTCs.Count) { break }
    }
    catch {}
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "RESUMEN"
Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

foreach ($tcId in $targetTCs) {
    if ($found[$tcId]) {
        Write-Host "TC $tcId" -ForegroundColor Yellow
        Write-Host "  $($found[$tcId].Url)" -ForegroundColor Cyan
        Write-Host ""
    } else {
        Write-Host "TC $tcId - ❌ No encontrado" -ForegroundColor Red
        Write-Host ""
    }
}

# Save
$found | ConvertTo-Json -Depth 3 | Out-File "test-results-urls.json"
Write-Host "Guardado en: test-results-urls.json" -ForegroundColor Gray
