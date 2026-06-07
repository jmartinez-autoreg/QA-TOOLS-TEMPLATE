$org = "AutoregPR"
$project = "Motorambar"
$usId = 9856
$tcConsolidado = 11231
$tcObsoletos = @(10666, 10667, 10668, 10669)

# Get PAT
$config = Get-Content "$env:APPDATA\Code\User\mcp.json" -Raw | ConvertFrom-Json
$pat = $config.servers.ado.env.AZURE_DEVOPS_EXT_PAT

$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))
    "Content-Type" = "application/json"
}

# Construir comentario HTML según formato simple del skill oficial
$fecha = (Get-Date).ToString("dd/MM/yyyy")

$html = @"
<h2 style="color:#1a7f37;">✅ QA PASSED</h2>
<p><b>Fecha:</b> $fecha</p>
<p><b>Sprint:</b> S2 Entregable 3</p>
<p><b>TC Consolidado:</b> <a href="https://dev.azure.com/$org/$project/_workitems/edit/$tcConsolidado">TC-$tcConsolidado</a></p>

<hr/>

<h3>📋 Escenarios Validados</h3>
<ul>
  <li>✅ Visualización y búsqueda por VIN, placa, modelo, cliente</li>
  <li>✅ Validación de restricciones de longitud (VIN 17 dígitos)</li>
  <li>✅ Búsqueda por rango de fechas con calendario funcional</li>
  <li>✅ Persistencia y retención de filtros durante la sesión</li>
</ul>

<p><b>Resultado:</b> Todos los criterios de aceptación cumplen con lo esperado.</p>

<hr/>

<h3>📎 Referencias de Evidencia</h3>
<p>La evidencia de ejecución previa se encuentra en los siguientes Test Cases:</p>
<ul>
  <li><a href="https://dev.azure.com/$org/$project/_workitems/edit/10666">TC-10666</a> - Visualizar y buscar (4 pasos)</li>
  <li><a href="https://dev.azure.com/$org/$project/_workitems/edit/10667">TC-10667</a> - Validar restricciones (2 pasos)</li>
  <li><a href="https://dev.azure.com/$org/$project/_workitems/edit/10668">TC-10668</a> - Búsqueda por rango fechas (3 pasos)</li>
  <li><a href="https://dev.azure.com/$org/$project/_workitems/edit/10669">TC-10669</a> - Persistencia y retención (2 pasos)</li>
</ul>

<p><i>Nota: Los TCs anteriores fueron consolidados en TC-$tcConsolidado para optimizar el backlog de regresión.</i></p>

<hr/>
<small>🤖 QA-PRO Agent — Documentación Sprint Test — $fecha</small>
"@

# Publicar comentario en la US
$url = "https://dev.azure.com/$org/$project/_apis/wit/workItems/$usId/comments?api-version=7.0-preview.3"
$body = @{
    text = $html
} | ConvertTo-Json

Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "PUBLICANDO QA PASSED EN US $usId"
Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

try {
    $result = Invoke-RestMethod -Uri $url -Headers $headers -Method Post -Body $body
    
    Write-Host "✅ Comentario publicado exitosamente" -ForegroundColor Green
    Write-Host ""
    Write-Host "ID del comentario: $($result.id)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Ver en ADO:" -ForegroundColor Cyan
    Write-Host "https://dev.azure.com/$org/$project/_workitems/edit/$usId" -ForegroundColor White
    Write-Host ""
}
catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.ErrorDetails.Message) {
        Write-Host ""
        Write-Host "Detalles:" -ForegroundColor Yellow
        $_.ErrorDetails.Message | ConvertFrom-Json | ConvertTo-Json -Depth 5
    }
}
