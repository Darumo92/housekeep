# Fase 10 — Widget de pantalla de inicio

> **Esfuerzo estimado:** 2-3 días. **Depende de:** Fases 1, 2 (tokens + componentes).
> **Pantallas afectadas:** Android `app_widget` + (opcional) iOS WidgetKit.
> **Referencia visual:** prototipo → screen `widget`.

## Objetivo

Implementar el widget de pantalla de inicio prometido en el paywall como beneficio Pro. Ofrecemos **3 tamaños**:

1. **4×2 (hero)** — el destacado: branding + chips de "pendientes" y "esta semana" + siguiente evento con icono y status pill + 2 micro-rows con los siguientes.
2. **2×2 (contador)** — número grande coloreado (`danger` si hay pendientes, `ok` si todo al día) + label corta + opcional "X esta semana" abajo.
3. **2×2 (próximo)** — el siguiente evento estilo card: icono + label "PRÓXIMO" + título grande + status pill.

**Acceso:** Free puede ver el widget en modo demo (sample data + watermark "Pro"). Solo Pro lo muestra con datos reales. Esto sirve como gancho viral.

## Stack técnico recomendado

Para Flutter + Android widgets, el camino más estable es:

```yaml
# pubspec.yaml
dependencies:
  home_widget: ^0.7.0  # o la última versión estable
```

`home_widget` provee:
- Pasar datos desde Flutter → SharedPreferences nativos.
- Renderizar el widget con XML nativo Android (`RemoteViews`).
- Tap en el widget → abre la app en una ruta concreta.

**No** intentes renderizar Flutter directamente en el widget — Android widgets son XML estático con bindings, no canvas Flutter.

## Estructura de archivos

```
android/app/src/main/
├── kotlin/.../
│   ├── HouseKeepWidgetSmall.kt   ← 2×2 contador
│   ├── HouseKeepWidgetNext.kt    ← 2×2 próximo
│   └── HouseKeepWidgetHero.kt    ← 4×2 hero
├── res/
│   ├── layout/
│   │   ├── widget_small.xml
│   │   ├── widget_next.xml
│   │   └── widget_hero.xml
│   ├── xml/
│   │   ├── widget_small_info.xml ← AppWidgetProviderInfo
│   │   ├── widget_next_info.xml
│   │   └── widget_hero_info.xml
│   ├── drawable/
│   │   ├── widget_bg.xml          ← shape con corner radius 28
│   │   ├── ic_logo_small.xml      ← logo de HouseKeep
│   │   ├── chip_danger.xml        ← shape rojo soft
│   │   ├── chip_warn.xml
│   │   ├── chip_ok.xml
│   │   └── (icons de categorías)
│   └── values/
│       └── colors_widget.xml      ← exporta tokens de Cozy
```

Y en Flutter:
```
lib/features/widget/
├── widget_data_service.dart      ← lee items+docs, escribe a SharedPreferences
└── widget_settings_screen.dart   ← (opcional) preview del widget en la app
```

## XML del layout (Android)

### `widget_hero.xml` (4×2)

```xml
<LinearLayout
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:background="@drawable/widget_bg"
    android:padding="14dp">

    <!-- Top row: branding + counts -->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="horizontal"
        android:gravity="center_vertical">

        <ImageView
            android:layout_width="22dp"
            android:layout_height="22dp"
            android:background="@drawable/logo_tile_bg"
            android:src="@drawable/ic_home"
            android:padding="4dp"
            android:tint="@color/widget_on_primary"/>

        <TextView
            android:id="@+id/brand"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:layout_marginStart="8dp"
            android:text="HouseKeep"
            android:textSize="12.5sp"
            android:textStyle="bold"
            android:textColor="@color/widget_text"/>

        <TextView
            android:id="@+id/due_chip"
            android:background="@drawable/chip_danger"
            android:paddingHorizontal="8dp"
            android:paddingVertical="2dp"
            android:textSize="10.5sp"
            android:textStyle="bold"
            android:textColor="@color/widget_danger"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"/>

        <TextView
            android:id="@+id/soon_chip"
            android:background="@drawable/chip_warn"
            android:layout_marginStart="6dp"
            android:paddingHorizontal="8dp"
            android:paddingVertical="2dp"
            android:textSize="10.5sp"
            android:textStyle="bold"
            android:textColor="@color/widget_warn"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"/>
    </LinearLayout>

    <!-- Hero next item -->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginTop="10dp"
        android:orientation="horizontal"
        android:gravity="center_vertical">

        <ImageView
            android:id="@+id/next_icon"
            android:layout_width="44dp"
            android:layout_height="44dp"
            android:background="@drawable/cat_tile_bg"
            android:padding="11dp"/>

        <LinearLayout
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:layout_marginStart="12dp"
            android:orientation="vertical">
            <TextView
                android:id="@+id/next_title"
                android:textSize="14sp"
                android:textStyle="bold"
                android:textColor="@color/widget_text"
                android:singleLine="true"
                android:ellipsize="end"
                android:layout_width="match_parent"
                android:layout_height="wrap_content"/>
            <TextView
                android:id="@+id/next_sub"
                android:textSize="11.5sp"
                android:textColor="@color/widget_text_muted"
                android:singleLine="true"
                android:ellipsize="end"
                android:layout_marginTop="1dp"
                android:layout_width="match_parent"
                android:layout_height="wrap_content"/>
        </LinearLayout>

        <TextView
            android:id="@+id/next_pill"
            android:background="@drawable/pill_status"
            android:paddingHorizontal="9dp"
            android:paddingVertical="4dp"
            android:textSize="11.5sp"
            android:textStyle="bold"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"/>
    </LinearLayout>

    <!-- Divider + 2 micro rows -->
    <View
        android:layout_width="match_parent"
        android:layout_height="1dp"
        android:layout_marginTop="8dp"
        android:background="@color/widget_border"/>

    <LinearLayout
        android:id="@+id/micro_row_1"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginTop="6dp"
        android:orientation="horizontal"
        android:gravity="center_vertical">
        <!-- dot 6dp coloreado, title, days mono -->
    </LinearLayout>

    <LinearLayout
        android:id="@+id/micro_row_2"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginTop="4dp"
        android:orientation="horizontal"
        android:gravity="center_vertical">
    </LinearLayout>
</LinearLayout>
```

Repite el patrón para `widget_small.xml` (130dp alto, sin micro rows) y `widget_next.xml` (130dp, layout vertical con icon top + título grande + pill abajo).

### `widget_bg.xml`

```xml
<shape xmlns:android="http://schemas.android.com/apk/res/android"
       android:shape="rectangle">
    <solid android:color="@color/widget_surface"/>
    <corners android:radius="28dp"/>
</shape>
```

### `colors_widget.xml`

Mapea los tokens de la dirección Cozy. Si quieres modo dynamic-color (Material You), usa `@android:color/system_neutral1_50` etc., pero te recomiendo empezar con los hex fijos:

```xml
<resources>
    <color name="widget_bg">#F6F1E9</color>
    <color name="widget_surface">#FFFFFF</color>
    <color name="widget_text">#1F2624</color>
    <color name="widget_text_muted">#6B7270</color>
    <color name="widget_primary">#2E7D6F</color>
    <color name="widget_primary_soft">#DBEAE5</color>
    <color name="widget_on_primary">#FFFFFF</color>
    <color name="widget_accent">#E0913A</color>
    <color name="widget_danger">#C8513C</color>
    <color name="widget_danger_soft">#F6DAD0</color>
    <color name="widget_warn">#D4A017</color>
    <color name="widget_warn_soft">#FCEFC8</color>
    <color name="widget_ok">#3F9C5C</color>
    <color name="widget_ok_soft">#DCEFD6</color>
    <color name="widget_border">#1A2E7D6F</color>
</resources>
```

## Provider (Kotlin)

### `HouseKeepWidgetHero.kt`

```kotlin
class HouseKeepWidgetHero : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_hero)
            val prefs = HomeWidgetPlugin.getData(context)

            // Counts
            val due = prefs.getInt("widget_due_count", 0)
            val soon = prefs.getInt("widget_soon_count", 0)
            views.setTextViewText(R.id.due_chip,
                if (due == 0) "" else "$due ${if (due == 1) "pendiente" else "pendientes"}")
            views.setViewVisibility(R.id.due_chip,
                if (due == 0) View.GONE else View.VISIBLE)
            views.setTextViewText(R.id.soon_chip,
                if (soon == 0) "" else "$soon pronto")
            views.setViewVisibility(R.id.soon_chip,
                if (soon == 0) View.GONE else View.VISIBLE)

            // Next item
            val nextTitle = prefs.getString("widget_next_title", "Sin eventos próximos")
            val nextSub = prefs.getString("widget_next_sub", "Añade tu primera cosa")
            val nextDays = prefs.getString("widget_next_days_label", "—")
            val nextStatus = prefs.getString("widget_next_status", "ok")
            val nextCat = prefs.getString("widget_next_cat", "general")
            views.setTextViewText(R.id.next_title, nextTitle)
            views.setTextViewText(R.id.next_sub, nextSub)
            views.setTextViewText(R.id.next_pill, nextDays)
            views.setInt(R.id.next_pill, "setBackgroundResource", pillBgFor(nextStatus))
            views.setTextColor(R.id.next_pill, pillFgFor(context, nextStatus))
            views.setImageViewResource(R.id.next_icon, iconForCategory(nextCat))

            // Micro rows (similar pattern, indices 0 and 1 of widget_more_*)
            renderMicroRow(views, prefs, R.id.micro_row_1, 0)
            renderMicroRow(views, prefs, R.id.micro_row_2, 1)

            // Click → open app
            val intent = Intent(context, MainActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                data = Uri.parse("housekeep://home")
            }
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )
            views.setOnClickPendingIntent(R.id.root, pendingIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
```

(Helper funcs `pillBgFor`, `pillFgFor`, `iconForCategory` mapean strings a `R.drawable.*`.)

### `widget_hero_info.xml`

```xml
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:minWidth="250dp"
    android:minHeight="110dp"
    android:targetCellWidth="4"
    android:targetCellHeight="2"
    android:updatePeriodMillis="1800000"
    android:initialLayout="@layout/widget_hero"
    android:resizeMode="horizontal|vertical"
    android:widgetCategory="home_screen"
    android:previewImage="@drawable/widget_hero_preview"
    android:description="@string/widget_hero_description"/>
```

## Lado Flutter

### `widget_data_service.dart`

```dart
import 'package:home_widget/home_widget.dart';

class WidgetDataService {
  static const _appGroupId = 'group.app.housekeep';
  static const _provider = 'HouseKeepWidgetHero';

  static Future<void> sync(WidgetSnapshot snapshot) async {
    await HomeWidget.setAppGroupId(_appGroupId);

    await HomeWidget.saveWidgetData('widget_due_count', snapshot.dueCount);
    await HomeWidget.saveWidgetData('widget_soon_count', snapshot.soonCount);

    final next = snapshot.next;
    if (next != null) {
      await HomeWidget.saveWidgetData('widget_next_title', next.title);
      await HomeWidget.saveWidgetData('widget_next_sub', next.sub);
      await HomeWidget.saveWidgetData('widget_next_days_label', next.daysLabel);
      await HomeWidget.saveWidgetData('widget_next_status', next.status.name);
      await HomeWidget.saveWidgetData('widget_next_cat', next.category);
    }

    // More rows for hero widget
    for (var i = 0; i < snapshot.more.length; i++) {
      final r = snapshot.more[i];
      await HomeWidget.saveWidgetData('widget_more_${i}_title', r.title);
      await HomeWidget.saveWidgetData('widget_more_${i}_days', r.daysLabel);
      await HomeWidget.saveWidgetData('widget_more_${i}_status', r.status.name);
    }

    await HomeWidget.updateWidget(
      androidName: 'HouseKeepWidgetHero',
      qualifiedAndroidName: 'app.housekeep.HouseKeepWidgetHero',
    );
    await HomeWidget.updateWidget(androidName: 'HouseKeepWidgetSmall');
    await HomeWidget.updateWidget(androidName: 'HouseKeepWidgetNext');
  }
}

class WidgetSnapshot {
  final int dueCount, soonCount;
  final WidgetEvent? next;
  final List<WidgetEvent> more; // hasta 2
  WidgetSnapshot({required this.dueCount, required this.soonCount, this.next, required this.more});
}
```

### Cuándo sincronizar

Llama `WidgetDataService.sync(...)` desde un Riverpod listener en cada cambio relevante:

```dart
ref.listen(upcomingProvider, (prev, next) {
  next.whenData((data) {
    WidgetDataService.sync(WidgetSnapshot(
      dueCount: data.where((e) => e.daysUntil < 0 || e.daysUntil == 0).length,
      soonCount: data.where((e) => e.daysUntil > 0 && e.daysUntil <= 7).length,
      next: data.isEmpty ? null : WidgetEvent.fromUpcoming(data.first),
      more: data.skip(1).take(2).map(WidgetEvent.fromUpcoming).toList(),
    ));
  });
});
```

También al arrancar la app, al volver del background (`AppLifecycleState.resumed`) y tras marcar mantenimientos hechos.

## Gate Pro

En `WidgetDataService.sync`, comprueba el plan:

```dart
final isPro = ref.read(isProProvider);
if (!isPro) {
  // Modo demo
  await HomeWidget.saveWidgetData('widget_due_count', 2);
  await HomeWidget.saveWidgetData('widget_soon_count', 1);
  await HomeWidget.saveWidgetData('widget_next_title', 'Revisión caldera');
  await HomeWidget.saveWidgetData('widget_next_sub', 'Demo · Pásate a Pro');
  await HomeWidget.saveWidgetData('widget_next_status', 'overdue');
  await HomeWidget.saveWidgetData('widget_next_days_label', 'demo');
  // ...
} else {
  // Datos reales
}
```

Al tap en el widget demo, deep link a `/paywall?source=widget` en lugar de `/`.

## Criterios de aceptación

- [ ] 3 tamaños de widget instalables desde el widget picker de Android.
- [ ] Cada tamaño muestra los datos correctos extraídos de la DB.
- [ ] Tap en el widget abre la app:
  - Pro: en home.
  - Free: en paywall con tracking source=widget.
- [ ] Auto-update cada 30 min (Android limita a 30 min mínimo) y al marcar mantenimientos hechos.
- [ ] Corner radius 28dp visible.
- [ ] Modo dark: opcional para MVP. Si lo añades, usa `@android:color/system_neutral1_900` en lugar de hex y filtra por `Configuration.UI_MODE_NIGHT_YES`.
- [ ] Previews (`@drawable/widget_*_preview`) generadas — toma capturas reales del widget instalado.
- [ ] Probado en Android 12+ (los corner radius y forma del widget tienen comportamiento distinto pre/post 12).

## iOS (opcional, post-MVP)

iOS WidgetKit es **totalmente distinto** — usa SwiftUI views nativos. No se puede compartir el código Android. Si quieres soporte:

1. Crea un Widget Extension en Xcode.
2. Comparte datos via `WidgetCenter.shared.reloadAllTimelines()` + App Group.
3. Reimplementa los 3 layouts en SwiftUI.

Estima otros 2-3 días para iOS. Para la primera versión Pro, ship solo Android — la mayoría del mercado HouseKeep es Android.

## Strings nuevos (ARB)

```json
"widget_hero_description": "Próximos mantenimientos y avisos",
"widget_small_description": "Cosas pendientes",
"widget_next_description": "Próximo evento",
"widget_demo_label": "Demo · Pásate a Pro",
"widget_empty_title": "Sin eventos próximos",
"widget_empty_sub": "Añade tu primera cosa"
```
