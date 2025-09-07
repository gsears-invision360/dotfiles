# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/g.sears/Applications/Homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/g.sears/Applications/Homebrew/opt/fzf/bin"
fi

source <(fzf --zsh)