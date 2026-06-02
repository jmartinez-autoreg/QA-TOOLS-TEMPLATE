$f = 'C:\Users\Jhon Martinez\Documents\Motorambar\QA-TOOLS-TEMPLATE-edit\Template\copilot-instructions.md'
$bytes = [IO.File]::ReadAllBytes($f)
$content = [Text.Encoding]::UTF8.GetString($bytes)

# The broken segment: "path: " + CR + "esults/{tcId}/{name}.png, fullPage: true });"
# Build old broken string using explicit CR char
$broken = "path: " + [char]13 + "esults/{tcId}/{name}.png, fullPage: true });"
# Build correct replacement (no template literals - just show the path pattern)
$correct = "path: ``results/``" + '$' + "{tcId}/``" + '$' + "{name}.png``, fullPage: true });"

if ($content.Contains($broken)) {
    $fixed = $content.Replace($broken, $correct)
    [IO.File]::WriteAllText($f, $fixed, [Text.Encoding]::UTF8)
    Write-Host "Fixed successfully"
} else {
    Write-Host "Pattern not found - trying alternate"
    # Try with just the short identifier
    $idx = $content.IndexOf("page.screenshot({ path: ")
    Write-Host "page.screenshot at: $idx"
    if ($idx -ge 0) {
        $context = $content.Substring($idx - 2, 80)
        Write-Host "Context bytes:"
        [Text.Encoding]::UTF8.GetBytes($context) -join ','
    }
}
