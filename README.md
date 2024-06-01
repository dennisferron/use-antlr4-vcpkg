# Use ANTLR4 vcpkg Port

I couldn't find a simple, ready to use and complete example of using the C++ ANTLR4 runtime via its vcpkg port, so I created this project.  This project is designed to be opened in the CLion IDE, but other ways of using it via CMake should also work.

This example project also demonstrates the use, in combination with ANTLR4 and vcpkg, of:  vcpkg manifest mode, custom ports registry, CMake Presets, and Emscripten toolchain.  These are included, not because you need them to use ANTLR4 in C++, but because projects I'm working on use them.  This example project is both a by-product of that work and a record so I don't forget how to do it.

The intention is that it could be a skeleton project you copy to start a new project using ANTLR4 in C++, or one to refer to to see how to use certain features.
  
## Installation / Prerequisites

The ANTLR4 .jar file will be downloaded automatically during CMake configuration using FetchContent.  Currently this example project is not hardcoded to a specific version of ANTLR4 in either the vcpkg port nor the FetchContent download.  It is just assumed that the latest vcpkg port of the runtime and latest ANTLR4 .jar file will work together.  That version is/was 4.13 as of the time of writing.

I opted to tell FetchContent to place the ANTLR4 .jar in a "download" subfolder of the project sources (not the CMake build folder) so that multiple build configurations could reuse the same .jar file rather than re-downloading it for every one.  I added "download/" to the .gitignore file.

The ANLTR4 generator requires Java to be installed on the system.  The JRE should be sufficient to generate a C++ parser, but you will need the (or a) Java JDK to compile your grammar to a Java class if you want to run additional tools such as the GUI-based parse visualizer.  I used the OpenJDK at https://jdk.java.net/22/ .  You just unzip it to a folder and put the bin in your PATH.  Possibly you also need to set JAVA_HOME to the unzipped folder (not bin); I don't use Java regularly so I'm not sure. 

The latest ANTLR4 jar requires a fairly recent Java runtime; if you get a JNI error check the versions and which Java is being used.  I had multiple different Javas on my system, and the project kept finding/using the wrong one (old) even after I'd tried increasingly desperate measures to force it to use the latest JDK.  I finally had diagnostic success adding the prefix "no-" to every location on my C: drive with a java.exe in it, so that existing paths would be invalidated.

In my case it turned out emsdk (Emscripten) comes with a bundled Java, and CMake was finding the one in that folder.  It was also the one previously in my "JAVA_HOME" until I changed it to the newly downloaded OpenJDK.  (I have yet to determine if changing JAVA_HOME in turn broke emsdk...)  However the changed java location wasn't getting picked up until I also reran CMake configuration.

The vcpkg package manager must be separately downloaded and built.  The project is set up for vcpkg to be located in C:\source\vcpkg; if yours is in a different location you will need to edit CMakePresets.json.

The CMakePresets.json also includes build targets for Emscripten.  It expects the Emscripten SDK to be located in C:\source\emsdk, which again is a setting that can be changed if yours is in a different location.

(Emscripten is not strictly necessary to compile this example.  You can just choose not to use or enable those build configurations.  They do, however, serve to show how the VCPKG_HOST_TRIPLET and VCPKG_TARGET_TRIPLET differ between parser generation versus compilation.)

If all prerequisites are met, the CMakeLists.txt in this project should take care of everything else during configuration and build steps.  Installation of the built executable itself is not applicable, as the purpose of this project is to serve as an example.

## Usage

TODO
