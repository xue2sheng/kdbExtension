# Hello World

Just an example of building a dynamic extension for **kdb+** using latest C++20 standard but statically linked that dependency. That way it would be possible to execute that extension on a system without C++20 libraries.

Take into account that the libc should be compatible between the building system and the execution one. For example, use the latest compiler in the older kernel Linux box to take advantage of probably **libc** compatibility.

On my dev env, Archlinux g++ 10, my *q* environment got defined its **QHOME** and **QARCH** to locate the folder where the shared library should be installed. Modify that [CMakeLists.txt](CMakeLists.txt) to suit your needs.

Once the library is installed, just execute the [helloWorld.q](helloWorld.q) script:

	./helloWorld.q 2>/dev/null
