# ActividadB1 — Desarrollo de Plataformas Móviles (UTPL)

Aplicación Android nativa (Kotlin + XML) que muestra **texto, una imagen y un botón**
que conduce a **otra ventana** (Activity).

Autor: Emilio Peña

## En qué se basa

| Clase | Tema | Dónde se usa |
|-------|------|--------------|
| 3 | Android Studio, SDK y emulador | Configuración del proyecto y ejecución |
| 4 | Layouts y archivos XML | `activity_main.xml`, `activity_second.xml` |
| 5 | `Intent` y `findViewById` | Navegación entre `MainActivity` y `SecondActivity` |

## Flujo de la aplicación

```
MainActivity  --(botón "Ir a la segunda ventana" / Intent)-->  SecondActivity
MainActivity  <--(botón "Regresar" / finish())---------------  SecondActivity
```

## Estructura

```
app/src/main/
├── java/com/example/actividadb1/
│   ├── MainActivity.kt      # pantalla 1: texto, imagen y botón
│   └── SecondActivity.kt    # pantalla 2: mensaje y botón Regresar
├── res/layout/              # diseños XML de cada pantalla
├── res/values/strings.xml   # todos los textos
└── AndroidManifest.xml      # declaración de las dos Activities
scripts/ejecutar-en-emulador.ps1   # compila, ejecuta y saca capturas
entrega/                           # APK y capturas de ejecución
```

## Cómo ejecutarlo

Requisitos: JDK 17, Android SDK (platform 34) y un AVD llamado `Pixel6_API34`.

**Todo en un comando (Windows, desde la raíz del proyecto):**

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\ejecutar-en-emulador.ps1
```

**Manualmente:**

```powershell
.\gradlew.bat assembleDebug
adb install -r app\build\outputs\apk\debug\app-debug.apk
adb shell am start -n com.example.actividadb1/.MainActivity
```

**En un dispositivo físico:** activar *Opciones de desarrollador* y *Depuración USB*,
conectar por cable, aceptar el aviso en el teléfono y ejecutar los mismos comandos `adb`.
También se puede abrir el proyecto en Android Studio y pulsar Run.

## Ramas

- `main`: versión inicial estable.
- `develop`: rama de integración con el trabajo terminado.
