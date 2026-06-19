# install.sh

install_aliases() {
    local url="https://raw.githubusercontent.com/indrahulu/linux-aliases/refs/heads/master/aliases.bash"
    local target="$HOME/.bash_aliases"
    local tmp

    tmp="$(mktemp)" || return 1

    echo "Mengambil daftar alias..."
    curl -fsSL "$url" -o "$tmp" || {
        echo "Gagal download alias."
        rm -f "$tmp"
        return 1
    }

    echo "Mengecek syntax..."
    bash -n "$tmp" || {
        echo "File alias mengandung error syntax."
        rm -f "$tmp"
        return 1
    }

    if [ -f "$target" ]; then
        cp "$target" "$target.bak.$(date +%Y%m%d%H%M%S)"
        echo "Backup lama dibuat."
    fi

    mv "$tmp" "$target"

    if ! git config --global --get alias.fta >/dev/null 2>&1; then
        git config --global alias.fta 'fetch --all'
        echo "Git alias fta ditambahkan."
    fi

    if ! grep -qF '. ~/.bash_aliases' "$HOME/.bashrc" 2>/dev/null; then
        cat >> "$HOME/.bashrc" <<'EOF'

# Load personal aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOF
    fi

    . "$target"

    echo "Alias sudah dipasang dan aktif."
}

install_aliases
unset -f install_aliases
