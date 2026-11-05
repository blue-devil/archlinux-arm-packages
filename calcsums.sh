#!/usr/bin/env bash
#
# calcsums.sh - generate makepkg-compatible sha256sums/b2sums for a git source
#
# Replicates pacman's calc_checksum_git (makepkg >= 7.0, git.sh):
#   git -c core.abbrev=no -C <repo> archive --format=tar <tag|commit> | <integ>sum
#
# git archive output is deterministic for a given commit (uid/gid 0,
# mtime = commit time, pax global header = commit id), so the sums are
# stable across machines and identical to what `makepkg -g` generates
# and what makepkg verifies on build.
#
# Usage:
#   calcsums.sh [repo-dir] [ref]
#
#   repo-dir  path to the git clone; a bare mirror clone (SRCDEST) works too
#             default: ./metasploit-framework
#   ref       tag or commit hash to archive
#             default: pkgver parsed from ./PKGBUILD
#
# Examples:
#   ./calcsums.sh
#   ./calcsums.sh ./metasploit-framework 6.5.8
#
# stdout: ready-to-paste PKGBUILD arrays; info messages go to stderr.

set -euo pipefail

die() { printf 'calcsums.sh: error: %s\n' "$*" >&2; exit 1; }
usage() { sed -n '2,/^$/s/^#\( \|$\)//p' "$0"; }

[[ ${1:-} == -h || ${1:-} == --help ]] && { usage; exit 0; }

repo=${1:-./metasploit-framework}
ref=${2:-}

[[ -d $repo ]] || die "repo dir not found: $repo"
git -c safe.bareRepository=all -C "$repo" rev-parse --git-dir >/dev/null 2>&1 \
	|| die "not a git repository: $repo"

if [[ -z $ref ]]; then
	[[ -r ./PKGBUILD ]] || die "no ref given and no PKGBUILD in $(pwd)"
	ref=$(sed -n 's/^pkgver=//p' ./PKGBUILD | head -n1)
	[[ -n $ref ]] || die "could not parse pkgver from ./PKGBUILD"
fi

git -c safe.bareRepository=all -C "$repo" rev-parse -q --verify "${ref}^{commit}" >/dev/null \
	|| die "ref '$ref' not found in $repo (try: git -C '$repo' fetch --all --tags)"

commit=$(git -c safe.bareRepository=all -C "$repo" rev-parse "${ref}^{commit}")

printf 'repo:   %s\nref:    %s\ncommit: %s\n' "$(realpath "$repo")" "$ref" "$commit" >&2

# same pipeline makepkg runs in calc_checksum_git
sha256=$(git -c safe.bareRepository=all -c core.abbrev=no -C "$repo" archive --format=tar "$ref" | sha256sum)
b2=$(git -c safe.bareRepository=all -c core.abbrev=no -C "$repo" archive --format=tar "$ref" | b2sum)

printf "sha256sums=('%s')\n" "${sha256%% *}"
printf "b2sums=('%s')\n" "${b2%% *}"
