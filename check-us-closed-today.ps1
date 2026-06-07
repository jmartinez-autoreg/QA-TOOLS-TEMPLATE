$org = "AutoregPR"; $project = "Motorambar"
$config = Get-Content "$env:APPDATA\Code\User\mcp.json" -Raw | ConvertFrom-Json
$pat = $config.servers.ado.env.AZURE_DEVOPS_EXT_PAT
$headers = @{Authorization="Basic "+[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))}

Write-Host "Obteniendo USs cerradas hoy..." -ForegroundColor Cyan
Write-Host ""

# 7 AM UTC-4 = 11:00 UTC, 5 PM UTC-4 = 21:00 UTC
$start = [DateTime]::Parse("2026-06-03T11:00:00Z")
$end = [DateTime]::Parse("2026-06-03T21:00:00Z")

$usIds = @(9881, 9887, 11016)
$inRange = @()

foreach ($id in $usIds) {
    $url = "https://dev.azure.com/$org/$project/_apis/wit/workItems/$id`?`$expand=all&api-version=7.0"
    $wi = Invoke-RestMethod -Uri $url -Headers $headers
    
    $changeDate = [DateTime]::Parse($wi.fields.'Microsoft.VSTS.Common.StateChangeDate')
    
    if ($changeDate -ge $start -and $changeDate -le $end) {
        $localTime = $changeDate.AddHours(-4)
        $inRange += @{Id=$id; Title=$wi.fields.'System.Title'; Time=$localTime; Assigned=$wi.fields.'System.AssignedTo'.displayName}
        
        Write-Host "✅ US $id - Cerrada a las $($localTime.ToString('hh:mm tt'))" -ForegroundColor Green
        Write-Host "   $($wi.fields.'System.Title')" -ForegroundColor White
        Write-Host "   Asignada: $($wi.fields.'System.AssignedTo'.displayName)" -ForegroundColor Gray
        Write-Host ""
    }
}

Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "TOTAL: $($inRange.Count) User Stories cerradas entre 7 AM - 5 PM hoy" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
