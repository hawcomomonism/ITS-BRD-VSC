@echo off
setlocal

REM Hilfe Kommand, wenn angefragt.
FOR %%A IN ("-h" "-help" "/?" "--help") DO IF ("%1"=="%%A") (
    echo "Erstellt eine Struktur für ein C Projekt. Um einen Projektnamen anzugeben führen Sie die Batch Datei %0 aus und geben Sie optional das Argument -name <projekt_name> an."
    exit /b 0
)

REM Überprüfen, ob ein Argument übergeben wurde (Projektname)
if "%1"=="" (
    REM Falls kein Argument übergeben wurde, den Benutzer zur Eingabe auffordern
    set /p project_name="Bitte geben Sie einen C Projektnamen ein: "
) else (
    REM Projektname aus dem Argument übernehmen
    set "project_name=%2"
)

REM Für ASM-Projekt
echo Erstelle C-Projekt mit dem Namen: %project_name%
REM Aufruf des PowerShell-Skripts
pwsh -ExecutionPolicy Bypass -File createGenericProject.ps1 --c %project_name%

REM Beende das Skript
exit /b 0
