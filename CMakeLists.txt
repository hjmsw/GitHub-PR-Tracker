cmake_minimum_required(VERSION 3.21)
project(prtracker VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(prtracker
    src/main.cpp
)

qt_add_qml_module(prtracker
    URI prtracker
    VERSION 1.0
    QML_FILES
        qml/main.qml
        qml/PrCard.qml
        qml/PrList.qml
        qml/SettingsDialog.qml
        qml/ThemedCheckBox.qml
    SOURCES
        src/PrFetcher.h
        src/PrFetcher.cpp
)

target_include_directories(prtracker PRIVATE src)

# In debug builds, load QML from source directory so UI changes only need a restart
target_compile_definitions(prtracker PRIVATE
    $<$<CONFIG:Debug>:QML_SOURCE_DIR="${CMAKE_SOURCE_DIR}/qml">
)

target_link_libraries(prtracker PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
)
