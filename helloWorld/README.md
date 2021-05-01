# Hello World

Just an example of building a dynamic extension for **kdb+** using latest C++20 standard but statically linked that dependency. That way it would be possible to execute that extension on a system without C++20 libraries.

Take into account that the libc should be compatible between the building system and the execution one. For example, use the latest compiler in the older kernel Linux box to take advantage of probably **libc** compatibility.

On my dev env, Archlinux g++ 10, my *q* environment got defined its **QHOME** and **QARCH** to locate the folder where the shared library should be installed. Modify that [CMakeLists.txt](CMakeLists.txt) to suit your needs.

Once the library is installed, just execute the [helloWorld.q](helloWorld.q) script:

	./helloWorld.q 2>/dev/null

Or if your system hasn't defined *q* to be used in *shebang* scripts, just run it in the classic way inside *q*:

	\l helloWorld.q

The answer to the Ultimate Question of Life, the Universe, and Everything is expected:

	42

### Some logs to check out your development environment

In my case, my daily driver is Arch with g++ 10 at the time of writing these lines and my target is just a KVM Centos 8 Stream box. 

In the following logs you can check that the important part of this example not to forget linking statically against compiler depending libraries:

````
⋊> ~/C/kdbExtension on main ◦ uname -a                                                                        15:52:59
Linux ArchLinux 5.11.16-arch1-1 #1 SMP PREEMPT Wed, 21 Apr 2021 17:22:13 +0000 x86_64 GNU/Linux
⋊> ~/C/kdbExtension on main ◦ g++ --version                                                                   15:53:42
g++ (GCC) 10.2.0
Copyright (C) 2020 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

⋊> ~/C/kdbExtension on main ◦ centos                                                                          15:53:48
Activate the web console with: systemctl enable --now cockpit.socket

Last login: Sat May  1 15:41:10 2021 from 192.168.122.1
[user@centos ~]$ uname -a
Linux centos 4.18.0-301.1.el8.x86_64 #1 SMP Tue Apr 13 16:24:22 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
[user@centos ~]$ g++ --version
g++ (GCC) 8.4.1 20200928 (Red Hat 8.4.1-1)
Copyright (C) 2018 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

[user@centos ~]$ q
KDB+ 4.0 2020.05.04 Copyright (C) 1993-2020 Kx Systems
l64/ 4(16)core 15658MB user centos 192.168.122.193 EXPIRE 2022.05.01 asevillano@kx.com KOD #4176040

q)\l helloWorld.q
42
[user@centos ~]$ exit
logout
Connection to centos closed.
⋊> ~/C/kdbExtension on main ◦ helloWorld/helloWorld.q 2>/dev/null                                             15:54:36
42
````

### Some logs to build using a Docker image

In case you want to use the provided Dockerfile to build your libraries using the latest *gcc*, don't forget to specify your user **uid** to be able to remove easier binaries in your host:

````
⋊> ~/C/kdbExtension on main ◦ id                                                                              17:17:01
uid=1000(user) gid=985(users) groups=985(users),966(chrome-remote-desktop),970(docker),974(libvirt),986(video),992(kvm),995(audio),998(wheel)
````

Therefore, my *uid* is 1000, a typical value.

The root of my cloned git project contains the [Dockerfile](../Dockerfile). For example, name the image as **cmakegcc** when you build it the following command:

````
⋊> ~/C/kdbExtension on main ◦ docker build -t cmakegcc .                                                      17:17:04
Sending build context to Docker daemon  423.4kB
Step 1/2 : FROM gcc:latest
 ---> 5d727bf4de0e
Step 2/2 : RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf &&     apt-get update && apt-get install -y cmake neovim
 ---> Using cache
 ---> 311bca56c9ac
Successfully built 311bca56c9ac
Successfully tagged cmakegcc:latest
````

As you can see, I needed to add a specific *nameserver* because I didn't bore to configure my KVM/docker environment in the correct way.

Then it's a question of correctly choosing the directories in the **docker/podman** and **cmake** commands:

````
⋊> ~/C/kdbExtension on main ◦ mkdir -p helloWorld/build                                                       17:16:02
⋊> ~/C/kdbExtension on main ◦ docker run --rm -u 1000 -v "$PWD":/root -w /root cmakegcc cmake -S ./helloWorld -B ./helloWorld/build
-- The C compiler identification is GNU 11.1.0
-- The CXX compiler identification is GNU 11.1.0
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /usr/bin/cc - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /usr/local/bin/c++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- /
-- Configuring done
-- Generating done
-- Build files have been written to: /root/helloWorld/build
⋊> ~/C/kdbExtension on main ◦ docker run --rm -u 1000 -v "$PWD":/root -w /root cmakegcc cmake --build /root/helloWorld/build
Scanning dependencies of target HelloWorld
[ 50%] Linking CXX shared library libHelloWorld.so
[100%] Built target HelloWorld
⋊> ~/C/kdbExtension on main ◦ ldd ./helloWorld/build/libHelloWorld.so                                         17:16:51
	linux-vdso.so.1 (0x00007fff369fa000)
	libm.so.6 => /usr/lib/libm.so.6 (0x00007f23e5af0000)
	libc.so.6 => /usr/lib/libc.so.6 (0x00007f23e5923000)
	/usr/lib64/ld-linux-x86-64.so.2 (0x00007f23e5c72000)
````

Once you're done with the building, just remove that image:

````
docker rmi --force cmakegcc
````
