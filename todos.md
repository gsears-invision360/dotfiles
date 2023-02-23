- Fira Code
  brew tap homebrew/cask-fonts
  brew install --cask font-fira-code

- Bitwarden-cli
- wget before zsh (not installing from neat brew)
- Serverless
- gpg
- fzf
- gawk
- gh
- graphviz
- awscli

- oh my zsh // Ordering... uninstall duff .oh-my-zsh folder
- set...

- set path for neovim installed with asdf ?
- asdf which nvim

- asdf for node version not brew
- .zsh not really linked correctly with this repo version
- - add asdf plugins

npm yarn install

- corepack enable
- corepack prepare yarn@stable --activate
- asdf reshim nodejs

npm update
for ver in ~/.asdf/installs/nodejs/\*/bin; do cd $ver; if [ -f ../.npm/bin/npm ]; then ln -nfs ../.npm/bin/npm npm; ln -nfs ../.npm/bin/npx npx; fi done

docker - login

anaconda etc install
