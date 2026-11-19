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

Then copy its systemd unit, enable it, and run `topside hooks install` and `topside setup`; the page below has the lines. An AUR package follows once the AUR takes new accounts again. The letter for Linux is at **https://topside.ducban.com/arch/**. Unlike the Mac app, the Arch package is MIT and ships its JavaScript and QML as they are.

## Something broke, or you have an idea

[Open an issue](https://github.com/ducban/topside/issues/new/choose). Say which agent and which terminal; most bugs live in the space between those two.

## What this repo is

The Mac app's source is closed. This repo holds what's public:

| Path | What |
|---|---|
| `index.html`, `img/`, `og.png` | the site at topside.ducban.com (GitHub Pages serves the repo root) |
| `arch/`, `og-arch.png` | the Arch Linux page at topside.ducban.com/arch/ |
| `install.sh` | the macOS installer the site points at |
| `meta/og.html` | the source of `og.png`: open it at 1200 by 630 and take a screenshot |
| Releases | `Topside.zip` and `Topside.zip.sha256` for macOS; release notes for Arch (`arch-v*` tags; the package itself is on npm and the AUR) |
| Issues | bugs and ideas for both platforms |

Built on [agent-notch](https://github.com/realfishsam/agent-notch) (MIT). The agents' logos belong to their owners and only say which agent is running.
