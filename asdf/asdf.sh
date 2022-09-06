#!/bin/bash

# Title         asdf.sh
# Description   Install asdf plugins
# Author        Gareth Sears <garethsears@gmail.com>
#=====================================================

print_banner() {
    echo -e "
 █████╗ ███████╗██████╗ ███████╗
██╔══██╗██╔════╝██╔══██╗██╔════╝
███████║███████╗██║  ██║█████╗  
██╔══██║╚════██║██║  ██║██╔══╝  
██║  ██║███████║██████╔╝██║     
╚═╝  ╚═╝╚══════╝╚═════╝ ╚═╝             
"
}

add_asdf_packages() {
    echo -e "\nAdding packages"
    asdf plugin-add java https://github.com/halcyon/asdf-java.git
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf plugin-add yarn
    echo -e "\nAdding packages... Done."
}

install_asdf() {
    echo -e "\nInstalling asdf..."
    brew install asdf
    source ~/.zshrc
    add_asdf_packages
    asdf install
    echo -e "Installing asdf... Done."
}

main() {
    print_banner
    install_asdf
}

main "$@"