# vdhcoapp - DownloadHelper CoApp

Firefox's add-on [Video DownloadHelper][07] does not work without this
companion app. So we have to install it in our system.

*DownloadHelper CoApp* is a multi-platform (Windows, Mac, Linux) application
providing the [Video DownloadHelper][07]
browser add-on with a set of extra features not available directly
from the add-on:

* file writing API
* launching default video player application on a data file
* a build of the [ffmpeg][04] video converter

*DownloadHelper CoApp* complies with the
[Mozilla Web Docs - Native messaging ][06]
and is not intended to be used directly from the command line.

Installer executables for the various platforms are available
from the [releases page][05].

## Note about the registration process

After the app is installed, the coapp installs a json file into
browser-specific directories, as described by the Mozilla, Google
and Microsoft documentation:

* [Mozilla Web Docs - Native manifests][01]
* [Mozilla Web Docs - Native manifests host location][02]
* [MSDN - Native messaging][03]

You can see the list of files installed by running `vdhcoapp install`.
Those files can be remove with `vdhcoapp uninstall`.

[01]: https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_manifests
[02]: https://developer.chrome.com/docs/extensions/mv3/nativeMessaging/#native-messaging-host-location
[03]: https://learn.microsoft.com/en-us/microsoft-edge/extensions-chromium/developer-guide/native-messaging?tabs=v3%2Cwindows
[04]: http://ffmpeg.org/
[05]: https://github.com/aclap-dev/vdhcoapp/releases
[06]: https://developer.mozilla.org/en-US/Add-ons/WebExtensions/Native_messaging
[07]: https://downloadhelper.net/
