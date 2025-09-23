#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# --- Variables requeridas por ti ---
USER_HOME="${HOME}"
CAPTURE_DIR="${USER_HOME}/Images/Captures"

# --- Configuración interna ---
mkdir -p "$CAPTURE_DIR"

# Flags
COPY=false   # --copy
AREA=false   # --area
EDIT=false   # --edit (abrir swappy)
QUIET=false  # --quiet (silenciar notificaciones)

# --- Helpers ---
notify() {
  [ "$QUIET" = true ] && return
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "Screenshot" "$1"
  fi
}

copy_to_clipboard() {
  local file="$1"
  if command -v wl-copy >/dev/null 2>&1; then
    wl-copy --type image/png < "$file"
    return $?
  elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard -t image/png -i "$file"
    return $?
  else
    echo "ERROR: no se encontró wl-copy ni xclip. No puedo copiar al portapapeles." >&2
    return 2
  fi
}

usage() {
  cat <<EOF
Uso: $(basename "$0") [--copy] [--area] [--edit] [--quiet]

  --copy    : Copiar imagen al portapapeles en vez de (o además de) guardar.
  --area    : Seleccionar un área con slurp (si no, captura pantalla completa).
  --edit    : Abrir el resultado en swappy para editar (se guarda el archivo en CAPTURE_DIR).
  --quiet   : No enviar notificaciones.
EOF
}

# --- Parseo de argumentos ---
while (( "$#" )); do
  case "$1" in
    --copy) COPY=true; shift;;
    --area) AREA=true; shift;;
    --edit) EDIT=true; shift;;
    --quiet) QUIET=true; shift;;
    -h|--help) usage; exit 0;;
    *) echo "Argumento desconocido: $1" >&2; usage; exit 2;;
  esac
done

# Timestamp y nombre de archivo por defecto
timestamp="$(date '+%F_%H-%M-%S')"
out_file="${CAPTURE_DIR}/screenshot-${timestamp}.png"

# Si pedimos un área, pedimos la geometría con slurp
if [ "$AREA" = true ]; then
  # slurp devuelve una geometría; si el usuario cancela suele devolver vacío / error
  geom="$(slurp 2>/dev/null || true)"
  if [ -z "$geom" ]; then
    notify "Captura cancelada"
    exit 0
  fi
fi

# --- Casos ---
# 1) Editar (--edit): capturamos a archivo y abrimos swappy
if [ "$EDIT" = true ]; then
  if [ "$AREA" = true ]; then
    grim -g "$geom" "$out_file"
  else
    grim "$out_file"
  fi

  if command -v swappy >/dev/null 2>&1; then
    # Abrimos swappy; swappy permite editar y guardar en el archivo
    swappy -f "$out_file"
  else
    echo "Aviso: swappy no encontrado. Imagen guardada en: $out_file" >&2
  fi

  # Si además queremos copiar después de editar:
  if [ "$COPY" = true ]; then
    copy_to_clipboard "$out_file" && notify "Editado y copiado al portapapeles"
  else
    notify "Guardado: $out_file"
  fi

  echo "$out_file"
  exit 0
fi

# 2) Copiar al portapapeles (--copy sin --edit)
if [ "$COPY" = true ]; then
  if command -v wl-copy >/dev/null 2>&1; then
    if [ "$AREA" = true ]; then
      grim -g "$geom" - | wl-copy --type image/png
    else
      grim - | wl-copy --type image/png
    fi
    notify "Captura copiada al portapapeles"
    exit 0
  elif command -v xclip >/dev/null 2>&1; then
    # xclip no lee desde stdin tan cómodamente para imágenes desde grim: hacemos archivo temporal
    tmpf="$(mktemp --suffix=.png /tmp/screenshot-XXXXXX.png)"
    if [ "$AREA" = true ]; then
      grim -g "$geom" "$tmpf"
    else
      grim "$tmpf"
    fi
    xclip -selection clipboard -t image/png -i "$tmpf"
    rm -f "$tmpf"
    notify "Captura copiada al portapapeles"
    exit 0
  else
    echo "ERROR: wl-copy ni xclip encontrados; no puedo copiar al portapapeles." >&2
    exit 3
  fi
fi

# 3) Guardar en disco (por defecto)
if [ "$AREA" = true ]; then
  grim -g "$geom" "$out_file"
else
  grim "$out_file"
fi

notify "Guardado: $out_file"
echo "$out_file"
exit 0
