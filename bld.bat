@ECHO OFF

SET /P myDirName=Please enter a directory: 

IF EXIST %myDirName% (
    echo %myDirName% has already existed! 
) ELSE (
    mkdir %myDirName% && echo %myDirName% created!
)

IF EXIST %myDirName%\vs_InstallBuildTools (
    echo %myDirName%\vs_InstallBuildTools has already existed
) ELSE (
    start /B /wait  vs_BuildTools.exe --layout %myDirName%\vs_InstallBuildTools ^
    --lang en-US ^
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 ^
    --add Microsoft.VisualStudio.Component.Windows11SDK.22000 ^
    --norestart --useLatestInstaller
)

IF EXIST %myDirName%\vs_InstallBuildTools\vs_setup.exe (
    start /B /wait %myDirName%\vs_InstallBuildTools\vs_setup.exe --nocache --noUpdateInstaller --noWeb ^
    --includeOptional --wait
) ELSE (
	echo %myDirName%\vs_InstallBuildTools\vs_setup.exe is not existed!
)

IF NOT EXIST cmake-3.31.3-windows-x86_64.msi (
    curl -OL ^
    https://github.com/Kitware/CMake/releases/download/v3.31.3/cmake-3.31.3-windows-x86_64.msi
)

start /B /wait cmake-3.31.3-windows-x86_64.msi

IF NOT EXIST %cd%\ninja.exe (
    echo ninja.exe is not existed!
    curl -OL ^
    https://github.com/ninja-build/ninja/releases/download/v1.12.1/ninja-win.zip
    tar -xf ninja-win.zip
) ELSE (
    echo ninja.exe is existed!
)

IF NOT EXIST C:\Ninja (
    mkdir C:\Ninja && copy ninja.exe C:\Ninja
    set PATH=%PATH%;C:\Ninja
)

IF NOT EXIST C:\TestWinApi (
    mkdir C:\TestWinApi
    xcopy TestWinApi C:\TestWinApi /E
    cd C:\TestWinApi
    mkdir build
)

call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

call "C:\Program Files\CMake\bin\cmake.exe" -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE ^
--no-warn-unused-cli -SC:/TestWinApi -BC:/TestWinApi/build ^
-G "Visual Studio 17 2022" -T host=x64 -A x64

call "C:\Program Files\CMake\bin\cmake.exe" --build C:/TestWinApi/build ^
--config Release --target ALL_BUILD