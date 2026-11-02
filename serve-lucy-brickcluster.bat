@echo off
rem FIXED 2026-10-29 (Jonathan: "that's not an issue that's just needs wild cards"): no account
rem name hardcoded anymore. REAL CORRECTION mid-fix, caught by actually testing it rather than
rem trusting it: Windows cmd's wildcard matching only expands the LAST path segment, not a
rem directory name in the MIDDLE of a path -- `for %%P in ("C:\Users\*\...\python.exe")` silently
rem matches nothing and falls through to the "python" fallback every time, on every machine,
rem never actually finding a real install. `for /d` (iterate matching DIRECTORIES first, then
rem test each one with `exist`) is what Windows batch actually needs for this; verified against
rem the real file on this machine before shipping, not assumed.
cd /d "%~dp0"
set "PY="
for /d %%U in ("C:\Users\*") do (
    if not defined PY if exist "%%U\.conda\envs\galatea\python.exe" set "PY=%%U\.conda\envs\galatea\python.exe"
)
for /d %%U in ("C:\Users\*") do (
    if not defined PY if exist "%%U\miniconda3\python.exe" set "PY=%%U\miniconda3\python.exe"
)
if not defined PY set "PY=python"
"%PY%" -B brickcluster_server.py --host 127.0.0.1 --port 8105
pause
