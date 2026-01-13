@echo off
setlocal enabledelayedexpansion
for %%F in ("N:\Dungeon Blocks\Majestic Highlands\Levels\*.stl") do  (
    set backward=%%F
    set "forward=!backward:\=/!"
    "c:\Program Files\OpenSCAD (Nightly)\openscad.exe" --export-format=binstl -o "N:\Dungeon Blocks\Majestic Highlands-Gridded\Levels\%%~nF.stl" gridbottom.scad -D "original_path=\"!forward!\""
)
