# FASE 1: MARCAR TCs OBSOLETOS (Estrategia conservadora)
# Este script RENOMBRA los TCs Design a "OBSOLETO-{US_ID}" para revisión manual posterior

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

$headersGet = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))
}

Write-Host "╔═══════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
Write-Host "║          FASE 1: MARCAR TCs OBSOLETOS (No elimina nada)                  ║" -ForegroundColor Yellow
Write-Host "╚═══════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
Write-Host ""
Write-Host "📋 Esta estrategia:" -ForegroundColor Cyan
Write-Host "   ✅ Renombra TCs Design a 'OBSOLETO-{US_ID} - título original'" -ForegroundColor Green
Write-Host "   ✅ Mantiene todos los vínculos intactos" -ForegroundColor Green
Write-Host "   ✅ Permite revisión manual antes de eliminar" -ForegroundColor Green
Write-Host "   ❌ NO elimina ningún TC" -ForegroundColor Red
Write-Host ""

# Mapeo de TCs a marcar como obsoletos por US
$tcsObsoletos = @{
    9817 = @(10283, 10284, 10285, 10286, 10282, 10287)
    9856 = @(10233, 10234, 10235, 10236, 10237, 10238)
    9873 = @(10625, 10626, 10627, 10628, 10629)
    9892 = @(10067, 10066, 10068, 10069, 10070, 10678, 10677)
    9940 = @(10086, 10084, 10085)
    9947 = @(10206, 10207, 10204, 10203, 10202, 10208, 10205)
}

$totalMarcar = 0
$totalExitoso = 0
$totalFallido = 0

foreach ($usId in $tcsObsoletos.Keys) {
    Write-Host "═══════════════════════════════════════════════════════════════════════════"
    Write-Host "📋 US $usId" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════"
    
    $tcsList = $tcsObsoletos[$usId]
    $totalMarcar += $tcsList.Count
    
    Write-Host "TCs a marcar como obsoletos: $($tcsList.Count)" -ForegroundColor Yellow
    Write-Host ""
    
    foreach ($tcId in $tcsList) {
        try {
            # Obtener el TC actual
            $urlTC = "https://dev.azure.com/$org/$project/_apis/wit/workitems/${tcId}?api-version=7.0"
            $tc = Invoke-RestMethod -Uri $urlTC -Headers $headersGet -Method Get
            
            $tituloActual = $tc.fields.'System.Title'
            
            # Verificar si ya está marcado como obsoleto
            if ($tituloActual -like "*OBSOLETO-*") {
                Write-Host "  ⚠️  TC $tcId ya está marcado como obsoleto" -ForegroundColor Yellow
                Write-Host "     Título: $tituloActual" -ForegroundColor DarkGray
                $totalExitoso++
                Write-Host ""
                continue
            }
            
            # Crear nuevo título (acortar si es necesario para no exceder 255 caracteres)
            $prefijo = "[OBSOLETO-$usId]"
            $maxLen = 255 - $prefijo.Length - 3  # -3 para " - "
            
            if ($tituloActual.Length -gt $maxLen) {
                $tituloCorto = $tituloActual.Substring(0, $maxLen - 3) + "..."
                $nuevoTitulo = "$prefijo $tituloCorto"
            } else {
                $nuevoTitulo = "$prefijo $tituloActual"
            }
            
            Write-Host "  🔄 Renombrando TC $tcId..." -ForegroundColor Gray
            Write-Host "     Actual : $tituloActual" -ForegroundColor DarkGray
            Write-Host "     Nuevo  : $nuevoTitulo" -ForegroundColor DarkCyan
            
            # Actualizar el título
            $urlPatch = "https://dev.azure.com/$org/$project/_apis/wit/workitems/${tcId}?api-version=7.0"
            
            $body = @(
                @{
                    op = "add"
                    path = "/fields/System.Title"
                    value = $nuevoTitulo
                }
            ) | ConvertTo-Json
            
            $result = Invoke-RestMethod -Uri $urlPatch -Headers $headers -Method Patch -Body $body
            
            Write-Host "  ✅ Renombrado correctamente" -ForegroundColor Green
            $totalExitoso++
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
Write-Host "  Total TCs procesados: $totalMarcar" -ForegroundColor White
Write-Host "  ✅ Exitosos: $totalExitoso" -ForegroundColor Green
Write-Host "  ❌ Fallidos: $totalFallido" -ForegroundColor Red
Write-Host ""
Write-Host "✅ Todos los TCs siguen vinculados a sus USs" -ForegroundColor Green
Write-Host "✅ Puedes revisar cada TC 'OBSOLETO-{US_ID}' antes de eliminarlo" -ForegroundColor Green
Write-Host "✅ Si encuentras información necesaria, puedes incorporarla al TC consolidado" -ForegroundColor Green
Write-Host ""
Write-Host "📌 Próximo paso: Crear los TCs consolidados (FASE 2)" -ForegroundColor Cyan
Write-Host ""
