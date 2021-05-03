cmake_minimum_required(VERSION 3.18)
project(HelloWorld)

# going for the latest standard by default. Ajust it to your needs
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# you might want to cp -r the root include on your local source folder instead
include_directories(${PROJECT_SOURCE_DIR}/../include)
file(GLOB MY_SOURCES *.cpp)
add_library(${PROJECT_NAME} SHARED ${MY_SOURCES})
# using kdb+ 4.0 for this examples
target_compile_options(${PROJECT_NAME} PRIVATE -fPIC -DKXVER=4)
# the key factor to deploy on Linux boxes with older compilers is to statically build the C++ dependency
target_link_libraries(${PROJECT_NAME} -static-libgcc -static-libstdc++)

# depends on your local kdb configuration
set(QHOME_BINARY_FOLDER $ENV{QHOME}/$ENV{QARCH})
message(STATUS ${QHOME_BINARY_FOLDER})
install(TARGETS ${PROJECT_NAME} LIBRARY DESTINATION ${QHOME_BINARY_FOLDER})
