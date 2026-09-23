## What's in here

- `.zshrc` — zsh config via [oh-my-zsh](modules/oh-my-zsh) with [zsh-autosuggestions](modules/zsh-autosuggestions) and [zsh-syntax-highlighting](modules/zsh-syntax-highlighting) (vendored as git submodules)
- `starship.toml` — prompt config for [starship](https://starship.rs), symlinked to `~/.config/starship.toml`
- `.vimrc` — vim settings, with [vim-plug](modules/vim-plug) (vendored as a git submodule) as the plugin manager
- `.gitconfig` / `.gitignore_global` — git config, installed to `~/.gitconfig` and referenced via `core.excludesfile`
- `.local/share/fonts/NerdFonts` — Nerd Font, symlinked into `~/.local/share/fonts`

## Installation Steps

```
sudo apt install git -y
git clone --recursive https://github.com/phdelodder/dotfiles.git .dotfiles
cd .dotfiles
./bootstrap.sh
```

`bootstrap.sh` is safe to re-run (e.g. after pulling changes) — it installs
`zsh`/`vim` via `apt-get` if they're missing (Debian/Ubuntu only; on other
systems, install them yourself first), symlinks config files/directories
into place, sets up `~/.gitconfig`, and switches your default shell to zsh.

Options:

```
-n, --git_name <name>    Set the git user.name (skips the interactive prompt)
-e, --git_email <email>  Set the git user.email (skips the interactive prompt)
--chsh                   Skip changing the default shell to zsh
```

## Unattended / automated runs (e.g. Ansible)

`bootstrap.sh` is safe to run non-interactively as long as `-n`/`--git_name`
and `-e`/`--git_email` are always passed — without a TTY it fails fast with
a clear error instead of hanging on the interactive prompt. Package
installs (`apt-get`) run with `DEBIAN_FRONTEND=noninteractive` and skip
`sudo` automatically when already running as root, so it works the same
whether invoked directly as the target user or via a `become: true` task.

The one thing worth handling at the Ansible layer instead: `chsh` (called
unless `--chsh` is passed) changes the shell of whichever user the script
is running as, not a named target user. If your play runs as root via
`become`, pass `--chsh` to skip it and set the login shell with Ansible's
own `user` module (`shell: /usr/bin/zsh`) instead.

## Updating

See [MAINTAINING.md](MAINTAINING.md) for bumping vendored submodules to
their latest upstream versions.

## Additional Steps for WSL

Download https://github.com/phdelodder/dotfiles/blob/master/.local/share/fonts/NerdFonts/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf
