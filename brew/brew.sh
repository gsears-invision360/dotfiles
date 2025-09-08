print_banner() {
  echo -e "
██╗  ██╗ ██████╗ ███╗   ███╗███████╗██████╗ ██████╗ ███████╗██╗    ██╗
██║  ██║██╔═══██╗████╗ ████║██╔════╝██╔══██╗██╔══██╗██╔════╝██║    ██║
███████║██║   ██║██╔████╔██║█████╗  ██████╔╝██████╔╝█████╗  ██║ █╗ ██║
██╔══██║██║   ██║██║╚██╔╝██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██║███╗██║
██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗██████╔╝██║  ██║███████╗╚███╔███╔╝
╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝
"
}

# Homebrew cheatsheet
# -----------------------------------
# brew install git          Install a package
# brew install git@2.0.0    Install a package with specific version
# brew uninstall git        Uninstall a package
# brew upgrade git          Upgrade a package
# brew unlink git           Unlink
# brew link git             Link
# brew switch git 2.5.0     Change versions
# brew list --versions git  See what versions you have
# --
# brew info git             List versions, caveats, etc
# brew cleanup git          Remove old versions
# brew edit git             Edit this formula
# brew cat git              Print this formula
# brew home git             Open homepage
# --
# brew update               Update brew and cask
# brew list                 List installed
# brew outdated             What’s due for upgrades?
# -----------------------------------

# Installation paths:
#   - /usr/local/Homebrew - Homebrew cloned repository
#   - /usr/local/Cellar   - Homebrew packages
#   - /usr/local/Caskroom - Homebrew casks
#   - /usr/local/opt      - symlinks to manage versioning to Cellar/Caskroom folders
#

install_homebrew() {
  echo -e "
=======================================================================
                         Installing Homebrew
=======================================================================
"
  if  ! command -v brew >/dev/null 2>&1; then
    echo "==> Homebrew not found on system... These dotfiles do not auto install homebrew. Check with system admin for access."
    exit 1
  fi
  echo "==> Homebrew installed. Continuing..."

    if ! grep -q 'export HOMEBREW_CASK_OPTS="--appdir=~/Applications"' ~/.zprofile 2>/dev/null; then
      echo "Setting HOMEBREW_CASK_OPTS to install apps to ~/Applications"
      echo 'export HOMEBREW_CASK_OPTS="--appdir=~/Applications"' >> ~/.zprofile
    fi

    echo "Setting up Homebrew environment..."
    eval "$(brew shellenv)"
}

install_homebrew_taps() {
  echo -e "Tapping to homebrew taps...\n"§
  # Additional taps here: 
  # e.g.
  brew tap mongodb/brew
  # brew tap microsoft/git
  # brew tap hashicorp/tap
}

keep_brew_up_to_date() {
  echo -e "
=======================================================================
                      Upgrading Outdated Plugin
======================================================================="
  brew outdated
  brew update
  brew upgrade
}

_is_comment_or_empty() {
  local line="$1"
  case "$line" in
    ''|\#*) return 0 ;;
    *) return 1 ;;
  esac
}


install_packages() {
  echo -e "
=======================================================================
                      Installing HomeBrew Packages
======================================================================="

  packages_filename='brew/packages.txt'
  
  while read pkg; do
      _is_comment_or_empty "$pkg" && continue

    echo -e "
===================
Installing Package: ${pkg}
===================
"
    # Note, non-interfactively install to avoid stdin issues
    # when called in a loop (from hijacking the packages.txt input)
    # If interaction is needed, remove the redirection... but shouldn't be
    # because it should be an automated install.
    brew install ${pkg} </dev/null

  done < ${packages_filename}
}

# install_casks Function
# -----------------------------------
# Retrieve casks information:
#   - brew search <cask name>
#   - brew cask info <cask name>
# -----------------------------------
install_casks() {
  echo -e "
=======================================================================
                      Installing HomeBrew Casks
======================================================================="

  casks_filename='brew/casks.txt'
  while read cask; do
  # Skip comments and empty lines
    _is_comment_or_empty "$cask" && continue
    # reading each line
    echo -e "
================
Installing Cask: ${cask}
================
"
    brew install --cask ${cask}

  done < ${casks_filename}
}

list_all() {
    echo -e "
Installed Homebrew Packages:
----------------------------"
  brew leaves

  echo -e "
Installed Homebrew Casks:
-------------------------"
  brew list --cask
}

verify_pre_install() {
  read -p "Do you want to install/upgrade Homebrew with additional packages and casks? (y/n): " input
  if [[ ${input} != "y" ]]; then
    echo -e "\n    Nothing has changed.\n"
    exit 0
  fi
}

main() {
  print_banner
  verify_pre_install
  install_homebrew
  install_homebrew_taps
  keep_brew_up_to_date
  install_packages
  install_casks
  list_all

  # Assuming this script was executed via makefile
  echo -e "
====================
Setting up Oh My Zsh
===================="
  source brew/shell/oh-my-zsh-install.sh
  oh_my_zsh_setup_install
  
  # fzf promps and keybindings
  yes | $(brew --prefix fzf)/install


# Add cert files from homebrew for OpenSSL using tools like curl, wget, asdf etc
  echo -e "
=============================
Setting up CA Certs in .zshrc
============================="

  CERT=$(find "$(brew --prefix)" -type f -name cert.pem | head -n1)
  export SSL_CERT_FILE="$CERT"
  if ! grep -q "export SSL_CERT_FILE=\"$CERT\"" ~/.zshrc 2>/dev/null; then
    echo "export SSL_CERT_FILE=\"$CERT\"" >> ~/.zshrc
  fi
}

main "$@"
