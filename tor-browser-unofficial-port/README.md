# Tor Browser Unofficial Port

Unfortunately developers of Tor Browser have not released an ARM64
release for Linux. Yes They had released an ARM64 release for macOS but not
for Linux. So some people have maintain a release for ARM64 Linux on
SourceForge. And here I have made a ArchLinux Package from that unofficial
release. Use on your own risk.

## Some Notes

This build is based on Tor Browser's AUR PKGBUILD. So they put the binary
archive under `opt`. And when you run the binary it extracts itself under
`~/.local/opt/tor-browser-unofficial-port`

I have changed the name from `tor-browser` to `tor-browser-unofficial-port`

After installing run this :

```txt
tor-browser-unofficial-port
```

## Resources

* [SourceForge - Tor Browser Ports Files][01]
* [AUR - tor-browser-bin][02]
* [ArchLinux Packages - torbrowser-launcher][03]

[01]: https://sourceforge.net/projects/tor-browser-ports/files/
[02]: https://aur.archlinux.org/packages/tor-browser-bin
[03]: https://archlinux.org/packages/extra/any/torbrowser-launcher/
