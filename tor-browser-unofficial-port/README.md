# Tor Browser Unofficial Port

Unfortunately developers of Tor Browser have not released an ARM64
release for Linux. Yes they had released an ARM64 release for macOS but not
for Linux. So some people have maintained a release for ARM64 Linux on
SourceForge. And here I have made an ArchLinux Package from that unofficial
release. Use on your own risk.

## Packages

| Directory     | Version   | Upstream artifact                                            |
| ------------- | --------- | ------------------------------------------------------------ |
| `latest/`     | 15.0.24   | Prebuilt binary release from [ooovlad/tor-mullvad-aarch64]     |
| `v13.0.9/`    | 13.0.9    | Self-extracting binary release from SourceForge                |

`latest/` packages a prebuilt Tarball and is the one to install. `v13.0.9/`
is kept for the older SourceForge release and installs the same
`tor-browser-unofficial-port` command, so only one of them may be installed
at a time.

## latest/

The `latest/` package downloads an already built Tarball, so nothing is
compiled on your machine and `aarch64` is the only supported architecture.

The Tarball is cross-compiled with Mozilla/Tor's official
[tor-browser-build] on an x86_64 host through the upstream
`browser-linux-aarch64` target. The builder applies no patches to Tor
Browser, and the bundle reports itself as Tor Browser 15.0.24 / Firefox
140.17.0esr.

### Install

```txt
cd latest
makepkg -si
```

After installing run this:

```txt
tor-browser-unofficial-port
```

The command is also available from the desktop menu as *Tor Browser*.

### Install layout

The bundle unpacks straight into `/opt/tor-browser-unofficial-port`, so
`start-tor-browser` sits next to the `is-packaged-app` marker it looks for.
That marker is what moves the profile out of `/opt` and into `~/.tor-browser`,
which is where your bookmarks, history and settings end up. Removing the
package therefore leaves your profile behind.

### Upstream `LD_LIBRARY_PATH` workaround

The bundle ships its own OpenSSL and libevent next to the `tor` binary, but
neither they nor `tor` carry an RPATH. Without help the loader would resolve
libevent from the host system instead, which is too old for this `tor` and
aborts it immediately with

```txt
tor: symbol lookup error: tor: undefined symbol: evutil_secure_rng_add_bytes
```

The launcher in this package prepends `TorBrowser/Tor` to `LD_LIBRARY_PATH`
so the bundled libraries win. Please do not work around it by installing
host packages or editing `/etc/ld.so.conf.d`; `PKGBUILD` checks both halves of
the contract so a future upstream release that changes the layout fails the
build instead of silently breaking at runtime.

## v13.0.9/

This build is based on Tor Browser's AUR PKGBUILD. So they put the binary
archive under `opt`. And when you run the binary it extracts itself under
`~/.local/opt/tor-browser-unofficial-port`

## Naming

I have changed the name from `tor-browser` to `tor-browser-unofficial-port`

## Resources

* [ooovlad - Tor Browser ARM64 builds][01]
* [tor-browser-build - Mozilla/Tor official build system][04]
* [SourceForge - Tor Browser Ports Files][05]
* [AUR - tor-browser-bin][02]
* [ArchLinux Packages - torbrowser-launcher][03]

[01]: https://github.com/ooovlad/tor-mullvad-aarch64
[02]: https://aur.archlinux.org/packages/tor-browser-bin
[03]: https://archlinux.org/packages/extra/any/torbrowser-launcher/
[04]: https://gitlab.torproject.org/tpo/build/tor-browser-build
[05]: https://sourceforge.net/projects/tor-browser-ports/files/