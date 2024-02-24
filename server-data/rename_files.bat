@echo off

rem This script renames all files named "!newName!.lua" and "__resource.lua"
rem to "fxmanifest.lua" in the current folder and all subfolders.

rem Recursively loop through all subfolders
for /r ".\" %%f in ("!newName!.lua", "__resource.lua") do (
  rem Rename the file
  ren "%%f" "fxmanifest.lua"
)

rem Display a message that the renaming is complete
echo Files have been renamed to fxmanifest.lua

rem Pause the script
pause