## Updating vendored submodules

`modules/oh-my-zsh`, `modules/zsh-autosuggestions`,
`modules/zsh-syntax-highlighting`, and `modules/vim-plug` are pinned
submodules, not auto-updated. To bump one to the latest upstream master,
review what changed, then commit the submodule pointer bump:

```
git clone --recurse-submodules git@github.com:phdelodder/dotfiles.git
git submodule update --remote modules/oh-my-zsh
git submodule update --remote modules/zsh-autosuggestions
git submodule update --remote modules/zsh-syntax-highlighting
git submodule update --remote modules/vim-plug
```

`starship` itself isn't vendored — it's installed via `apt-get` in
`bootstrap.sh` and updates through the system package manager.
