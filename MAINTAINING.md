## Updating vendored submodules

`modules/oh-my-zsh` and `modules/powerlevel10k` are pinned submodules, not
auto-updated. To bump them to the latest upstream master, review what
changed, then commit the submodule pointer bump:

```
git clone --recurse-submodules git@github.com:phdelodder/dotfiles.git
git submodule update --remote modules/oh-my-zsh
git submodule update --remote modules/powerlevel10k
```
