#!/bin/bash

clear
echo "====================================="
echo "        RENDZZ OFFICIAL"
echo "        AUTO INSTALLER"
echo "====================================="
echo ""
read -p "Masukkan Password: " pass

if [[ "$pass" != "metrickpack2" ]]; then
    echo "❌ Password Salah!"
    exit 1
fi

clear
echo "====================================="
echo "        RENDZZ OFFICIAL MENU"
echo "====================================="
echo "1. Info System"
echo "2. Install Package"
echo "3. Update System"
echo "4. Install Wallpaper"
echo "23. Exit"
echo "====================================="
read -p "Pilih Menu: " menu

if [[ "$menu" == "4" ]]; then
    read -p "Masukkan Link Wallpaper: " wallpaper

    if [[ -z "$wallpaper" ]]; then
        echo "❌ Link tidak boleh kosong!"
        exit 1
    fi

    echo "📥 Downloading wallpaper..."
    mkdir -p /root/wallpaper
    cd /root/wallpaper || exit

    curl -L "$wallpaper" -o wallpaper.jpg

    if [[ ! -f wallpaper.jpg ]]; then
        echo "❌ Gagal download wallpaper!"
        exit 1
    fi

    echo "🖼️ Setting wallpaper..."

    # Set wallpaper untuk GNOME
    export DISPLAY=:0
    export XAUTHORITY=/root/.Xauthority

    gsettings set org.gnome.desktop.background picture-uri "file:///root/wallpaper/wallpaper.jpg"
    gsettings set org.gnome.desktop.background picture-uri-dark "file:///root/wallpaper/wallpaper.jpg"

    echo "====================================="
    echo "✅ Wallpaper berhasil dipasang!"
    echo "     Powered by Rendzz Official"
    echo "====================================="
    exit 0
fi

if [[ "$menu" == "23" ]]; then
    echo "Keluar..."
    exit 0
fi

echo "❌ Menu tidak valid!"
