# Dia4SemanaTec
# Clasificación Automática de Archivos y Auditoría de Código Python

Script en Bash, diseñado con apoyo de herramientas de IA, que descomprime un archivo `.zip`, organiza su contenido por extensión y audita los archivos `.py` para detectar el uso de `cv2` (OpenCV).

## Uso

Sintaxis: `./script.sh <archivo.zip> <directorio_destino>`

- `$1`: ruta del archivo `.zip` a procesar (por ejemplo, `proyecto_analisis.zip`).
- `$2`: directorio destino donde se organizarán los archivos.

## Requisitos

- Bash en Linux, macOS o WSL.
- Herramientas: `unzip`, `find`, `grep`, `mkdir`, `mv`/`cp`.

## Qué hace el script

1. **Validación:** exige exactamente 2 argumentos y comprueba que el `.zip` exista. Si falla, muestra el mensaje de uso y termina con `exit 1`.
2. **Organización:** descomprime en una carpeta temporal y mueve cada archivo a una subcarpeta del destino según su extensión (`py/`, `txt/`, `jpg/`, `otros/`, etc.).
3. **Auditoría:** revisa solo los archivos `.py` buscando `cv2`, `import cv2` u `opencv`. Por cada archivo imprime su ubicación, si contiene la coincidencia y el número y texto de cada línea encontrada (`grep -n`).
4. **Resumen final:** total de archivos `.py` analizados y cuántos usan `cv2`.

## Prompts de IA

**Herramienta utilizada:** _(herramienta y modelo)_

**Prompt inicial:**
_(pegar aquí el prompt exacto de la primera versión)_

**Prompt de corrección (si aplica):**
_(pegar aquí el prompt de ajuste o refactoring)_

## Control de versiones

- Rama de trabajo: `feature/organizer-auditor`.
- Commits sugeridos:
  - `feat: validación de parámetros y descompresión`
  - `feat: lógica de organización por extensión`
  - `feat: auditoría de cv2 en scripts python`
- Integración a `main`/`master` mediante merge o Pull Request.

## Autor

_(Nombre)_ · _(Materia)_ · _(Profesor)_ · 29 de octubre de 2026
