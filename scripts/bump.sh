#!/bin/sh
# Point the site at a new release: scripts/bump.sh mac|arch <version>
#
# Rewrites every <span data-version="mac|arch"> on the three pages and the
# softwareVersion in that platform's JSON-LD, then lists any other line that
# still names the old version. Those are prose ("everything in 0.1.2") and
# need a person, so the script only points at them. It commits nothing.
set -eu

cd "$(dirname "$0")/.."

platform=${1:-}
version=${2:-}
case $platform in
  mac) page=index.html ;;
  arch) page=arch/index.html ;;
  *) echo "usage: scripts/bump.sh mac|arch <version>" >&2; exit 64 ;;
esac
if ! printf '%s' "$version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "bump: '$version' isn't a version like 0.2.5" >&2
  exit 64
fi

old=$(sed -n 's/.*"softwareVersion": "\([^"]*\)".*/\1/p' "$page")
if [ -z "$old" ]; then
  echo "bump: no softwareVersion in $page" >&2
  exit 1
fi
if [ "$old" = "$version" ]; then
  echo "bump: $page already says $version"
  exit 0
fi

pages="index.html arch/index.html docs/index.html arch/docs/index.html"
for file in $pages; do
  sed -i '' "s|<span data-version=\"$platform\">[^<]*</span>|<span data-version=\"$platform\">$version</span>|g" "$file"
done
sed -i '' "s|\"softwareVersion\": \"$old\"|\"softwareVersion\": \"$version\"|" "$page"

echo "bump: $platform $old -> $version"
grep -c "data-version=\"$platform\">$version<" $pages | sed 's/^/  marked: /'

# A dot in a version is a regex wildcard, so escape it before searching.
pattern=$(printf '%s' "$old" | sed 's/\./\\./g')
left=$(grep -n "$pattern" $pages || true)
if [ -n "$left" ]; then
  echo "bump: these lines still say $old; read them and decide:"
  printf '%s\n' "$left" | cut -c1-160 | sed 's/^/  /'
fi
