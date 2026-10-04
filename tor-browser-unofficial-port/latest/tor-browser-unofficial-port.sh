#!/bin/sh
# start-tor-browser refuses to run when invoked through a symlink, so call it by its real path.
bundledir=/opt/tor-browser-unofficial-port

# The bundle ships its own libevent and OpenSSL for tor, but neither carries an
# RPATH. Without this the loader resolves libevent from the host, which is too
# old for tor and aborts it with an undefined evutil_secure_rng_add_bytes.
LD_LIBRARY_PATH="${bundledir}/TorBrowser/Tor${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
export LD_LIBRARY_PATH

exec "${bundledir}/start-tor-browser" "$@"