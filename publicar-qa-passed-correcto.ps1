$org = "AutoregPR"
$project = "Motorambar"
$usId = 9856
$runId = 688

# Test Results data
$testResults = @(
    @{ TC = 10666; ResultId = 100000 }
    @{ TC = 10667; ResultId = 100001 }
    @{ TC = 10668; ResultId = 100002 }
    @{ TC = 10669; ResultId = 100003 }
)

# Get PAT
$config = Get-Content "$env:APPDATA\Code\User\mcp.json" -Raw | ConvertFrom-Json
$pat = $config.servers.ado.env.AZURE_DEVOPS_EXT_PAT
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))
    "Content-Type" = "application/json"
}

Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "PUBLICANDO COMENTARIOS QA PASSED EN US $usId"
Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$comentariosPublicados = 0

foreach ($item in $testResults) {
    $tcId = $item.TC
    $resultId = $item.ResultId
    $testResultUrl = "https://dev.azure.com/$org/$project/_testManagement/runs?_a=resultSummary&runId=$runId&resultId=$resultId"
    
    Write-Host "TC $tcId..." -ForegroundColor Yellow
    
    # Get attachments (screenshots)
    $attachUrl = "https://dev.azure.com/$org/$project/_apis/test/runs/$runId/results/$resultId/attachments?api-version=7.0"
    
    try {
        $attachments = Invoke-RestMethod -Uri $attachUrl -Headers $headers
        
        if ($attachments.value -and $attachments.value.Count -gt 0) {
            $screenshot = $attachments.value[0]
            
            # Construir comentario HTML (formato CASO REGULAR)
            $commentHtml = @"
QA PASSED / Sprint Test

$testResultUrl

<img src="$($screenshot.url)" width="720" style="border:1px solid #ccc;" />
"@
            
            # Publicar comentario
            $body = @{ text = $commentHtml } | ConvertTo-Json -Depth 3
            $commentUri = "https://dev.azure.com/$org/$project/_apis/wit/workItems/$usId/comments?api-version=7.0-preview.3"
            
            $result = Invoke-RestMethod -Uri $commentUri -Method Post -Headers $headers -Body $body
            
            Write-Host "  ✅ Comentario publicado (ID: $($result.id))" -ForegroundColor Green
            Write-Host "     Screenshot: $($screenshot.fileName)" -ForegroundColor Gray
            
            $comentariosPublicados++
        } else {
            Write-Host "  ⚠️  Sin screenshots - comentario sin imagen" -ForegroundColor Yellow
            
            # Publicar sin imagen
            $commentHtml = @"
QA PASSED / Sprint Test

$testResultUrl

[Screenshot no disponible en Test Result]
"@
            
            $body = @{ text = $commentHtml } | ConvertTo-Json -Depth 3
            $commentUri = "https://dev.azure.com/$org/$project/_apis/wit/workItems/$usId/comments?api-version=7.0-preview.3"
            
            $result = Invoke-RestMethod -Uri $commentUri -Method Post -Headers $headers -Body $body
            
            Write-Host "  ✅ Comentario publicado sin imagen (ID: $($result.id))" -ForegroundColor Green
            
            $comentariosPublicados++
        }
    }
    catch {
        Write-Host "  ❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
}

Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "✅ COMPLETADO"
Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "  📋 US: $usId" -ForegroundColor White
Write-Host "  💬 Comentarios publicados: $comentariosPublicados / $($testResults.Count)" -ForegroundColor White
Write-Host "  🔗 Ver en ADO: https://dev.azure.com/$org/$project/_workitems/edit/$usId" -ForegroundColor Cyan
Write-Host ""
