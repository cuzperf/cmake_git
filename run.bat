rmdir /s /q build
cmake -B build
cmake --build build
build\Debug\main.exe
