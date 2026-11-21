# Topside

Every agent, one notch. An island on the Mac's notch for Claude Code, Codex CLI, pi and omp: it shows which session wants an answer, takes the answer, and jumps to the session's terminal.

The letter that explains it is at **https://topside.ducban.com**.

## Install (macOS 14 or later, Apple silicon)

```sh
curl -fsSL https://topside.ducban.com/install.sh | sh
```

No `sudo`. [install.sh](./install.sh) downloads the latest release from this repo, checks it against its SHA-256, verifies the signature and swaps the app into `/Applications`. Read it first; it's short.

To remove Topside: switch its integrations off in Settings, quit it, and delete `/Applications/Topside.app`.

## Install (Arch Linux)

```sh
sudo npm install -g topside-arch
```

Then run `topside login on` (it writes the daemon's unit and starts it), `topside hooks install` and `topside setup`. To upgrade, run the npm line again and `topside setup`. An AUR package follows once the AUR takes new accounts again. The letter for Linux is at **https://topside.ducban.com/arch/**. Unlike the Mac app, the Arch package is MIT and ships its JavaScript and QML as they are.

## Something broke, or you have an idea

[Open an issue](https://github.com/ducban/topside/issues/new/choose). Say which agent and which terminal; most bugs live in the space between those two.

## What this repo is

The Mac app's source is closed. This repo holds what's public:

| Path | What |
|---|---|
| `index.html`, `img/`, `og.png` | the site at topside.ducban.com (GitHub Pages serves the repo root). Its header draws the logo and a DEPARTURES strip of four sample sessions as split flaps in HTML and CSS, riffled by the page's script (still with reduced motion); the strip is sample data, never anyone's sessions |
| `arch/`, `og-arch.png` | the Arch Linux page at topside.ducban.com/arch/ |
| `install.sh` | the macOS installer the site points at |
| `scripts/bump.sh` | `scripts/bump.sh mac\|arch <version>` after a release: rewrites every `<span data-version>` and that page's `softwareVersion`, then lists lines that still name the old version |
| `meta/og.html` | the source of `og.png`: open it at 1200 by 630 and take a screenshot |
| `favicon.ico`, `apple-touch-icon.png`, `img/icon*` | the app icon for the web, and `img/topside-logo.svg`, `img/favicon.svg`: copied from the private repo's `assets/brand/web/` and `assets/brand/logo/` (drawn by its `scripts/make-brand.py`) |
| Releases | `Topside.zip` and `Topside.zip.sha256` for macOS; release notes for Arch (`arch-v*` tags; the package itself is on npm and the AUR) |
| Issues | bugs and ideas for both platforms |

Built on [agent-notch](https://github.com/realfishsam/agent-notch) (MIT). The agents' logos belong to their owners and only say which agent is running.
