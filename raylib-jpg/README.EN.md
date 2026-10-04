# raylib-jpg

- Official `raylib` 6.0 has `SUPPORT_FILEFORMAT_JPG 0` in `src/config.h`: `LoadImage("x.jpg")` fails.
  PNG, GIF, BMP, QOI and DDS are already on. Only JPG was missing.
- `raylib-enable-jpg.patch` is the same patch used by `x86_64-linux-gnu-raylib`,
  `i686-linux-gnu-raylib` and `mingw-w64-raylib`, so all targets load the same formats.
- Rest of the PKGBUILD is the official one, plus `libxi` in makedepends.
- `provides=raylib` / `conflicts=raylib`: remove the official package first
  (`pacman -Rdd raylib`), then install this one.
- Still disabled upstream: TGA, PSD.
