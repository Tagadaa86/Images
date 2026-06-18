# === Configuration ===
$ImageUrl   = "https://raw.githubusercontent.com/Tagadaa86/Images/refs/heads/main/novalysgroupe.jpg"
$LocalDir   = "C:\ProgramData\NovalysWallpaper"
$LocalImage = "$LocalDir\novalysgroupe.jpg"
$RegPath    = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"

# === Téléchargement de l'image ===
if (-not (Test-Path $LocalDir)) {
    New-Item -ItemType Directory -Path $LocalDir -Force | Out-Null
}

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $ImageUrl -OutFile $LocalImage -UseBasicParsing -Headers @{ "User-Agent" = "Mozilla/5.0" }
}
catch {
    Write-Output "Echec du telechargement : $_"
    exit 1
}

# === Création de la clé de registre ===
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# === Fond d'écran du bureau ===
New-ItemProperty -Path $RegPath -Name "DesktopImagePath"   -Value $LocalImage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "DesktopImageUrl"    -Value $LocalImage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "DesktopImageStatus" -Value 1 -PropertyType DWord -Force | Out-Null

# === Écran de verrouillage (même image) ===
New-ItemProperty -Path $RegPath -Name "LockScreenImagePath"   -Value $LocalImage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "LockScreenImageUrl"    -Value $LocalImage -PropertyType String -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "LockScreenImageStatus" -Value 1 -PropertyType DWord -Force | Out-Null

Write-Output "Configuration appliquee avec succes."
exit 0