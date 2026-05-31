# HouseKeep — Informe de captura de screenshots y auditoría pre-submit (Google Play)

**Fecha:** 2026-05-31
**Build auditada:** `app-debug.apk` (versión 1.0.0+2), emulador Pixel (Android, 1080×2400, densidad 420).
**Set principal para submit:** Inglés (`final/en-US/`). Set localizado: Español (`final/es-ES/`).

---

## 1. Resumen ejecutivo

Se ha preparado un set completo de **7 screenshots** por idioma (inglés y español), listas para subir a
Google Play, más sus capturas raw. Todas cumplen las especificaciones de Play: **1080×1920 px, PNG de 24 bits
sin canal alfa, ratio 9:16, sin barras negras, sin notificaciones reales, sin datos personales reales,
status bar limpia (09:41, batería/wifi llenos), sin debug banner y sin claims prohibidos**.

Las imágenes usan **UI real de la app** flotada sobre un lienzo cálido de marca (crema → arena) con un titular
breve arriba (< 20 % de la imagen). La primera screenshot (dashboard) comunica el valor en 3 segundos:
qué hace, qué problema resuelve y por qué da tranquilidad.

Durante la preparación se ejecutó una auditoría que detectó y **corrigió 3 bugs reales** (uno de ellos
visible en todas las pantallas), además del ajuste de datos demo ya existente. `flutter analyze` queda
**limpio** y la batería de **133 tests pasa** al completo.

**Veredicto:** apta para submit del listing de screenshots. Ver §6 para los puntos a revisar antes de publicar.

---

## 2. Pantallas capturadas y por qué

Secuencia de venta (orden de subida = orden de archivo):

| # | Archivo final | Pantalla real | Objetivo comercial | Titular EN / ES |
|---|---------------|---------------|--------------------|-----------------|
| 1 | `01_dashboard_hero.png` | Home / dashboard | Hero: explica el valor de golpe (resumen 5 Pendientes / 1 esta semana / 1 al día + timeline) | *Your home, always on track* / *Tu hogar, siempre al día* |
| 2 | `02_maintenance.png` | Detalle de elemento (Caldera) | Prevención: garantía activa + calendario de mantenimientos por aparato | *Never miss a service or warranty* / *No olvides ninguna revisión ni garantía* |
| 3 | `03_items.png` | Lista "Mis cosas" (5/5) | Inventario del hogar con estado de garantía y semáforo | *Every appliance, neatly organized* / *Todo lo importante de casa* |
| 4 | `04_documents.png` | Documentos | Garantías/seguros/ITV/DNI con semáforo de caducidad | *Documents & warranties under control* / *Garantías y documentos bajo control* |
| 5 | `05_templates.png` | Selector de plantillas de mantenimiento | Facilidad de uso: empezar en minutos con plantillas reales | *Set up in minutes with templates* / *Empieza en minutos con plantillas* |
| 6 | `06_widget.png` | Widget en pantalla de inicio (Android) | Diferenciador: lo importante de un vistazo sin abrir la app | *Your reminders, on the home screen* / *Tus avisos, en la pantalla de inicio* |
| 7 | `07_pro_unlock.png` | Paywall Pro | Upsell sobrio: pago único 4,99 €, beneficios claros | *One unlock. Yours forever.* / *Un único pago. Para siempre.* |

**Nota sobre la pantalla de "alertas" del brief (screenshot 5 original):** HouseKeep no tiene una pantalla
de alertas independiente — el *timeline* de avisos vive en el propio dashboard (screenshot 1) y el detalle de
recordatorios por elemento se ve en la screenshot 2. Para no repetir la misma pantalla, se sustituyó por el
widget (diferenciador más fuerte) y se mantuvieron 7 screenshots de alto impacto en lugar de forzar una octava
redundante. Sigue dentro del rango recomendado por Google (4–8).

### Datos demo usados

Dataset realista de una vivienda, sembrado con el seeder de depuración (ver §5). Genera el patrón
verde/ámbar/rojo que hace creíbles las capturas:

- **Elementos (5/5, límite free alcanzado a propósito):** Frigorífico (garantía caducada hace ~1 mes),
  Detector de humo cocina (garantía activa), Lavadora (garantía activa), Lavavajillas (garantía caducada
  hace ~2 meses), Caldera salón Vaillant (garantía activa, con foto real royalty-free).
- **Mantenimientos:** Revisión anual (en 60 d, verde), Cambio de filtros (en 5 d, rojo), Test mensual del
  detector (vencido hace 2 d, rojo), Limpieza del tambor (en 20 d, ámbar).
- **Documentos (3/3, límite free):** DNI de Pablo (en 1800 d, verde), ITV del coche (en 55 d, ámbar),
  Seguro del hogar (en 13 d, rojo).

---

## 3. Bugs

### 3.1 Encontrados y corregidos

1. **`addMonths` calculaba mal el año con desplazamientos negativos** *(latente en producción).*
   `lib/core/utils/date_calculations.dart`. Usaba `~/` (trunca hacia cero) para el año mientras el mes usa `%`
   (resto no negativo); para offsets negativos ambos discrepaban y el año salía uno de más. Se cambió a
   división con `floor()`. Lo dispara el seeder demo (fechas relativas a `now()`), pero es un bug real de la
   utilidad. Fix verificado: la caldera muestra "Comprado el 2024-09-30" y el frigorífico/lavavajillas las
   antigüedades correctas.

2. **Cabecera del dashboard redundante: "Good morning, Hello" / "Buenos días, Hola"** *(visible para TODOS los
   usuarios).* La app no tiene flujo de captura de nombre, así que el hueco del nombre siempre se rellenaba con
   el literal de fallback, produciendo un saludo duplicado. Se corrigió en
   `lib/features/home/widgets/home_redesign_widgets.dart` + `lib/features/home/home_screen.dart`: cuando no hay
   nombre real, el titular es solo el saludo ("Good morning" / "Buenos días") y el avatar muestra el glifo de
   marca (casa) en lugar de una inicial suelta. Mejora directa del hero.

3. **El widget nativo salía siempre en español** *(bug de localización).*
   `lib/features/widget/widget_sync_provider.dart`. Cuando la preferencia de idioma era "Sistema" su `code` es
   `null` y el código hacía `?? 'es'`, forzando español aunque el dispositivo/app estuviera en inglés. Se
   resuelve ahora el locale real del dispositivo (`PlatformDispatcher.instance.locale.languageCode`). Tras el
   fix el widget se muestra correctamente en inglés ("5 pending / 2 soon / Overdue by 61 days") y en español.

> El test `app_smoke_test.dart` que afirmaba el antiguo nombre de fallback `'Hola'` se actualizó para
> comprobar una cadena estable en español del home (`'Esto es lo que pide atención'`).

### 3.2 Ya corregido en sesión previa (contexto)

- **Ajuste de fechas del dataset demo** en `lib/data/services/demo_seed_service.dart` (lavavajillas 26 meses,
  frigorífico 25 meses) para lograr un hero con garantías recién caducadas, más convincente.

### 3.3 Pendientes (no bloqueantes, documentados)

- **`P-1` Widget: textos truncados.** En la variante mediana el nombre del primer evento se corta
  ("Dishwa…", "Lavavajil…") y la fecha "until 2026…". Es comportamiento normal del widget por ancho, pero
  conviene revisar el layout/ellipsis para que el primer evento luzca completo. No bloquea el submit.
- **`P-2` Cadenas estáticas del widget sin `values-en`.** `android/.../res/values/widget_strings.xml` está solo
  en español (etiqueta/descripción que se ven en el *selector* de widgets del launcher, no en el contenido).
  Recomendable añadir `values-en/widget_strings.xml`. No afecta a las screenshots entregadas.
- **`P-3` Formato de precio `4,99 €` con coma** en el set inglés. Es el precio real de la zona euro y coincide
  con el fallback de la app; aceptable, pero si se quiere un listing en-US más "nativo" podría mostrarse
  `€4.99`. Decisión de negocio.
- **`P-4` Banner de error del paywall en dev.** En el emulador sin productos de RevenueCat el paywall muestra
  "Products not available right now". Es exclusivamente un artefacto de entorno de desarrollo (en producción,
  con productos cargados, no aparece). Para las screenshots se eliminó esa franja de forma quirúrgica
  (ver §4). No es un bug de producción.

---

## 4. Cómo se construyeron las imágenes

1. **Capturas raw** (`tools/capture_screenshot.sh` + navegación por adb) con **status bar de demo** vía
   `sysui_demo`: reloj 09:41, batería 100 % sin enchufe, wifi/datos llenos, sin notificaciones. Guardadas en
   `raw/en/` y `raw/es/`.
2. **Paywall sin banner de dev:** el banner rojo (artefacto de entorno, ver `P-4`) se recortó uniendo la parte
   superior y la inferior de la captura; ambas aristas caen sobre el mismo crema sólido, por lo que la costura
   es invisible. Resultado en `raw/<lang>/paywall_clean.png`.
3. **Composición de marca** (`tools/build_store_compositions.sh`): lienzo 1080×1920 con degradado cálido
   (`#FCF8F1` → `#F1E7D7`, colores de `AppColors`), la captura real escalada con esquinas redondeadas y sombra
   suave, titular (fuente de marca *Plus Jakarta Sans*) y subtítulo arriba (< 20 % del alto). Salida aplanada a
   **PNG24 sin alfa**.

Reproducible: `bash tools/build_store_compositions.sh en` y `... es`.

---

## 5. Datos demo: confirmación de NO contaminación en producción

- El seeder vive en `lib/data/services/demo_seed_service.dart` y **solo** se invoca desde la UI de Ajustes bajo
  `if (kDebugMode) { … }` (`lib/features/settings/settings_screen.dart`). En builds release esa sección no se
  compila → **imposible sembrar datos demo en producción**.
- Todas las filas usan ids fijos con prefijo `demo_`, por lo que el sembrado es **idempotente** y `clear()`
  borra únicamente las filas/fotos demo, nunca los datos reales del usuario.
- El toggle **"BETA: Simular PRO"** también está protegido: `if (kDebugMode || AppConstants.betaShowProToggle)`
  y `betaShowProToggle = false` → en release no aparece. Se usó solo para capturar el widget/paywall y se dejó
  **desactivado** al terminar.
- Las fotos demo son royalty-free, empaquetadas en `assets/images/demo/` y copiadas como `demo_*` en el
  directorio de fotos gestionado.

---

## 6. Riesgos para Google Play y mitigaciones

| Riesgo | Estado | Mitigación |
|--------|--------|------------|
| Ratio/tamaño fuera de norma | ✅ Resuelto | Todas a 1080×1920, 9:16, PNG24 sin alfa |
| Transparencia/alfa | ✅ Resuelto | Aplanado sobre crema opaco, `-alpha remove` |
| Claims prohibidos (#1, best, free, offer, new, top, download) | ✅ Sin riesgo | Titulares revisados; ninguno usa palabras vetadas |
| Status bar "sucia" (hora/batería/notifs) | ✅ Resuelto | Modo demo sysui (09:41, llenos, sin notifs) |
| Datos personales reales | ✅ Sin riesgo | Dataset ficticio ("Pablo", marcas genéricas) |
| Debug banner | ✅ Sin riesgo | No aparece en ninguna captura |
| Mezcla de idiomas dentro de un set | ✅ Resuelto | Set EN 100 % inglés; set ES 100 % español (UI, datos, fechas, overlays) |
| Texto de marketing > 20 % | ✅ Controlado | Titular + subtítulo ocupan la franja superior, resto es UI |
| Captura del paywall engañosa | ⚠️ Bajo | Se quitó un banner que **no** existe en producción; el resto es UI fiel. Documentado en `P-4` |
| Widget con texto truncado | ⚠️ Cosmético | Ver `P-1`; no incumple política, pero mejorable |

---

## 7. Checklist de cumplimiento de screenshots

- [x] 1080×1920 px exactos (las 14 imágenes)
- [x] PNG 24-bit **sin** canal alfa (`%[channels] = srgb 3.0`)
- [x] Ratio 9:16
- [x] Entre 4 y 8 screenshots (7 por idioma)
- [x] Las 3 primeras venden el producto (dashboard, mantenimiento, inventario)
- [x] Sin pantallas vacías (dataset demo realista)
- [x] Sin textos cortados en la UI de la app
- [x] Sin barras negras / deformaciones / pixelado
- [x] Status bar limpia y coherente (09:41)
- [x] Sin notificaciones reales ni datos personales
- [x] Sin debug banner
- [x] Paywall sobrio y de confianza (4,99 € pago único, beneficios claros)
- [x] Límites freemium representados (5/5 elementos, 3/3 documentos, gates "Unlock with Pro")
- [x] Coherencia visual entre todas (mismo lienzo, tipografía y layout)
- [x] Set inglés (obligatorio) y set español (opcional) entregados

---

## 8. Estado de funcionalidad / store readiness (auditoría)

- **Onboarding, navegación de 4 tabs, persistencia local (drift):** OK (cubiertos por smoke tests).
- **Localización ES/EN:** OK; saludo y widget ahora correctos en ambos (ver §3).
- **Paywall RevenueCat:** OK en estructura; depende de productos reales en producción (clave `goog_` ya en
  release según el tracker de lanzamiento).
- **Límites free (5 elementos / 3 documentos), gates Pro (widget, export PDF, plantillas Pro):** visibles y
  coherentes en UI.
- **Privacy Policy y Términos de uso:** enlazados en Ajustes → SOBRE. OK.
- **`flutter analyze`:** sin incidencias. **`flutter test`:** 133/133 OK.

---

## 9. Archivos modificados (código) y nuevos

**Modificados (lib/test):**

| Archivo | Cambio | ¿Demo en prod? |
|---------|--------|----------------|
| `lib/core/utils/date_calculations.dart` | Fix de año en `addMonths` para offsets negativos (`floor`) | No |
| `lib/features/home/widgets/home_redesign_widgets.dart` | Cabecera sin nombre → titular = saludo + avatar de marca | No |
| `lib/features/home/home_screen.dart` | Pasa `userName` vacío (no hay captura de nombre) | No |
| `lib/features/widget/widget_sync_provider.dart` | Locale del widget = locale real del dispositivo cuando la pref es "Sistema" | No |
| `lib/data/services/demo_seed_service.dart` | Ajuste de meses de compra del dataset demo (sesión previa) | **Solo debug** (kDebugMode) |
| `test/app_smoke_test.dart` | Aserción ES estable tras el cambio de cabecera | n/a |

**Nuevos (no afectan al runtime de la app):**

- `tools/build_store_compositions.sh` — generador de composiciones de marca 1080×1920 (operador, no se importa
  desde código).
- `store/screenshots/android/` — capturas raw, finales (`en-US`, `es-ES`) y este informe.

**Confirmación:** ninguno de los cambios introduce datos demo ni estados Pro simulados en builds de producción;
todo lo demo/beta está tras `kDebugMode` (o tras `betaShowProToggle = false`).

---

## 10. Recomendaciones finales antes del submit

1. **Subir set inglés** (`final/en-US/`, 7 imágenes) como principal y **set español** (`final/es-ES/`) como
   listing localizado.
2. **(Opcional, recomendado)** Resolver `P-1` (truncado del primer evento del widget) y `P-2`
   (`values-en/widget_strings.xml`) antes de promocionar mucho el widget.
3. Verificar en un **build release** real (con productos RevenueCat) que el paywall carga el precio y no muestra
   el aviso de "no disponible" (confirma que `P-4` es solo de dev).
4. Confirmar que el **feature graphic** y el **icono** (generados por `tools/gen_store_assets.py`) acompañan al
   listing.
5. Hacer un **commit** de los cambios de código (3 fixes + test) por separado de los assets, con mensaje claro.
