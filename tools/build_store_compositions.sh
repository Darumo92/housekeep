#!/usr/bin/env bash
# Build branded 1080x1920 Google Play screenshots from raw app captures.
#
# For each raw capture: warm cream gradient canvas + short headline/subcopy
# at the top (<=20% of the image) + the real UI screenshot floated below with
# rounded corners and a soft shadow. Output is flattened PNG24, no alpha.
#
# Usage: tools/build_store_compositions.sh <lang>   (lang: en | es, default en)
set -euo pipefail

LANG_DIR="${1:-en}"
RAW="store/screenshots/android/raw/${LANG_DIR}"
OUT="store/screenshots/android/final/$([ "$LANG_DIR" = es ] && echo es-ES || echo en-US)"
FONT="assets/fonts/PlusJakartaSans-Variable.ttf"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$OUT"

TEXT='#1F2624'      # AppColors.text
MUTED='#6B7270'     # AppColors.textMuted

# compose <out_name> <src_png> <headline> <subcopy>
compose() {
  local name="$1" src="$2" head="$3" sub="$4"

  # 1) scale screen to a fixed height, round its corners, drop a soft shadow
  magick "$src" -resize x1540 "$TMP/s.png"
  read -r W H < <(identify -format "%w %h\n" "$TMP/s.png")
  magick "$TMP/s.png" \
    \( -size "${W}x${H}" xc:none -draw "roundrectangle 0,0,$((W-1)),$((H-1)),42,42" \) \
    -alpha set -compose DstIn -composite "$TMP/s_round.png"
  magick "$TMP/s_round.png" \
    \( +clone -background black -shadow 40x22+0+14 \) \
    +swap -background none -layers merge +repage "$TMP/s_sh.png"
  read -r SW SH < <(identify -format "%w %h\n" "$TMP/s_sh.png")

  # 2) warm gradient canvas + floated screen (centered, top at y=336)
  local X=$(( (1080 - SW) / 2 )); local Y=336
  magick -size 1080x1920 gradient:'#FCF8F1'-'#F1E7D7' "$TMP/canvas.png"
  magick "$TMP/canvas.png" "$TMP/s_sh.png" -geometry "+${X}+${Y}" \
    -compose over -composite "$TMP/withscreen.png"

  # 3) headline (auto-wrapped, faux-semibold via thin stroke) + subcopy
  magick -background none -fill "$TEXT" -stroke "$TEXT" -strokewidth 0.7 \
    -font "$FONT" -pointsize 56 -size 940x -gravity center \
    caption:"$head" "$TMP/head.png"
  read -r _ HH < <(identify -format "%w %h\n" "$TMP/head.png")

  magick "$TMP/withscreen.png" "$TMP/head.png" \
    -gravity North -geometry +0+86 -compose over -composite "$TMP/withhead.png"

  if [ -n "$sub" ]; then
    magick -background none -fill "$MUTED" -font "$FONT" -pointsize 31 \
      -size 900x -gravity center caption:"$sub" "$TMP/sub.png"
    local SUBY=$(( 86 + HH + 14 ))
    magick "$TMP/withhead.png" "$TMP/sub.png" \
      -gravity North -geometry "+0+${SUBY}" -compose over -composite "$TMP/final.png"
  else
    cp "$TMP/withhead.png" "$TMP/final.png"
  fi

  # 4) flatten onto opaque cream, strip alpha -> PNG24
  magick "$TMP/final.png" -background '#FCF8F1' -alpha remove -alpha off \
    -depth 8 PNG24:"$OUT/$name"
  identify -format "%f  %wx%h  %[channels]\n" "$OUT/$name"
}

if [ "$LANG_DIR" = es ]; then
  compose 01_dashboard_hero.png  "$RAW/01_home.png"        "Tu hogar, siempre al día"                 "Mantenimientos, garantías y documentos en un solo sitio"
  compose 02_maintenance.png     "$RAW/05_item_detail.png" "No olvides ninguna revisión ni garantía"  "Controla el calendario de cada electrodoméstico"
  compose 03_items.png           "$RAW/03_items.png"       "Todo lo importante de casa"               "Con el estado de la garantía a la vista"
  compose 04_documents.png       "$RAW/04_documents.png"   "Garantías y documentos bajo control"      "Sabe qué caduca, antes de que pase"
  compose 05_templates.png       "$RAW/06_templates.png"   "Empieza en minutos con plantillas"        "Planes de mantenimiento listos para usar"
  compose 06_widget.png          "$RAW/08_widget.png"      "Tus avisos, en la pantalla de inicio"     "Lo que vence, de un vistazo"
  compose 07_pro_unlock.png      "$RAW/paywall_clean.png"  "Un único pago. Para siempre."             ""
else
  compose 01_dashboard_hero.png  "$RAW/01_home.png"        "Your home, always on track"               "Maintenance, warranties & documents in one place"
  compose 02_maintenance.png     "$RAW/05_item_detail.png" "Never miss a service or warranty"         "Track every appliance's schedule"
  compose 03_items.png           "$RAW/03_items.png"       "Every appliance, neatly organized"        "With live warranty status"
  compose 04_documents.png       "$RAW/04_documents.png"   "Documents & warranties under control"      "Know what expires, before it does"
  compose 05_templates.png       "$RAW/06_templates.png"   "Set up in minutes with templates"         "Ready-made maintenance plans"
  compose 06_widget.png          "$RAW/08_widget.png"      "Your reminders, on the home screen"       "See what's due at a glance"
  compose 07_pro_unlock.png      "$RAW/paywall_clean.png"  "One unlock. Yours forever."               ""
fi

echo "Done -> $OUT"
