:: Rebuilds windows icon cache

@echo off
setlocal
echo This will restart the Explorer process to rebuild windows icon cache. All
echo explorer windows will be closed.
pause

del /a "%USERPROFILE%\AppData\Local\IconCache.db"
tskill explorer
