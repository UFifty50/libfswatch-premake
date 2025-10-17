local outputDir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

workspace "libfswatch"
    configurations { "Debug", "Release" }
    architecture "x86_64"
    flags { "MultiProcessorCompile" }
    debugdir ("bin/" .. outputDir)


project "libfswatch"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"
    targetdir ("bin/" .. outputDir .. "/%{prj.name}")
    objdir    ("bin/intermediate/" .. outputDir .. "/%{prj.name}")

    files {
        "src/libfswatch/c/**.h",
        "src/libfswatch/c/**.hpp",
        "src/libfswatch/c/**.cpp",
        "src/libfswatch/c++/**.h",
        "src/libfswatch/c++/**.hpp",
        "src/libfswatch/c++/**.cpp",
        "src/libfswatch/c++/string/**.cpp",
        "src/libfswatch/gettext.h",
        "src/libfswatch/gettext_defs.h",
        "src/libfswatch/c/**.h"
    }

    includedirs {
        "src/libfswatch",
        "src",
        "build/generated"
    }

    defines { "HAVE_LIBFSWATCH_CONFIG_H" }

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "Full"

    filter "system:windows"
        defines { "HAVE_WINDOWS" }
        systemversion "latest"
        files { "src/libfswatch/c++/windows/**.cpp", "src/libfswatch/c++/windows/**.h" }
        removefiles { "src/libfswatch/c++/inotify_*", "src/libfswatch/c++/kqueue_*", "src/libfswatch/c++/fsevents_*", "src/libfswatch/c++/fen_*" }

   filter "system:linux"
      defines { "HAVE_SYS_INOTIFY_H" }
      files { "src/libfswatch/c++/inotify_monitor.cpp", "src/libfswatch/c++/inotify_monitor.hpp" }
      removefiles { "src/libfswatch/c++/windows/**", "src/libfswatch/c++/kqueue_*", "src/libfswatch/c++/fsevents_*", "src/libfswatch/c++/fen_*" }

