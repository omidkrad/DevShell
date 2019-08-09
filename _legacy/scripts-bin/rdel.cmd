@:: source:https://gist.github.com/abergs/e682cd1f98f5170e86a6
@:: Use to delete directories with long file paths.
@:: e.g.: rdel .\node_modules

@echo off
setlocal

if '%1'=='' (
	echo Error: No directories specified.
	exit /b 1
)
if not exist "%1" (
	echo Error: Directory '%1' does not exist.
	exit /b 1
)
echo Delete '%1'?
pause

set emptyDir="%TEMP%\empty"
mkdir %emptyDir%
robocopy %emptyDir% %1 /mir
rd /s /q %emptyDir%
rd /s /q %1
