# HouseKeep — Screenshot Plan (v1.0.0)

Plan operacional para capturar las 6 screenshots de stores en ES + EN, por device target.

## Devices requeridos por store

| Store | Device | Resolución | Cantidad |
|-------|--------|------------|----------|
| App Store | iPhone 6.7" (15/14/13/12 Pro Max) | 1290×2796 | 6 (ES) + 6 (EN) |
| App Store | iPhone 6.5" (XS Max / 11 Pro Max) | 1242×2688 | 6 (ES) + 6 (EN) |
| App Store | iPad Pro 13" (M4) — opcional | 2064×2752 | 6 (ES) + 6 (EN) |
| Play | Android phone | 1080×1920 mínimo (recomendado 1440×3200) | 6 (ES) + 6 (EN) |
| Play | Android 7" tablet | 1280×720 real emulator | 4 (ES) + 4 (EN) en `store/screenshots/android/tablet_7_real/` |
| Play | Android 10" tablet | 1920×1080 real emulator | 4 (ES) + 4 (EN) en `store/screenshots/android/tablet_10_real/` |

**Total mínimo:** 48 capturas (4 devices × 6 × 2 idiomas). Si solo soportas iPhone 6.7" + Android phone: 24.

> Apple desde iOS 17 ya solo exige el set de **iPhone 6.7"** y **iPad 13"** — el resto se escala. Empieza por esos dos.
> Para Google Play, las tablet 7"/10" se han cubierto con 4 capturas reales por idioma
> (dashboard, items, detail, documents). Si Play Console acepta el formulario, no hace
> falta generar 6 composiciones por tablet.

## Las 6 capturas

| # | Pantalla | Datos visibles | Caption EN | Caption ES |
|---|----------|----------------|-----------|-----------|
| 1 | Home dashboard | 3 eventos próximos (1 verde, 1 ámbar, 1 rojo) + counters | Your home, always under control | Tu casa, siempre al día |
| 2 | Items list | 5 items con foto + badge de garantía mixta | Track every appliance & warranty | Controla cada electrodoméstico |
| 3 | Item detail + maintenance | Caldera con 2 mantenimientos (uno próximo, uno hecho) | Never forget a service again | No olvides ningún mantenimiento |
| 4 | Documents list | DNI verde, ITV ámbar, seguro rojo | Document expiry alerts | Avisos de caducidad |
| 5 | Notification mockup | Lock screen con notificación "Caldera: revisión en 7 días" | Smart reminders, perfectly timed | Recordatorios en el momento justo |
| 6 | Paywall Free vs Pro | Comparativa + precio 4,99 € | Unlock everything. Once. Forever. | Desbloquéalo todo. Una vez. Para siempre. |

## Estilo visual (todas las capturas)

- **Status bar:** simulada en `09:41` (Apple convention) / `9:41` (Pixel). Hora limpia.
- **Battery:** 100%.
- **Connection:** Wi-Fi + 5G full bars.
- **Frame:** opcional usar [shotbot.app](https://shotbot.app/) o [Mockuphone](https://mockuphone.com/) para añadir device frame y caption en bloque superior.
- **Background fill** (si frame): gradiente cream `#FAFAF8` → `#EBE8DE` (mismo que feature graphic).
- **Caption layout:** banda superior con caption bold + device debajo, ocupando 80% del alto.

## Datos demo (seed)

Para que las capturas se vean realistas en lugar de empty-state.

### Items (5)

| Categoría | Nombre | Marca | Modelo | Compra | Garantía | Foto |
|-----------|--------|-------|--------|--------|----------|------|
| heating | Caldera salón | Vaillant | ecoTEC plus | 2024-09-12 | 24 meses | sí (caldera_demo.jpg) |
| kitchen | Lavavajillas | Bosch | SMV4HVX33E | 2023-03-04 | 24 meses (vencida) | sí |
| laundry | Lavadora | LG | F4WV5012S0W | 2025-01-20 | 24 meses (activa) | sí |
| safety | Detector humo cocina | Kidde | i9080 | 2024-11-01 | 12 meses | no |
| kitchen | Frigorífico | Balay | 3HFE743XD | 2022-06-15 | 24 meses (vencida) | sí |

### Maintenances

- **Caldera salón:** "Revisión anual" cada 12 meses, último 2025-06-01 → next 2026-06-01 (verde) + "Cambio filtros" 6 meses, último 2025-11-15 → next 2026-05-15 (rojo: vence en días)
- **Detector humo:** "Test mensual" 1 mes, último 2026-04-01 → next 2026-05-01 (rojo, vencido)
- **Lavadora:** "Limpieza tambor" 3 meses, último 2026-02-15 → next 2026-05-15 (ámbar)

### Documents (3)

| Tipo | Nombre | Caducidad | Estado semáforo |
|------|--------|-----------|-----------------|
| identity | DNI Pablo | 2031-08-12 | verde |
| vehicle | ITV Volkswagen Polo | 2026-07-04 | ámbar (≈40 días) |
| insurance | Seguro hogar Mapfre | 2026-06-08 | rojo (≈13 días) |

> Fechas calculadas relativas a `2026-05-26` (today). Si capturas más tarde, regenera el offset para mantener el patrón rojo/ámbar/verde.

## Cómo cargar los datos demo

### Opción A — Manual (más rápido si solo capturas una vez)

Crea cada item/documento a mano desde la app. ~10 minutos. Reset entre idiomas: borra app + reinstala antes de cambiar locale.

### Opción B — Seed programático (recomendado si vas a iterar)

Añade un entrypoint Dart-define-gated. Crear `tools/seed_demo.dart`:

```dart
// tools/seed_demo.dart — run: flutter run -t tools/seed_demo.dart -d <device>
// Inserts demo data into the app DB, then exits.
import 'package:flutter/widgets.dart';
import 'package:housekeep/data/database/app_database.dart';
// ... resto: instanciar DAOs, insertar items/maintenances/documents con dates relativas.
```

Implementación detallada queda para cuando se decida (~30 min de trabajo). Patrón: usa `AppDatabase()` directo, calcula fechas con `DateTime.now().add(...)`, llama `into(items).insert(ItemsCompanion(...))`, etc.

### Opción C — Modo "Demo data" en Settings (DEBUG only)

Añadir botón oculto en Settings (visible solo en `kDebugMode`) que ejecute la misma función de seed. Útil para QA + screenshots.

## Captura por plataforma

### iOS (Simulator)

```bash
# Lista simulators
xcrun simctl list devices available | grep "iPhone 15 Pro Max\|iPhone 13 Pro Max"

# Levanta el simulator y captura
open -a Simulator --args -CurrentDeviceUDID <UDID>
flutter run -d <device-id>
# en otra terminal:
xcrun simctl io booted screenshot ~/Desktop/hk_01_home_en.png

# Para cambiar idioma del simulator:
xcrun simctl spawn booted defaults write -g AppleLanguages -array es
xcrun simctl spawn booted defaults write -g AppleLocale es_ES
xcrun simctl shutdown booted && xcrun simctl boot <UDID>
```

Para mockup con frame + caption: importar PNGs a Figma con plantillas de App Store, o usar **fastlane snapshot + frameit**:

```bash
cd ios
fastlane snapshot init
# editar Snapfile + tests/SnapshotHelper.swift
fastlane snapshot
fastlane frameit
```

### Android (Emulator)

```bash
# Crear emulator phone
avdmanager create avd -n hk_pixel8 -k "system-images;android-34;google_apis;x86_64" -d "pixel_8"
emulator -avd hk_pixel8 &

# Cambiar idioma:
adb shell "setprop persist.sys.locale es-ES && stop && start"

# Capturar:
adb exec-out screencap -p > ~/Desktop/hk_01_home_es.png

# Para mockups con frame:
# - https://shotbot.app/ (web, gratis)
# - https://studio.app-mockup.com/ (web, gratis)
# - figma + plantillas Pixel 8 / iPhone 15
```

## Nombrado y organización

```
store/
  screenshots/
    ios_67/
      en/
        01_home.png
        02_items.png
        03_item_detail.png
        04_documents.png
        05_notification.png
        06_paywall.png
      es/
        01_home.png ...
    ios_65/...
    android_phone/...
    android_tablet/...
  framed/                  # mismos archivos con device frame + caption (subset para preview)
```

## Checklist de captura

Por cada device × idioma (6 capturas):

- [ ] Status bar a `09:41` / `9:41`, batería 100%, Wi-Fi full
- [ ] Tema CLARO forzado (paywall comparativa luce mejor en claro)
- [ ] Sin overlays de debug (`MaterialApp.debugShowCheckedModeBanner: false` ya está)
- [ ] Sin scroll cortado — encuadre exacto del card hero
- [ ] No texto truncado (`...`) en cards
- [ ] Fotos demo nítidas (no placeholders rotos)
- [ ] Para captura 5 (notification): poner emulador en hora `09:41`, disparar notificación local de prueba, capturar lock screen

## Notification mockup (captura 5)

iOS no permite capturar lock screen real desde simulator de forma trivial. Alternativas:

1. **Compose en Figma** sobre un wallpaper iOS oficial + componente de notificación SF Pro.
2. **Mockuphone** tiene plantilla iPhone Lock con caja editable.
3. **Real device:** programar notificación inmediata desde la app (`flutter_local_notifications` con `DateTime.now().add(Duration(seconds: 5))`), bloquear el device, capturar screen.

Recomendación: Figma con assets de iOS HIG → consistente entre EN y ES.

## Validación pre-submit

- [ ] Apple: comprobar tamaño exacto (1290×2796 sin device frame, o el size estándar con frame mockup). Aspect ratio importa.
- [ ] Google Play: PNG/JPEG, ≤8MB, 320–3840 px en ambos lados, aspect ratio 16:9 o 9:16.
- [ ] Captions traducidas y revisadas por hablante nativo (especialmente EN si tu primera lengua es ES).
- [ ] Sin emojis en algunos screenshots si los stores los marcan como engaging-content (Apple lo permite, Google también).

## Estimación de tiempo

- Seed demo data: 30–60 min (opción B/C)
- Captura raw (4 devices × 2 idiomas × 6): 1.5–2 h
- Framing + captions: 1–2 h (Figma) o 30 min (shotbot)
- Total realista: **media jornada (~4–6 h)** para set completo.
