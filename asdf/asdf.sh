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
    asdf plugin-add python
    # asdf plugin-add dotnet
    
    echo -e "\nAdding packages... Done."
}

install_asdf() {

    # Install from git because has issues with brew install
    brew deps asdf | xargs -L1 brew install
   
    echo -e "\nInstalling asdf..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2

   

    #  chmod +x ~/.asdf/asdf.sh
    source ~/.zshrc
  
    add_asdf_packages
    asdf install
    echo -e "Installing asdf... Done."
}

# TODO: Auto install versions for node yarn etc
# asdf install java openjdk-18
# asdf install nodejs lts-gallium
# 

main() {
    print_banner
    install_asdf
}

main "$@"