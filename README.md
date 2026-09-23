## What's in here

- `.zshrc` / `.p10k.zsh` — zsh config via [oh-my-zsh](modules/oh-my-zsh) with the [powerlevel10k](modules/powerlevel10k) theme (both vendored as git submodules)
- `.vimrc` — vim settings
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

## Updating

See [MAINTAINING.md](MAINTAINING.md) for bumping the oh-my-zsh and
powerlevel10k submodules to their latest upstream versions.

## Additional Steps for WSL

Download https://github.com/phdelodder/dotfiles/blob/master/.local/share/fonts/NerdFonts/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf
