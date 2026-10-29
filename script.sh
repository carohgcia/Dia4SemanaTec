#!/bin/bash
# ==============================================================================
# script.sh - Organiza el contenido de un .zip por extensión y audita el uso
#             de la librería cv2 (OpenCV) en los archivos .py.
#
# Uso: ./script.sh <archivo.zip> <directorio_destino>
# ==============================================================================

# ------------------------------------------------------------------------------
# REQUERIMIENTO 1: Validación de argumentos
# ------------------------------------------------------------------------------
if [ "$#" -ne 2 ]; then
    echo "Uso: ./script.sh <archivo.zip> <directorio_destino>"
    exit 1
fi

ZIP_FILE="$1"
DEST_DIR="$2"

# El archivo .zip debe existir y ser un archivo regular
if [ ! -f "$ZIP_FILE" ]; then
    echo "Error: el archivo '$ZIP_FILE' no existe o no es un archivo regular."
    exit 1
fi

# Dependencia: unzip
if ! command -v unzip >/dev/null 2>&1; then
    echo "Error: el comando 'unzip' no está instalado."
    exit 1
fi

# Verifica que realmente sea un zip válido (integridad)
if ! unzip -tq "$ZIP_FILE" >/dev/null 2>&1; then
    echo "Error: '$ZIP_FILE' no es un archivo .zip válido o está dañado."
    exit 1
fi

# El destino no puede ser un archivo existente
if [ -e "$DEST_DIR" ] && [ ! -d "$DEST_DIR" ]; then
    echo "Error: '$DEST_DIR' existe pero no es un directorio."
    exit 1
fi

# ------------------------------------------------------------------------------
# REQUERIMIENTO 2: Descompresión temporal y organización por extensión
# ------------------------------------------------------------------------------
TMP_DIR=$(mktemp -d 2>/dev/null)
if [ -z "$TMP_DIR" ] || [ ! -d "$TMP_DIR" ]; then
    echo "Error: no se pudo crear el directorio temporal."
    exit 1
fi

# Limpieza automática de la carpeta temporal al terminar (o ser interrumpido)
trap 'rm -rf "$TMP_DIR"' EXIT

if ! mkdir -p "$DEST_DIR"; then
    echo "Error: no se pudo crear el directorio destino '$DEST_DIR'."
    exit 1
fi

echo "==> Descomprimiendo '$ZIP_FILE' en carpeta temporal..."
if ! unzip -q -o "$ZIP_FILE" -d "$TMP_DIR"; then
    echo "Error: falló la descompresión de '$ZIP_FILE'."
    exit 1
fi

# Devuelve una ruta que no exista aún en $1 (carpeta) para el nombre $2.
# Si hay colisión, agrega un sufijo numérico: nombre_1.ext, nombre_2.ext, ...
unique_path() {
    local dir="$1" base="$2"
    local candidate="$dir/$base"
    if [ ! -e "$candidate" ]; then
        echo "$candidate"
        return
    fi
    local stem ext n=1
    if [[ "$base" == *.* && "${base#.}" == *.* ]]; then
        stem="${base%.*}"
        ext=".${base##*.}"
    else
        stem="$base"
        ext=""
    fi
    while [ -e "$dir/${stem}_${n}${ext}" ]; do
        n=$((n + 1))
    done
    echo "$dir/${stem}_${n}${ext}"
}

echo "==> Organizando archivos por extensión en '$DEST_DIR'..."

TOTAL_MOVED=0
PY_FILES=()   # Rutas finales de los .py de ESTA ejecución

# find -print0 + read -d '' => soporta nombres con espacios y saltos de línea.
# Se excluye __MACOSX (metadatos basura que añade macOS al comprimir).
while IFS= read -r -d '' file; do
    base=$(basename "$file")

    # Extensión: lo que sigue al último punto (ignorando un punto inicial,
    # de modo que ".gitignore" NO se considera extensión).
    stripped="${base#.}"
    if [[ "$stripped" == *.* ]]; then
        ext="${stripped##*.}"
        ext=$(printf '%s' "$ext" | tr '[:upper:]' '[:lower:]')   # JPG -> jpg
    else
        ext=""
    fi
    [ -z "$ext" ] && ext="sin_extension"

    target_dir="$DEST_DIR/$ext"
    mkdir -p "$target_dir"

    target=$(unique_path "$target_dir" "$base")
    mv -- "$file" "$target"
    TOTAL_MOVED=$((TOTAL_MOVED + 1))

    if [ "$ext" = "py" ]; then
        PY_FILES+=("$target")
    fi
done < <(find "$TMP_DIR" -type f -not -path '*/__MACOSX/*' -print0)

echo "    Archivos organizados: $TOTAL_MOVED"

# ------------------------------------------------------------------------------
# REQUERIMIENTO 3: Auditoría de archivos .py en busca de cv2
# ------------------------------------------------------------------------------
echo
echo "=============================================="
echo "  AUDITORÍA DE ARCHIVOS .py (búsqueda: cv2)"
echo "=============================================="

TOTAL_PY=0
CV2_PY=0

for pyfile in "${PY_FILES[@]}"; do
    TOTAL_PY=$((TOTAL_PY + 1))
    echo
    echo "Archivo: $pyfile"

    if grep -q -e 'Pyside6' -- "$pyfile"; then
        CV2_PY=$((CV2_PY + 1))
        echo "  Contiene 'Pyside6': SÍ"
        # Número de línea + línea exacta de cada coincidencia
        grep -n -e 'Pyside6' -- "$pyfile" | sed 's/^/    /'
    else
        echo "  Contiene 'Pyside6': NO"
    fi
done

echo
echo "=============================================="
echo "  RESUMEN"
echo "=============================================="
echo "Archivos .py analizados          : $TOTAL_PY"
echo "Archivos .py que usan cv2        : $CV2_PY"

exit 0
