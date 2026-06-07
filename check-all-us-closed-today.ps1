$org = "AutoregPR"; $project = "Motorambar"
$config = Get-Content "$env:APPDATA\Code\User\mcp.json" -Raw | ConvertFrom-Json
$pat = $config.servers.ado.env.AZURE_DEVOPS_EXT_PAT
$headers = @{Authorization="Basic "+[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))}

# Lista de USs a verificar
$usIds = @(9516, 10461, 9890, 10802, 9806, 9888, 9545, 9887, 11051, 9546, 9868, 9881, 10865, 9583, 9609, 10454, 10875, 11016, 11052, 10450, 10878, 9859, 9515, 9804, 10845, 9836, 10876)

Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "VERIFICANDO $($usIds.Count) USER STORIES"
Write-Host "Periodo: 7:00 AM - 5:00 PM (3 de junio 2026, UTC-4)"
Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# 7 AM UTC-4 = 11:00 UTC, 5 PM UTC-4 = 21:00 UTC
$start = [DateTime]::Parse("2026-06-03T11:00:00Z")
$end = [DateTime]::Parse("2026-06-03T21:00:00Z")

$closedInRange = @()
$processed = 0

foreach ($id in $usIds) {
    $processed++
    
    if ($processed % 5 -eq 0) {
        Write-Host "  Procesadas: $processed / $($usIds.Count)" -ForegroundColor Gray
    }
    
    try {
        $url = "https://dev.azure.com/$org/$project/_apis/wit/workItems/$id`?api-version=7.0"
        $wi = Invoke-RestMethod -Uri $url -Headers $headers
        
        $state = $wi.fields.'System.State'
        
        if ($state -eq 'Closed') {
            $changeDate = [DateTime]::Parse($wi.fields.'Microsoft.VSTS.Common.StateChangeDate')
            
            if ($changeDate -ge $start -and $changeDate -le $end) {
                $localTime = $changeDate.AddHours(-4)
                
                $closedInRange += [PSCustomObject]@{
                    Id = $id
                    Title = $wi.fields.'System.Title'
                    Time = $localTime.ToString('hh:mm tt')
                    TimeSort = $localTime
                    Assigned = if ($wi.fields.'System.AssignedTo') { $wi.fields.'System.AssignedTo'.displayName } else { "Sin asignar" }
                    SP = if ($wi.fields.'Microsoft.VSTS.Scheduling.StoryPoints') { $wi.fields.'Microsoft.VSTS.Scheduling.StoryPoints' } else { 0 }
                }
            }
        }
    }
    catch {
        Write-Host "  ⚠️  US $id - Error: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "RESULTADOS"
Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""

if ($closedInRange.Count -gt 0) {
    Write-Host "✅ $($closedInRange.Count) User Stories cerradas entre 7:00 AM - 5:00 PM hoy" -ForegroundColor Green
    Write-Host ""
    
    # Ordenar por hora
    $closedInRange | Sort-Object TimeSort | ForEach-Object {
        Write-Host "US $($_.Id)" -ForegroundColor Yellow -NoNewline
        Write-Host " - $($_.Time)" -ForegroundColor Cyan -NoNewline
        Write-Host " - $($_.SP) SP" -ForegroundColor White
        Write-Host "  $($_.Title)" -ForegroundColor Gray
        Write-Host "  👤 $($_.Assigned)" -ForegroundColor DarkGray
        Write-Host ""
    }
    
    Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "RESUMEN"
    Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    
    $totalSP = ($closedInRange | Measure-Object -Property SP -Sum).Sum
    
    Write-Host "  📊 Total USs: $($closedInRange.Count)" -ForegroundColor White
    Write-Host "  📈 Total Story Points: $totalSP SP" -ForegroundColor White
    Write-Host ""
    
    # Agrupar por asignado
    Write-Host "Por persona:" -ForegroundColor Cyan
    $closedInRange | Group-Object Assigned | Sort-Object Count -Descending | ForEach-Object {
        $personSP = ($_.Group | Measure-Object -Property SP -Sum).Sum
        Write-Host "  • $($_.Name): $($_.Count) USs ($personSP SP)" -ForegroundColor Gray
    }
    
} else {
    Write-Host "⚠️  Ninguna User Story cerrada en el rango de horas especificado" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Fecha: 3 de junio 2026, 7:00 AM - 5:00 PM (UTC-4)" -ForegroundColor DarkGray
