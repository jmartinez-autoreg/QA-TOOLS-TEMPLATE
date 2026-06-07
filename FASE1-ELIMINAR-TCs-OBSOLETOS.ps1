# FASE 1: LIMPIEZA DE TCs OBSOLETOS
# Este script elimina los vínculos "Tested By" de TCs Design obsoletos

$org = "AutoregPR"
$project = "Motorambar"
$pat = $env:AZURE_DEVOPS_EXT_PAT

if (-not $pat) {
    $config = Get-Content "$env:APPDATA\Code\User\mcp.json" -Raw | ConvertFrom-Json
    $pat = $config.servers.ado.env.AZURE_DEVOPS_EXT_PAT
}

$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))
    "Content-Type" = "application/json-patch+json"
}

Write-Host "╔═══════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Red
Write-Host "║          FASE 1: ELIMINAR TCs OBSOLETOS (Design)                         ║" -ForegroundColor Red
Write-Host "╚═══════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Red
Write-Host ""

# Mapeo de TCs a eliminar por US
$tcsEliminar = @{
    9817 = @(10283, 10284, 10285, 10286, 10282, 10287)
    9856 = @(10233, 10234, 10235, 10236, 10237, 10238)
    9873 = @(10625, 10626, 10627, 10628, 10629)
    9892 = @(10067, 10066, 10068, 10069, 10070, 10678, 10677)
    9940 = @(10086, 10084, 10085)
    9947 = @(10206, 10207, 10204, 10203, 10202, 10208, 10205)
}

$totalEliminar = 0
$totalExitoso = 0
$totalFallido = 0

foreach ($usId in $tcsEliminar.Keys) {
    Write-Host "═══════════════════════════════════════════════════════════════════════════"
    Write-Host "📋 US $usId" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════"
    
    $tcsList = $tcsEliminar[$usId]
    $totalEliminar += $tcsList.Count
    
    Write-Host "TCs a desvincular: $($tcsList.Count)" -ForegroundColor Yellow
    Write-Host ""
    
    foreach ($tcId in $tcsList) {
        try {
            # Obtener el TC para saber el título
            $urlTC = "https://dev.azure.com/$org/$project/_apis/wit/workitems/${tcId}?api-version=7.0"
            $headersGet = @{
                Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))
            }
            $tc = Invoke-RestMethod -Uri $urlTC -Headers $headersGet -Method Get
            $tcTitle = $tc.fields.'System.Title'
            
            Write-Host "  Desvinculando TC $tcId..." -ForegroundColor Gray
            Write-Host "  Título: $tcTitle" -ForegroundColor DarkGray
            
            # Obtener la US para encontrar el link correcto
            $urlUS = "https://dev.azure.com/$org/$project/_apis/wit/workitems/${usId}?`$expand=relations&api-version=7.0"
            $us = Invoke-RestMethod -Uri $urlUS -Headers $headersGet -Method Get
            
            # Buscar el índice del link "TestedBy-Forward" que apunta a este TC
            $linkIndex = -1
            if ($us.relations) {
                for ($i = 0; $i -lt $us.relations.Count; $i++) {
                    if ($us.relations[$i].rel -eq "Microsoft.VSTS.Common.TestedBy-Forward") {
                        $linkedTcId = [int]($us.relations[$i].url -split '/')[-1]
                        if ($linkedTcId -eq $tcId) {
                            $linkIndex = $i
                            break
                        }
                    }
                }
            }
            
            if ($linkIndex -ge 0) {
                # Eliminar el vínculo
                $urlPatch = "https://dev.azure.com/$org/$project/_apis/wit/workitems/${usId}?api-version=7.0"
                
                $body = @(
                    @{
                        op = "remove"
                        path = "/relations/$linkIndex"
                    }
                ) | ConvertTo-Json
                
                $result = Invoke-RestMethod -Uri $urlPatch -Headers $headers -Method Patch -Body $body
                
                Write-Host "  ✅ Desvinculado correctamente" -ForegroundColor Green
                $totalExitoso++
            } else {
                Write-Host "  ⚠️  Link no encontrado (ya desvinculado?)" -ForegroundColor Yellow
                $totalExitoso++
            }
        }
        catch {
            Write-Host "  ❌ Error: $($_.Exception.Message)" -ForegroundColor Red
            $totalFallido++
        }
        
        Write-Host ""
    }
}

Write-Host "╔═══════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                    FASE 1 COMPLETADA                                      ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════════"
Write-Host "RESUMEN:"
Write-Host "═══════════════════════════════════════════════════════════════════════════"
Write-Host "  Total TCs procesados: $totalEliminar" -ForegroundColor White
Write-Host "  ✅ Exitosos: $totalExitoso" -ForegroundColor Green
Write-Host "  ❌ Fallidos: $totalFallido" -ForegroundColor Red
Write-Host ""
Write-Host "⚠️  Los TCs desvinculados aún existen en ADO pero ya no están asociados a las USs" -ForegroundColor Yellow
Write-Host "   Puedes eliminarlos permanentemente desde la UI de Azure DevOps si lo deseas" -ForegroundColor Gray
Write-Host ""
