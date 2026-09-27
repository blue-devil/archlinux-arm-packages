# ILSpy

ILSpy desktop UI (Avalonia) + ReadyToRun plugin, published self-contained
(bundled .NET 10 runtime), laid out exactly like upstream's deb/rpm
(BuildTools/packaging/linux): /opt/ilspy + /usr/bin/ilspy + desktop entry.

Upstream only ships linux-x64; this PKGBUILD adds linux-arm64 (aarch64) via
a two-line RuntimeIdentifiers patch. Nothing in the dependency graph is
x64-specific (SkiaSharp/HarfBuzzSharp natives and the runtime pack all ship
linux-arm64 builds).

Build requirements (see global.json: SDK 11.0.0, rollForward=major, so a
10.x SDK will NOT do). On Arch / Arch Linux ARM these come from the AUR:

* `dotnet-sdk-preview-bin`: (pkgbase dotnet-core-preview-bin, provides dotnet-sdk=11.0)
* `powershell-bin`: (provides powershell; pwsh is called by MSBuild targets
  BuildTools/update-assemblyinfo.ps1 and sort-resx.ps1)

NuGet restore needs network access inside build().
Tip: set NUGET_PACKAGES to a persistent directory to reuse the package cache
across rebuilds (default is an isolated cache under $srcdir).

## Versioning

Upstream version scheme: Major.Minor.Build.Revision, where Revision is
`git rev-list --count d779383cb85003d6dabeb976f0845631e07bf463..<tag>` + 1
(BuildTools/update-assemblyinfo.ps1). For v11.1 that is 9782, matching the
official ILSpy_linux-x64_11.1.0.9782.zip release asset.

## Source

Git (not a tarball) on purpose: update-assemblyinfo.ps1 derives the revision
number and commit hash from git, so the About dialog shows the same
`11.1.0.9782+a6909b2e` as the official release. The ILSpy-tests submodule is
only used by the unit tests and is deliberately not fetched.

`linux-arm64-rid.patch` adds linux-arm64 to `<RuntimeIdentifiers>` of
ILSpy.csproj and ILSpy.ReadyToRun.csproj (the two RID-specifically published
projects). Hunk bodies keep the upstream CRLF line endings, so regenerate it
with `diff -u` on the raw files, not `git diff` (which normalises them away).

## Runtime dependencies

The .NET runtime is bundled, so `depends` only lists what the bundled native
libraries link (DT_NEEDED) or dlopen at run time:

* coreclr -> glibc, gcc-libs
* SkiaSharp -> fontconfig
* Avalonia.X11 -> libx11, libxext, libxrandr, libxi, libxcursor, libxfixes, libsm, libice
* runtime PAL -> icu, openssl, krb5
* xdg-utils for opening links

`optdepends`: libglvnd (OpenGL rendering, software fallback otherwise), gtk3
(GTK dialogs/tray fallback when no portal is available), lttng-ust2.12
(CoreCLR tracepoint provider; the only consumer of liblttng-ust.so.0).

`options=('!strip' '!debug')`: stripping the bundled coreclr / SkiaSharp
shared objects breaks them (upstream's rpm spec disables `__os_install_post`
for the same reason).

## Build environment (build())

* `DOTNET_CLI_USE_MSBUILD_SERVER=false`, `MSBUILDDISABLENODEREUSE=1`: do not
  leave MSBuild / Roslyn server processes behind after makepkg
  (`dotnet build-server shutdown` at the end is the safety net).
* `OPENSSL_ENABLE_SHA1_SIGNATURES=1`: same as upstream build.ps1 / publish.ps1
  (SHA-1 strong-name signatures on OpenSSL 3).
* `BUILD_SOURCEBRANCHNAME=master`: makepkg checks the tag out on a branch
  literally named "makepkg"; update-assemblyinfo.ps1 would embed that as
  "-makepkg" in the version string. It honours this variable first, and
  master/release/* map to no suffix.
* `DOTNET_CLI_HOME` and `NUGET_PACKAGES` default to directories under
  `$srcdir` so the build does not touch `$HOME`.

## Publish arguments

The two `dotnet publish` calls mirror upstream `publish.ps1 -Platform linux`,
with the RID mapped from `$CARCH` (aarch64 -> linux-arm64, x86_64 -> linux-x64).

* `-p:RestoreEnablePackagePruning=false`: upstream restore.ps1 / CI pass this too.
* `-p:RestoreLockedMode=false`: ICSharpCode.Decompiler / ILSpyX /
  BamlDecompiler restore in locked mode and NuGet propagates the app's RIDs
  down the project graph, so their packages.lock.json need a new (empty)
  linux-arm64 section. Let restore add it instead of failing with NU1004. All
  package versions are pinned centrally in Directory.Packages.props, so
  nothing else can float.
* `-p:DebugType=none -p:DebugSymbols=false`: upstream's deb/rpm/zip ship
  without .pdb files. Not generating them also keeps the absolute `$srcdir`
  .pdb path out of the assemblies' debug directory (makepkg would otherwise
  warn "Package contains reference to $srcdir").

## Packaging notes (package())

* The `*.pdb` delete is a safety net for .pdb files that third-party NuGet
  packages may ship.
* nupkg extraction leaves most files at 0744; they are normalised to 0644 and
  the exec bit is given only to the two real executables: the `ILSpy` apphost
  and the `createdump` crash-dump helper.
* Desktop entry and icon are the same files upstream puts in the deb/rpm
  (BuildTools/packaging/linux/ilspy.desktop, ilspy.png).

## Known namcap output

Expected for a self-contained .NET bundle and not actionable:

* `E: ELF files outside of a valid path ('opt/')`
* `W: ... lacks FULL RELRO` / `is unstripped` (prebuilt runtime natives, see `!strip`)
* `W: Reference to x86_64 should be changed to $CARCH` (the `case "$CARCH"` RID map)

