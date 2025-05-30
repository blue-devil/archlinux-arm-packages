# Chromium

Chromium build from official build gives error:

```txt
$ chromium
/usr/lib/chromium/chromium: error while loading shared libraries: libicui18n.so.75: cannot open shared object file: No such file or directory
```

```txt
$ ldd /usr/lib/chromium/chromium
linux-vdso.so.1 (0x0000ffffa16bd000)
libgobject-2.0.so.0 => /usr/lib/libgobject-2.0.so.0 (0x0000ffff92770000)
libglib-2.0.so.0 => /usr/lib/libglib-2.0.so.0 (0x0000ffff925d0000)
libicui18n.so.75 => not found
libicuuc.so.75 => not found
libsmime3.so => /usr/lib/libsmime3.so (0x0000ffff92580000)
libnss3.so => /usr/lib/libnss3.so (0x0000ffff92400000)

<snip>

libudev.so.1 => /usr/lib/libudev.so.1 (0x0000ffff90bc0000)
libasound.so.2 => /usr/lib/libasound.so.2 (0x0000ffff90aa0000)
libpulse.so.0 => /usr/lib/libpulse.so.0 (0x0000ffff90a20000)
libFLAC.so.12 => not found
libxml2.so.2 => not found
libatspi.so.0 => /usr/lib/libatspi.so.0 (0x0000ffff909c0000)
libminizip.so.1 => /usr/lib/libminizip.so.1 (0x0000ffff909a0000)
libxslt.so.1 => /usr/lib/libxslt.so.1 (0x0000ffff90940000)

<snip>
```

Then I have found a thread on [ArchLinux | ARM Forums][01].

I clone the files from [Chramium PKGBUILD][02] and needed files from ArchLinux
ARM Github and run the command to build it:

```txt
makepkg -scAL
```

This command built a new fresh chromium. It takes a lot time and once crashed
my machine.

I do not add the PKGBUILD here, as it can be cloned from [Github][02]. But
I have added the package!

## Resources

* [ArchLinux | ARM Forums - please update the chromium package][01]
* [ArchLinux | ARM Github - Chromium PKGBUILD][02]

[01]: https://archlinuxarm.org/forum/viewtopic.php?f=15&t=17210
[02]: https://github.com/archlinuxarm/PKGBUILDs/tree/master/extra/chromium
