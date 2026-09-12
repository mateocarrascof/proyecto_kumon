@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set "REPO=https://github.com/mateocarrascof/proyecto_kumon.git"
cd /d "%~dp0"

echo ============================================================
echo  Subir FINAL FASE 1 a GitHub
echo  Repositorio: %REPO%
echo  Carpeta:     %CD%
echo ============================================================
echo.

where git >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Git no esta instalado o no esta en el PATH.
  echo         Instalalo desde https://git-scm.com/download/win , cierra esta ventana
  echo         y vuelve a ejecutar este archivo.
  echo.
  pause
  exit /b 1
)

set "GITNAME="
set "GITMAIL="
for /f "delims=" %%i in ('git config --global user.name 2^>nul') do set "GITNAME=%%i"
for /f "delims=" %%i in ('git config --global user.email 2^>nul') do set "GITMAIL=%%i"

if "!GITNAME!"=="" (
  echo Git todavia no sabe quien eres.
  set /p "GITNAME=  Escribe tu nombre y presiona Enter: "
  git config --global user.name "!GITNAME!"
)
if "!GITMAIL!"=="" (
  set /p "GITMAIL=  Escribe tu correo de GitHub y presiona Enter: "
  git config --global user.email "!GITMAIL!"
)
echo.

echo [1/6] Inicializando repositorio local...
git init
if errorlevel 1 goto :error

echo [2/6] Configurando el remoto...
git remote remove origin >nul 2>nul
git remote add origin "%REPO%"
if errorlevel 1 goto :error

echo [3/6] Agregando archivos...
git add -A
if errorlevel 1 goto :error

echo [4/6] Creando el commit...
git diff --cached --quiet
if not errorlevel 1 (
  echo       No hay cambios nuevos. Se sube lo que ya estaba confirmado.
) else (
  git commit -m "Fase 1: documentacion administrativa y anexos de diseno y gestion"
  if errorlevel 1 goto :error
)

echo [5/6] Renombrando la rama principal a main...
git branch -M main
if errorlevel 1 goto :error

echo [6/6] Subiendo a GitHub...
echo       Si es la primera vez, se abrira una ventana para iniciar sesion en GitHub.
git push -u origin main
if errorlevel 1 goto :error

echo.
git log --oneline -1
echo.
echo ============================================================
echo  LISTO. Revisa el resultado en:
echo  https://github.com/mateocarrascof/proyecto_kumon
echo ============================================================
echo.
pause
exit /b 0

:error
echo.
echo ============================================================
echo  Algo fallo. Copia el mensaje de error de arriba y pasamelo.
echo ============================================================
echo.
pause
exit /b 1
