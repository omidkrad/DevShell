@:: source:https://gist.github.com/abergs/e682cd1f98f5170e86a6
@:: Use to delete directories with long file paths.
@:: e.g.: rdel .\node_modules

@echo off
setlocal
set emptyDir="%TEMP%\empty"
mkdir %emptyDir%
robocopy %emptyDir% %* /mir
rm %emptyDir% -r
rm %* -r
