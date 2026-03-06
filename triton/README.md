# Triton

As of 2024-11-10

* [triton][01] library is version `0.9`
* last commit is `b022f3179b3ff6fbafd597099ab0e2f5f07df23a`
* We need [llvm14][09] to compile (actually version 16 or below)
* This package is built with [bitwuzla][04] support
* Compiled for `Python 3.12`

## NOTE TO SELF

Do not make a package for triton or angr, instead use pyenv and install
these packages using PIP

## Resources

* [Triton Library Homepage][06]
* [Github - Triton][01]
* [Github - pyenv][02]
* [Salwans reply for his building parameters on macOS][03]
* [Bitwuzla - SMT solver for the theories of fixed-size bit-vectors, floating-point arithmetic, arrays and uninterpreted functions and their combinations][04]
* [Github - Linux workflow for triton library][05]
* [ArchLinux VCS package guidelines][07]
* [Quarkslab Triton Blog Posts][08]

[01]: https://github.com/JonathanSalwan/Triton/
[02]: https://github.com/pyenv/pyenv
[03]: https://github.com/JonathanSalwan/Triton/issues/1308#issuecomment-1947887926
[04]: https://bitwuzla.github.io/
[05]: https://github.com/JonathanSalwan/Triton/blob/master/.github/workflows/linux.yml
[06]: https://triton-library.github.io/
[07]: https://wiki.archlinux.org/title/VCS_package_guidelines
[08]: https://blog.quarkslab.com/tag/triton.html
[09]: https://archlinux.org/packages/extra/x86_64/llvm14/
