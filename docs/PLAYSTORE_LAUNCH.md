# HouseKeep — Estado de lanzamiento Play Store + RevenueCat

_Última actualización: 2026-08-02_

Documento de seguimiento del proceso de publicación en Google Play y la
integración de compras con RevenueCat. Resume lo hecho y lo pendiente para
poder retomar en otra sesión.

Docs relacionados: `STORE_METADATA.md`, `SCREENSHOT_PLAN.md`, `ASO_STRATEGY.md`,
`PHASE_CHECKLIST.md`.

---

## Datos clave

| Dato | Valor |
|------|-------|
| Package / applicationId | `com.housekeep.app` |
| Versión actual | `1.0.0+14` (versionName 1.0.0, versionCode 14) |
| Cuenta desarrollador Play | David Rubio Mota (cuenta personal, ID 6648310945366824901) |
| Email soporte | darumo092@gmail.com |
| Proyecto Firebase / Google Cloud | `housekeep-8715e` |
| RevenueCat proyecto | HouseKeep |
| Ficha pública | https://play.google.com/store/apps/details?id=com.housekeep.app |

### Firma (upload key)
- Keystore: `/home/darumo/housekeep-upload-keystore.jks` (FUERA del repo)
- Config: `android/key.properties` (ignorado por git)
- Alias: `upload`. Contraseña en el gestor del usuario.
- Play App Signing **activado** (Google guarda la clave de firmado real).

### RevenueCat
- Public API key Android (pública, embebida en la app): `goog_fSYOYIdMiSfvUxoBshzkzGqWvAX`
  - En código: `AppConstants.revenueCatAndroidKey` (default), override por
    `--dart-define=REVENUECAT_ANDROID_KEY`.
- Entitlement que usa la app: **`housekeep_pro`** (`AppConstants.entitlementId`).
  - OJO: existe un entitlement viejo con identifier `HouseKeep Pro` (con espacio)
    que NO usa la app. El correcto es `housekeep_pro`.
- Producto Play (in-app, no consumible): **`housekeep_pro_lifetime`**
  - Purchase option ID en Play: `lifetime`
- Offering current: **`default`** → package **`$rc_lifetime`** (Lifetime) →
  producto Play `housekeep_pro_lifetime` (+ producto Test Store `lifetime`).
- Service Account: `revenuecat@housekeep-8715e.iam.gserviceaccount.com`
  - Permisos Play (cuenta): Ver datos financieros + Gestionar pedidos +
    Ver información de las aplicaciones (los 3 requeridos por RevenueCat).
  - Roles GCP: Pub/Sub Admin + Monitoring Viewer.
  - Google developer notifications (Pub/Sub) conectado.

---

## HECHO

### Limpieza pre-lanzamiento (código, commit `acd1032` y anteriores)
- Toggle debug "Simular PRO" y "Probar notificación" gateados con `kDebugMode`
  (no aparecen en release). `betaShowProToggle = false`.
- Notificaciones cambiadas de exact a **inexact alarms**; quitados permisos
  `SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM` (evita formulario Play de alarmas
  exactas).
- App label `housekeep` → `HouseKeep`.
- Comentario obsoleto de `firebase_options.dart` corregido (Firebase SÍ está
  configurado para Android/iOS).
- Paywall fallback price alineado a `4,99 €`.
- Key RevenueCat de test → key prod `goog_`. versionCode bump a 2.
- `flutter analyze`: limpio.

### Google Play Console
- App creada (`com.housekeep.app`, español, gratuita, app).
- Cuenta de comercio (Google Payments) configurada.
- Producto único `housekeep_pro_lifetime` creado y **Activo**, precio España
  **4,99 € IVA incluido** (base 4,12 € + IVA).
- AAB v1.0.0+2 subido a **Prueba interna**.
- Lista de testers `testers pago` (darumo092@gmail.com).
- License testing activado para darumo092 (compras de prueba sin cobro).

### RevenueCat
- App Play Store añadida, Service Account JSON subido y **validado**
  (inappproducts + monetization OK; subscriptions falla pero no aplica, somos
  one-time).
- Producto, entitlement `housekeep_pro` y offering `default` cableados.

### Verificado en dispositivo real (Android 10)
- Paywall muestra **4,99 €** real.
- Compra real con tarjeta de prueba (sin cobro) → entitlement `housekeep_pro`
  concedido → features PRO desbloqueadas (items/docs ilimitados, widget,
  export PDF).

---

## Avances 2026-05-31 (screenshots)

- **Toolchain Android instalado desde cero** (el Mac no tenía SDK): JDK17 +
  command-line-tools + platform-tools + emulator + system-image android-34 +
  NDK 28.2.13676358 + cmake + build-tools 36. AVD `hk_pixel` (Pixel, 1080×2400).
  Rutas en memoria del proyecto (`android-toolchain-setup`).
- **Seed de datos demo** (`lib/data/services/demo_seed_service.dart`): 5 items,
  4 mantenimientos, 3 docs con patrón verde/ámbar/rojo relativo a *hoy*, nombres
  ES/EN. UI en Ajustes → "DEBUG: Datos demo" (solo `kDebugMode`).
- **8 fotos royalty-free** (Unsplash) en `assets/images/demo/`, copiadas al dir
  de fotos de la app al sembrar. Se ven en el hero del detalle de item.
- **`tools/capture_screenshot.sh`**: status bar demo limpia (9:41, batería/wifi
  full) + `screencap`. Salidas en `store/screenshots/android_phone/<es|en>/`.
- **Fix l10n**: etiqueta de días en lista de items estaba hardcodeada en español
  (`'en Xd'`/`'hace Xd'`) → ahora `itemsWarrantyExpiryInDays/DaysAgo` en arb.
- **`debugShowCheckedModeBanner: false`** en `app.dart` (quita el ribbon DEBUG).
- **Capturas EN hechas** (emulador): 01_home, 02_items, 03_item_detail (con foto),
  04_documents. Limpias.
- **Pendiente de screenshots**:
  - Set **ES** (mecánico: cambiar idioma en Ajustes → recargar demo → mismos
    comandos de captura).
  - **06_paywall**: el emulador muestra banner rojo "Products not available"
    (RevenueCat sin billing). Capturar en **dispositivo real** con cuenta testing.
  - **05_notification** (lock screen): Figma o dispositivo real.

## Avances 2026-05-31 (parte 2): set final de screenshots + 3 fixes

> Sesión QA/ASO. Trabajo integrado en **`master`**. Commits relevantes:
> `0d9c824` fixes de código, `c6edb9e` assets, `7bb822a` tracker y `6513571`
> bump de `versionCode` a 3.

**HECHO**
- **Set final de screenshots completo, listo para subir** (1080×1920, PNG24 sin
  alfa, 9:16): **7 EN** en `store/screenshots/android/final/en-US/` + **7 ES** en
  `final/es-ES/`. Raw en `raw/en/` y `raw/es/`. Orden de venta:
  `01_dashboard_hero, 02_maintenance, 03_items, 04_documents, 05_templates,
  06_widget, 07_pro_unlock`.
- **Informe de auditoría**: `store/screenshots/android/report.md` (pantallas,
  bugs, riesgos Play, checklist, recomendaciones).
- **Compositor reproducible**: `tools/build_store_compositions.sh <en|es>` —
  lienzo de marca + UI real + titular. (Nota: las salidas viejas del script
  `capture_screenshot.sh` iban a `store/screenshots/android_phone/`; el set bueno
  es `store/screenshots/android/`.)
- **Paywall capturado** (emulador) y el banner rojo "Products not available" se
  quitó quirúrgicamente — es artefacto de dev sin billing, no existe en prod.
  Ya no hace falta dispositivo real solo para el paywall.
- **Widget capturado** (EN y ES) con "Simular PRO" (debug) activado para mostrar
  contenido; toggle dejado **OFF** al terminar.
- **3 bugs reales corregidos** (detalle en `report.md` §3):
  1. `date_calculations.addMonths` — año mal con offsets negativos (`floor`).
  2. Saludo home "Buenos días, Hola" / "Good morning, Hello" duplicado (visible a
     todo usuario) → titular = solo saludo + avatar de marca.
  3. Widget siempre en español con preferencia "Sistema" (`?? 'es'`) → resuelve
     locale real del dispositivo.
  - Test ES (`app_smoke_test.dart`) actualizado. `flutter analyze` limpio,
    **133/133 tests OK**.

**PRÓXIMOS PASOS (retomar aquí en la siguiente sesión)**
1. **Subir screenshots al listing** (NO requiere build nuevo): Play Console →
   Ficha de Play Store → gráficos de teléfono → subir `final/en-US/` (idioma EN) y
   `final/es-ES/` (idioma ES). Mínimo cumplido (7 > 2).
2. **Completar formularios obligatorios de Play Console**: Data Safety, Content
   Rating, Target audience/App content y Privacy policy.
3. **Crear release de producción** con el AAB v1.0.0+3:
   `build/app/outputs/bundle/release/app-release.aab`.
4. Pendientes menores del widget (no bloquean, ver `report.md` §3.3): `P-1`
   primer evento truncado en el widget; `P-2` falta `values-en/widget_strings.xml`.

## Avances 2026-05-31 (parte 3): build release v3

- **AAB release generado localmente** con `flutter build appbundle --release`.
- Artefacto: `build/app/outputs/bundle/release/app-release.aab`
- Versión: `1.0.0+3`
- Tamaño local: **67 MB** (`flutter` reportó 69.6 MB)
- SHA-256:
  `d530264f2d03fc6c88deb0fb63ed442469956903fc7068874293281ba9579469`
- Warning no bloqueante del build: varios plugins todavía aplican Kotlin Gradle
  Plugin directamente; Flutter avisa que futuras versiones exigirán migrar a
  Built-in Kotlin. No bloquea el AAB actual.

## Avances 2026-05-31 (parte 4): screenshots tablet reales

- **Tablet 7" real desde emulador**: 4 capturas ES + 4 EN, 1280×720, 16:9.
  - ES: `store/screenshots/android/tablet_7_real/es-ES/`
  - EN: `store/screenshots/android/tablet_7_real/en-US/`
- **Tablet 10" real desde emulador**: 4 capturas ES + 4 EN, 1920×1080, 16:9.
  - ES: `store/screenshots/android/tablet_10_real/es-ES/`
  - EN: `store/screenshots/android/tablet_10_real/en-US/`
- Pantallas incluidas por set: `01_dashboard`, `02_items`, `03_item_detail`,
  `04_documents`.
- Nota: las carpetas `tablet_7/` y `tablet_10/` previas contienen composiciones
  derivadas del set móvil. Para Play Console, usar las carpetas `_real`.

## Checklist de publicación

La publicación de producción ya está hecha. Esta lista conserva los elementos
que se completaron y la incidencia de compatibilidad queda documentada abajo.

1. **Ficha Play Store** (Store listing) — completada; ver `STORE_METADATA.md`:
   - Descripción corta (máx 80 chars)
   - Descripción larga (máx 4000 chars)
   - Feature graphic 1024×500 — ES `store/feature_graphic_1024x500_es.png`,
     EN `store/feature_graphic_1024x500_en.png`
   - Screenshots de teléfono — ✅ **HECHO** (7 EN + 7 ES en
     `store/screenshots/android/final/`; ver sección "Avances 2026-05-31 (parte 2)")
   - Screenshots tablet 7" — ✅ **HECHO** (4 EN + 4 ES en
     `store/screenshots/android/tablet_7_real/`)
   - Screenshots tablet 10" — ✅ **HECHO** (4 EN + 4 ES en
     `store/screenshots/android/tablet_10_real/`)
   - Icono 512×512 — `store/icon_512.png`
   - (ES + EN)
2. **Data safety** (formulario datos): completado; declarar fotos (image_picker),
   notificaciones, Firebase Analytics/Crashlytics, y **AD_ID** (firebase_analytics
   inyecta permiso de publicidad). Valorar quitar analytics si no se quiere.
3. **Content rating** (cuestionario IARC) — completado.
4. **App content / Target audience** — completado.
5. **Crear release de producción** con el AAB v1.0.0+14 — completado.
6. **Enviar a revisión de producción** — completado.

## Estado de producción y compatibilidad

La ficha pública ya está disponible en Google Play y muestra como última
actualización el 31 de julio de 2026. El problema pendiente es que un Xiaomi 12
Pro con Android 13 aparece como no compatible desde la ficha de producción,
aunque sí fue compatible durante las pruebas.

La build local de release se ha inspeccionado el 2 de agosto de 2026:

- AAB generado: `build/app/outputs/bundle/release/app-release.aab`.
- `versionCode`: `14`.
- `minSdkVersion`: `24`.
- `targetSdkVersion`: `36`.
- ABI `arm64-v8a` incluido.
- No hay `uses-feature` obligatorio de cámara, Bluetooth, GPS u otro hardware.

Estos valores son compatibles con el Xiaomi de la incidencia, por lo que no se
debe bajar el SDK ni añadir filtros Android sin evidencia. Revisar en Play
Console, en este orden:

1. Catálogo de dispositivos: buscar exactamente `Xiaomi 12 Pro` y consultar el
   motivo de exclusión para Production.
2. Release de Production: confirmar que el artefacto activo es el AAB y que
   incluye el `versionCode` publicado, no un APK `armeabi-v7a` aislado.
3. Países/regiones y porcentaje de rollout del release de Production.
4. Probar la URL pública con la cuenta del dispositivo después de actualizar
   Play Store y Google Play Services; la elegibilidad de Internal/Closed
   Testing no demuestra la elegibilidad del track público.

Si el catálogo no muestra exclusión, abrir incidencia en Play Console con el
número de modelo, Android 13, versión de Play Store y una captura del mensaje.

### Notas / decisiones tomadas
- Monetización: **pago único Lifetime 4,99 €** (no suscripción), por ser app
  local-first sin coste recurrente y mejor para reviews/primera app.
- Internal Testing queda como canal de QA/sandbox.
- iOS no configurado (solo Android). `revenueCatIosKey` vacío, `_kStoreUrlIos`
  placeholder.
- Privacy + terms publicados: `https://darumo92.github.io/housekeep-legal/`
  (privacy_es/en, terms_es/en).
- Se puede cancelar la compra de prueba en Play (Gestión de pedidos) para
  re-testear.
