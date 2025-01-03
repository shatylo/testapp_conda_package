cmake_minimum_required(VERSION 3.5.0)
set(CMAKE_BUILD_TYPE Release)
project(TestWinapi VERSION 0.1.0 LANGUAGES C CXX)
# Set Unicode definition - Win32API specific configuration

add_definitions(-DUNICODE -D_UNICODE)
add_executable(TestWinapi WIN32 main.cpp)
target_link_libraries(${PROJECT_NAME} 
    User32.lib 
    Gdi32.lib 
    Kernel32.lib 
    Advapi32.lib
)
