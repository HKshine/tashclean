#!/bin/bash

TRASH_DIR="$HOME/.local/share/Trash"
FILES_DIR="$TRASH_DIR/files"
INFO_DIR="$TRASH_DIR/info"
clear

figlet "Clean"

# Função para exibir arquivos na lixeira
list_trash() {
    echo "🗑️ Arquivos na Lixeira:"
    ls -lah "$FILES_DIR"
}

# Função para restaurar um arquivo específico
restore_file() {
    echo "Digite o nome do arquivo que deseja restaurar:"
    read filename

    if [ -f "$FILES_DIR/$filename" ]; then
        orig_path=$(grep "Path=" "$INFO_DIR/$filename.trashinfo" | cut -d'=' -f2)
        if [ -z "$orig_path" ]; then
            orig_path="$HOME/RestoredFiles/"
            mkdir -p "$orig_path"
        fi

        mv "$FILES_DIR/$filename" "$orig_path"
        rm "$INFO_DIR/$filename.trashinfo" 2>/dev/null
        echo "✅ Arquivo restaurado para: $orig_path"
    else
        echo "❌ Arquivo não encontrado na lixeira."
    fi
}

# Função para esvaziar a lixeira
empty_trash() {
    echo "⚠️ Tem certeza que deseja esvaziar a lixeira? (s/n)"
    read confirm
    if [ "$confirm" == "s" ]; then
        rm -rf "$FILES_DIR"/*
        rm -rf "$INFO_DIR"/*
        echo "✅ Lixeira esvaziada!"
    else
        echo "❌ Ação cancelada."
    fi
}

# Menu principal
echo "📌 Gerenciador de Lixeira"
echo "1️⃣ Ver arquivos na lixeira"
echo "2️⃣ Restaurar um arquivo"
echo "3️⃣ Esvaziar a lixeira"
echo "4️⃣ Sair"
read -p "Escolha uma opção: " option

case $option in
    1) list_trash ;;
    2) restore_file ;;
    3) empty_trash ;;
    4) echo "🚪 Saindo..." && exit ;;
    *) echo "❌ Opção inválida!" ;;
esac
