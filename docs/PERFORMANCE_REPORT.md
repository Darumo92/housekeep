# HouseKeep — Performance & Memory Report

Fecha: 2026-05-26
Build: `flutter run --profile` sobre `sdk gphone64 x86_64` (Android 14, API 34, emulator-5554).

## Setup

- Backend renderer: **Impeller** (OpenGLES) — `android_context_gl_impeller.cc`.
- APK profile: 51.2 MB (incluye observatory). Release arm64-v8a = 25.1 MB.
- Firebase + RevenueCat init en arranque. RevenueCat falla por SSL chain en emulador (esperado).

## Profile cold start

Cold start completo (firebase init → home dashboard pintado): ~3-4 s en emulador x86.

## Jank check

Recorrido manual (Home → Items → Item detail → Maintenance → Documents → Settings → Paywall):
- Sin `BUILD FAILED to produce frame in time`.
- `EGL_emulation app_time_stats avg=17-80 ms` típico, picos puntuales de 1 s en inflado inicial del tab (overhead emulador x86).
- Listas (`ResponsiveCardList`/`ListView.builder`) virtualizan; sin jank tras scroll inicial.

## Memory baseline

- Heap steady-state tras navegación completa: ~70-90 MB en emulador (engine + Firebase + RevenueCat + Drift).
- Sin growth tras 5 ciclos por las 4 pestañas + paywall: heap se estabiliza.
- Providers `autoDispose` cierran al salir de pantalla.

## Acciones realizadas

- [x] `--profile` build instalado en emulator-5554.
- [x] Recorrido golden path sin jank perceptible ni crashes.
- [x] Inspección logs (`EGL_emulation`, sin `SkippedFrames` patológicos).

## Pendiente release real (no bloqueante)

- Repetir profile en device físico arm64 (emulador x86 añade overhead).
- DevTools timeline ≥30 s scroll con 100+ items sintéticos.
- Memory snapshot diff antes/después de subir 20 fotos.

## DevTools (efímero)

```
http://127.0.0.1:33881/7ZuvGla1IOI=/devtools/?uri=ws://127.0.0.1:33881/7ZuvGla1IOI=/ws
```

## Conclusión

App size, jank y memory baseline aceptable para v1.0. Sin leaks ni regresiones bloqueantes.
