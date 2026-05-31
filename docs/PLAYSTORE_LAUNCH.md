# HouseKeep — Estado de lanzamiento Play Store + RevenueCat

_Última actualización: 2026-05-31_

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
| Versión actual | `1.0.0+2` (versionName 1.0.0, versionCode 2) |
| Cuenta desarrollador Play | David Rubio Mota (cuenta personal, ID 6648310945366824901) |
| Email soporte | darumo092@gmail.com |
| Proyecto Firebase / Google Cloud | `housekeep-8715e` |
| RevenueCat proyecto | HouseKeep |

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

> Sesión QA/ASO. Todo commiteado en la rama **`feat/store-screenshots-and-fixes`**
> (2 commits: `0d9c824` fixes de código, `c6edb9e` assets). **Aún NO mergeado a
> master.** Para integrar: `git checkout master && git merge feat/store-screenshots-and-fixes`.

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
1. **Mergear la rama** a master (comando arriba) si no se ha hecho.
2. **Subir screenshots al listing** (NO requiere build nuevo): Play Console →
   Ficha de Play Store → gráficos de teléfono → subir `final/en-US/` (idioma EN) y
   `final/es-ES/` (idioma ES). Mínimo cumplido (7 > 2).
3. **Para que los fixes lleguen a usuarios SÍ hace falta build nuevo (AAB):**
   - Subir `versionCode` 2 → 3 en `pubspec.yaml` (`version: 1.0.0+3`).
   - `flutter build appbundle --release`.
   - Subir el `.aab` al track de **prueba cerrada** en Play Console.
   - Recomendado: los bugs del saludo y del widget se ven en cada uso.
4. Pendientes menores del widget (no bloquean, ver `report.md` §3.3): `P-1`
   primer evento truncado en el widget; `P-2` falta `values-en/widget_strings.xml`.

## PENDIENTE (para publicar en producción)

1. **Ficha Play Store** (Store listing) — ver `STORE_METADATA.md`:
   - Descripción corta (máx 80 chars)
   - Descripción larga (máx 4000 chars)
   - Feature graphic 1024×500
   - Screenshots de teléfono — ✅ **HECHO** (7 EN + 7 ES en
     `store/screenshots/android/final/`; ver sección "Avances 2026-05-31 (parte 2)")
   - Icono 512×512
   - (ES + EN)
2. **Data safety** (formulario datos): declarar fotos (image_picker),
   notificaciones, Firebase Analytics/Crashlytics, y **AD_ID** (firebase_analytics
   inyecta permiso de publicidad). Valorar quitar analytics si no se quiere.
3. **Content rating** (cuestionario IARC).
4. **App content / Target audience** (apartados obligatorios).
5. **Prueba cerrada**: 12 testers que acepten + 14 días mínimo (obligatorio para
   cuentas personales nuevas antes de poder solicitar producción).
6. **Solicitar acceso a producción** → revisión → publicar.

### Notas / decisiones tomadas
- Monetización: **pago único Lifetime 4,99 €** (no suscripción), por ser app
  local-first sin coste recurrente y mejor para reviews/primera app.
- iOS no configurado (solo Android). `revenueCatIosKey` vacío, `_kStoreUrlIos`
  placeholder.
- Privacy + terms publicados: `https://darumo92.github.io/housekeep-legal/`
  (privacy_es/en, terms_es/en).
- Se puede cancelar la compra de prueba en Play (Gestión de pedidos) para
  re-testear.
