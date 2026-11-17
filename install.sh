#!/bin/sh
# Installs Topside: downloads the latest release, checks it, and puts
# Topside.app in /Applications.
#
#   curl -fsSL https://topside.ducban.com/install.sh | sh
#
# Nothing here needs sudo. To remove Topside: switch its integrations off
# in Settings, quit it, and delete /Applications/Topside.app.
set -eu

REPO="${TOPSIDE_REPO:-ducban/topside}"
BASE="${TOPSIDE_BASE_URL:-https://github.com/$REPO/releases/latest/download}"
TARGET="${TOPSIDE_INSTALL_DIR:-/Applications}"

fail() {
  echo "install: $1" >&2
  exit 1
}

[ "$(uname -s)" = "Darwin" ] || fail "Topside runs on macOS only"
[ "$(uname -m)" = "arm64" ] || fail "Topside needs a Mac with Apple silicon"
major="$(sw_vers -productVersion | cut -d. -f1)"
[ "$major" -ge 14 ] || fail "Topside needs macOS 14 or later (this is $(sw_vers -productVersion))"
[ -w "$TARGET" ] || fail "can't write to $TARGET; set TOPSIDE_INSTALL_DIR to a folder you own"

staged="$TARGET/.Topside.app.new"
previous="$TARGET/.Topside.app.old"
# An install that was cut off during the swap further down left the last working app in
# $previous, with no app in place or with a new one nobody checked: put the old one back
# first, before a download that can fail. Only beside an app that verifies is $previous a
# leftover.
if [ -e "$previous" ]; then
  if [ ! -e "$TARGET/Topside.app" ] || ! codesign --verify --deep "$TARGET/Topside.app" 2>/dev/null; then
    rm -rf "$TARGET/Topside.app"
    mv "$previous" "$TARGET/Topside.app" || fail "couldn't restore the app an earlier install moved aside"
  fi
fi
rm -rf "$staged" "$previous"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

echo "Downloading Topside…"
curl -fsSL "$BASE/Topside.zip" -o "$work/Topside.zip" || fail "download failed"
curl -fsSL "$BASE/Topside.zip.sha256" -o "$work/Topside.zip.sha256" || fail "checksum download failed"

# The checksum file names Topside.zip, so it's checked from inside the folder.
(cd "$work" && shasum -a 256 -c Topside.zip.sha256 >/dev/null) || fail "the download doesn't match its checksum"

ditto -x -k "$work/Topside.zip" "$work/unpacked"
[ -d "$work/unpacked/Topside.app" ] || fail "the archive holds no Topside.app"
codesign --verify --deep "$work/unpacked/Topside.app" || fail "the app's signature is broken"

# The new app is copied beside the old one and checked there, and only then swapped in, so a
# copy that fails halfway leaves the installed app as it was.
if ! ditto "$work/unpacked/Topside.app" "$staged" || ! codesign --verify --deep "$staged"; then
  rm -rf "$staged"
  fail "couldn't copy the app to $TARGET; the installed one is untouched"
fi

if pgrep -x Topside >/dev/null 2>&1; then
  echo "Quitting the running Topside…"
  pkill -x Topside || true
  sleep 1
fi
if [ -e "$TARGET/Topside.app" ]; then
  mv "$TARGET/Topside.app" "$previous" || { rm -rf "$staged"; fail "couldn't move the installed app aside"; }
fi
if ! mv "$staged" "$TARGET/Topside.app"; then
  [ -e "$previous" ] && mv "$previous" "$TARGET/Topside.app"
  rm -rf "$staged"
  fail "couldn't put the new app in place; the old one is back"
fi
# The old app goes only once the new one is in place and still whole.
if ! codesign --verify --deep "$TARGET/Topside.app"; then
  rm -rf "$TARGET/Topside.app"
  [ -e "$previous" ] && mv "$previous" "$TARGET/Topside.app"
  fail "the new app didn't survive the move; the old one is back"
fi
rm -rf "$previous"

echo "Installed $TARGET/Topside.app"
# TOPSIDE_NO_OPEN=1 installs without starting the app.
if [ -z "${TOPSIDE_NO_OPEN:-}" ]; then
  open "$TARGET/Topside.app"
  echo "Topside is at the top of your screen. Hover it, click the gear, and switch on your agents under Integrations."
fi
