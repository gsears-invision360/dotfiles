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
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf plugin add yarn
    echo -e "\nAdding packages... Done."
}

install_asdf() {
    # Prefer an already-available `asdf` in PATH
    if command -v asdf >/dev/null 2>&1; then
        echo "asdf found in PATH"
    else
        # Try the user's ~/.asdf
        if [ -f "$HOME/.asdf/asdf.sh" ]; then
            # shellcheck source=/dev/null
            source "$HOME/.asdf/asdf.sh"
        else
            # If Homebrew exists, try the actual brew prefixes (formula-specific first)
            if command -v brew >/dev/null 2>&1; then
                BREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
                ASDF_FORMULA_PREFIX="$(brew --prefix asdf 2>/dev/null || true)"

                candidates=(
                    "$ASDF_FORMULA_PREFIX/libexec/asdf.sh"
                    "$BREW_PREFIX/opt/asdf/libexec/asdf.sh"
                    "$BREW_PREFIX/share/asdf/asdf.sh"
                )

                for f in "${candidates[@]}"; do
                    if [ -n "$f" ] && [ -f "$f" ]; then
                        # shellcheck source=/dev/null
                        source "$f"
                        break
                    fi
                done
            fi
        fi
    fi

    if ! command -v asdf >/dev/null 2>&1; then
        echo "Error: asdf not found in PATH and no asdf.sh could be sourced."
        echo "If you installed asdf via Homebrew, restart your shell or run:"
        echo "  eval \"\$(brew shellenv)\""
        echo "and then source the asdf script, for example:"
        echo "  source \"\$(brew --prefix asdf)/libexec/asdf.sh\""
        return 1
    fi

    add_asdf_packages

    # Add shims to PATH if not already added
    echo -e "\nAdding shims to PATH..."
    if ! grep -q 'ASDF_DATA_DIR' ~/.zprofile 2>/dev/null; then
        echo 'export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"' >> ~/.zprofile
    fi
    if ! grep -q 'ASDF_DATA_DIR' ~/.zshrc 2>/dev/null; then
        echo 'export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"' >> ~/.zshrc
    fi
    echo -e "Adding shims to PATH in .zprofile and .zshrc... Done."

    echo -e "\nInstalling global .tool-versions..."
    asdf install
    echo -e "Installing asdf... Done."
    asdf list || true
}

main() {
    print_banner
    install_asdf
}

main "$@"