# Tizonia

Tizonia is the best command line utility for listening youtube without
videos loading. For a long time I cannot use it because evet it compiles
without a problem it `core dumps`:

```txt
tizonia --youtube-audio-mix-search "daft punk"
tizonia 0.22.0. Copyright (C) 2020 Juan A. Rubio and contributors
This software is part of the Tizonia project <https://tizonia.org>

Fatal glibc error: malloc.c:2371 (sysmalloc): assertion failed: (old_top == initial_top (av) && old_size == 0) || ((unsigned long) (old_size) >= MINSIZE && prev_inuse (old_top) && ((unsigned long) old_end & (pagesize - 1)) == 0)
[1]    924328 abort (core dumped)  tizonia --youtube-audio-mix-search "daft punk"
```

Thing done:

* Fixed the error above
* Remove deprecated youtube-dl dependency
* Now depends on yt-dlp
* Added functionality which reads youtube netscape style cookies directly
  from `~/.config/tizonia/youtube-cookies.txt`

## patch: `fix-sizeof-symbol-interposition.patch`

The `malloc` crash (sysmalloc: old_top assertion) was heap corruption from
`symbol interposition`: `libtizonia`'s `class_ctor()` called its own exported
`sizeOf()` via an interposable `GOT` slot, which resolved to graphviz's
`sizeOf` in libgvc.so.7 (pulled in via `libmediainfo`). It returned `0xEFEF`
instead of 64, so the inheritance memcpy copied ~61 KB into a 64-byte class
object during `tiz_os_register_base_types()`.

Solved with `fix-sizeof-symbol-interposition.patch` — builds `libtizonia` with
`-Wl,-Bsymbolic-functions` in `libtizonia/src/meson.build`, binding its
self-references at link time.

## patch: `fix-youtubeproxy-ytdlp-joblib.patch`

The notorious `youtube-dl` python module was deprecated. So I made yt-dlp
work with tizonia with this patch. And also auto-loads
`~/.config/tizonia/youtube-cookies.txt` for the yt's bot-check.

## patch: `fix-python-thefuzz.patch`

The python module `fuzzywuzzy` is a deprecated python module. Same developer
offer a new updated module: `thefuzz`. So this patch removes old module
and places new `thefuzz` module.

## Getting Proper Cookies

I am using [Cookie Editor][02]. When you click Cookie Editor while your are
on Youtube tab:

* Click export button.
* It asks some options and click on "Netscape". It opies to clipboard.
* Save it under `~/.config/tizonia/youtube-cookies.txt`

So that tizonia automatically finds your cookies.

## Resources

* [Tizonia Homepage][01]
* [Github - tizonia-openmax-il][04]
* [Cookie Editor Homapage][03]

[01]: https://tizonia.org/
[04]: https://github.com/tizonia/tizonia-openmax-il
[02]: https://addons.mozilla.org/en-US/firefox/addon/cookie-editor/
[03]: https://cookie-editor.com/
