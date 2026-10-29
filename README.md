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
3. **Auditoría:** revisa solo los archivos `.py` buscando `PySide6`. Por cada archivo imprime su ubicación, si contiene la coincidencia y el número y texto de cada línea encontrada (`grep -n`).
4. **Resumen final:** total de archivos `.py` analizados y cuántos usan `PySide6`.

## Prompts de IA

**Herramienta utilizada:** Claude

**Prompt inicial:**
Actúa como un desarrollador experto en Bash y crea un script que procese un archivo comprimido, organice su contenido, investiga todo lo que necesites saber antes de crear algo, tómate tu tiempo, eres el mejor del mundo.
Debes utilizar comandos estándar de Bash, específicamente unzip, find, grep, mkdir e if.
Requisitos
El script debe recibir exactamente dos argumentos desde la terminal:
El primer argumento ($1) será la ruta de un archivo .zip a procesar.
El segundo argumento ($2) será la ruta del directorio destino donde se organizará la información.

Requerimiento 1 
Verifica que se reciban exactamente 2 argumentos usando un if. Si no es así, despliega el mensaje de error Uso: ./script.sh <archivo.zip> <directorio_destino> y termina la ejecución con exit 1.
Comprueba mediante una validación que el archivo .zip proporcionado realmente exista en el sistema.
Requerimiento 2
Descomprime el archivo .zip en una carpeta temporal.
Crea subcarpetas dentro del directorio destino basándote en las extensiones de los archivos encontrados (por ejemplo, creando carpetas llamadas py/, txt/, jpg/, etc.).
Mueve o copia cada archivo extraído a la subcarpeta correspondiente a su extensión.
Requerimiento 3
Recorre exclusivamente los archivos con extensión .py.
Busca en el contenido de estos archivos la presencia de la librería PySide6 (o términos como import PySide6).
Salida en Terminal 
Imprime el nombre o la ubicación del archivo.
Indica explícitamente si contiene la palabra buscada (PySide6).

## Autores
Diego Peralta Soto - A01648410
Carolina Hernández García - A01648557
Braulio García Rayas - A0164955


