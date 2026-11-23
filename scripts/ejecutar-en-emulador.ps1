# Compila ActividadB1, la ejecuta en el emulador Pixel6_API34, prueba la navegacion
# entre las dos pantallas y guarda las capturas en la carpeta entrega\.
# Uso (desde la raiz del proyecto):
#   powershell -ExecutionPolicy Bypass -File .\scripts\ejecutar-en-emulador.ps1

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$sdk = Join-Path $env:LOCALAPPDATA "Android\Sdk"
$adb = Join-Path $sdk "platform-tools\adb.exe"
$emu = Join-Path $sdk "emulator\emulator.exe"
$env:ANDROID_HOME = $sdk
if (-not $env:JAVA_HOME) {
    $env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-17.0.21.102-hotspot"
}
$pkg = "com.example.actividadb1"
New-Item -ItemType Directory -Force -Path "entrega" | Out-Null

Write-Host "1/6 Compilando (assembleDebug)..." -ForegroundColor Cyan
& .\gradlew.bat assembleDebug
if ($LASTEXITCODE -ne 0) { throw "Fallo la compilacion" }
$apk = "app\build\outputs\apk\debug\app-debug.apk"
Copy-Item $apk "entrega\app-debug.apk" -Force

Write-Host "2/6 Iniciando emulador Pixel6_API34..." -ForegroundColor Cyan
& $adb start-server | Out-Null
$devices = (& $adb devices) -join "`n"
if ($devices -notmatch "emulator-\d+\s+device") {
    Start-Process -FilePath $emu -ArgumentList "-avd", "Pixel6_API34", "-gpu", "angle_indirect", "-no-snapshot", "-no-audio"
}
& $adb wait-for-device
$intentos = 0
while ($intentos -lt 180) {
    $boot = "$(& $adb shell getprop sys.boot_completed 2>$null)".Trim()
    if ($boot -eq "1") { break }
    Start-Sleep -Seconds 5
    $intentos++
    if ($intentos % 6 -eq 0) { Write-Host "   esperando el arranque de Android... ($($intentos * 5) s)" }
}
if ($intentos -ge 180) { throw "El emulador no termino de arrancar en 15 min" }
Start-Sleep -Seconds 5
& $adb shell input keyevent 82 | Out-Null

Write-Host "3/6 Instalando la app..." -ForegroundColor Cyan
& $adb install -r $apk
if ($LASTEXITCODE -ne 0) { throw "Fallo la instalacion" }
& $adb shell am start -n "$pkg/.MainActivity" | Out-Null
Start-Sleep -Seconds 3

function Captura($nombre) {
    & $adb shell screencap -p /sdcard/captura.png | Out-Null
    & $adb pull /sdcard/captura.png "entrega\$nombre" | Out-Null
    Write-Host "   captura guardada: entrega\$nombre"
}

function Dump-UI {
    & $adb shell uiautomator dump /sdcard/ui.xml | Out-Null
    & $adb pull /sdcard/ui.xml (Join-Path $env:TEMP "ui.xml") | Out-Null
    return Get-Content (Join-Path $env:TEMP "ui.xml") -Raw -Encoding UTF8
}

function Existe($id) {
    return (Dump-UI) -match "$pkg`:id/$id"
}

function Tocar($id) {
    [xml]$x = Dump-UI
    $nodo = $x.SelectNodes("//node") | Where-Object { $_.'resource-id' -eq "${pkg}:id/$id" } | Select-Object -First 1
    if (-not $nodo) { throw "No encontre el elemento $id en pantalla" }
    if ($nodo.bounds -match '\[(\d+),(\d+)\]\[(\d+),(\d+)\]') {
        $cx = [int](([int]$Matches[1] + [int]$Matches[3]) / 2)
        $cy = [int](([int]$Matches[2] + [int]$Matches[4]) / 2)
        & $adb shell input tap $cx $cy | Out-Null
    }
}

Write-Host "4/6 Pantalla 1 (MainActivity)..." -ForegroundColor Cyan
if (-not (Existe "btn_siguiente")) { throw "FALLO: no aparece la pantalla principal" }
Captura "01_main.png"

Write-Host "5/6 Tocando el boton -> Pantalla 2 (SecondActivity)..." -ForegroundColor Cyan
Tocar "btn_siguiente"
Start-Sleep -Seconds 2
if (-not (Existe "btn_regresar")) { throw "FALLO: el boton no abrio la segunda ventana" }
Captura "02_second.png"

Write-Host "6/6 Tocando Regresar -> vuelve a la Pantalla 1..." -ForegroundColor Cyan
Tocar "btn_regresar"
Start-Sleep -Seconds 2
if (-not (Existe "btn_siguiente")) { throw "FALLO: Regresar no volvio a la pantalla principal" }
Captura "03_regreso.png"

Write-Host ""
Write-Host "LISTO: la app compila, corre en el emulador y la navegacion funciona." -ForegroundColor Green
Write-Host "Archivos en entrega\: app-debug.apk, 01_main.png, 02_second.png, 03_regreso.png"
