# HouseKeep — Legal

Plantillas de **Privacy Policy** y **Terms of Use** en ES + EN, listas para hostear.

> ⚠️ Estos documentos son una plantilla razonable basada en una app local-first sin backend. **No constituyen asesoría legal.** Para una versión definitiva, revísalos con un abogado, especialmente si planeas operar en jurisdicciones con regulaciones específicas (GDPR, CCPA, LOPD-GDD, COPPA).

## Archivos

| Archivo | Idioma | Uso |
|---------|--------|-----|
| `privacy_es.md` | ES | Política de Privacidad (App Store ES + Play ES + landing) |
| `privacy_en.md` | EN | Privacy Policy (App Store EN + Play EN + landing) |
| `terms_es.md` | ES | Términos de Uso |
| `terms_en.md` | EN | Terms of Use |

## Hosting cero-coste con GitHub Pages

1. En el repo `housekeep` activa GitHub Pages (Settings > Pages > source: branch `master` folder `/docs`).
2. Convierte a HTML:
   - `pandoc docs/legal/privacy_es.md -o docs/legal/privacy_es.html -s --metadata title="Política de Privacidad"`
   - Repetir para los 4 archivos.
3. URLs públicas resultantes (con username `darumo`):
   - `https://darumo.github.io/housekeep/legal/privacy_en.html`
   - `https://darumo.github.io/housekeep/legal/privacy_es.html`
   - `https://darumo.github.io/housekeep/legal/terms_en.html`
   - `https://darumo.github.io/housekeep/legal/terms_es.html`
4. Pegar esas URLs en App Store Connect y Google Play Console (campos Privacy Policy URL).

## Antes de publicar

Reemplazar todos los `{PLACEHOLDERS}`:
- `{SUPPORT_EMAIL}` → email real de soporte
- `{COMPANY_NAME}` → nombre legal (persona física o empresa)
- `{COMPANY_ADDRESS}` → dirección postal (obligatoria para GDPR Art. 13)
- `{JURISDICTION}` → jurisdicción aplicable (ej. España)
- `{EFFECTIVE_DATE}` → ya puesto a 2026-05-26; actualizar si retrasas el lanzamiento

## Cambios futuros

Cada vez que cambies la política, actualiza:
1. `Effective date` en los 4 archivos
2. Regenera HTML
3. Notifica a usuarios existentes en el changelog de la app
