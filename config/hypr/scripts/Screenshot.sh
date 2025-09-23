#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# ---------- Config ----------
USER_HOME="${HOME}"
CAPTURE_DIR="${USER_HOME}/Images/Captures"

# ---------- Opciones ----------
COPY=false
AREA=false

# ---------- Parseo de argumentos ----------
for arg in "$@"; do
  case "$arg" in
    --copy) COPY=true ;;
    --area) AREA=true ;;
    -h|--help)
      cat <<EOF
Uso: $(basename "$0") [--area] [--copy]

Sin opciones    -> captura pantalla completa y la guarda en: ${CAPTURE_DIR}
--area          -> permite seleccionar un área con slurp antes de capturar (guarda en ${CAPTURE_DIR})
--copy          -> no guarda, copia la captura al portapapeles (wl-copy)
--area --copy   -> selecciona área y la copia al portapapeles
EOF
      exit 0
      ;;
    *)
      echo "Opción desconocida: $arg" >&2
      exit 2
      ;;
  esac
done

# ---------- Comprobación de dependencias ----------
for cmd in grim; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "ERROR: '$cmd' no está instalado."; exit 3; }
done
$AREA && command -v slurp >/dev/null 2>&1 || true
$COPY && command -v wl-copy >/dev/null 2>&1 || true
command -v notify-send >/dev/null 2>&1 || { echo "Instala 'libnotify' para usar notify-send."; }

# ---------- Preparar ruta de guardado (si aplica) ----------
if ! $COPY; then
  mkdir -p "$CAPTURE_DIR"
  timestamp="$(date +'%Y-%m-%d_%H-%M-%S')"
  outfile="${CAPTURE_DIR}/Screenshot_${timestamp}.png"
fi

# ---------- Captura ----------
if $AREA; then
  geom="$(slurp)" || { notify-send "📸 Captura cancelada"; exit 1; }
  if $COPY; then
    grim -g "$geom" - | wl-copy --type image/png
    notify-send "📸 Captura de área copiada al portapapeles"
  else
    grim -g "$geom" "$outfile"
    notify-send "📸 Captura de área guardada" "$outfile"
  fi
else
  if $COPY; then
    grim - | wl-copy --type image/png
    notify-send "📸 Captura completa copiada al portapapeles"
  else
    grim "$outfile"
    notify-send "📸 Captura completa guardada" "$outfile"
  fi
fi
