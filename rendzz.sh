#!/bin/bash

PTERO_DIR="/var/www/pterodactyl"
BG_URL="https://files.catbox.moe/z32ox4.jpg"

echo "🔥 INSTALLING RENDZZ OFFICIAL THEME 🔥"

# 1. Download Background
mkdir -p $PTERO_DIR/public/rendzz
curl -L $BG_URL -o $PTERO_DIR/public/rendzz/bg.jpg

# 2. Inject CSS Theme
cat << 'EOF' >> $PTERO_DIR/resources/css/app.css

/* =========================
   RENDZZ OFFICIAL THEME
========================= */

body {
    background: url('/rendzz/bg.jpg') no-repeat center center fixed;
    background-size: cover;
    position: relative;
}

body::before {
    content: "";
    position: fixed;
    inset: 0;
    backdrop-filter: blur(10px);
    background: rgba(0, 0, 0, 0.75);
    z-index: -1;
}

.bg-neutral-700,
.bg-neutral-800,
.bg-neutral-900 {
    background: rgba(20, 20, 20, 0.80) !important;
    backdrop-filter: blur(12px);
    border-radius: 14px;
}

button,
.bg-primary-500 {
    background: #ff0000 !important;
    border: none !important;
}

button:hover {
    background: #cc0000 !important;
}

nav {
    background: rgba(0, 0, 0, 0.85) !important;
}

h1, h2, h3, h4 {
    color: #ff2e2e !important;
}

EOF

# 3. Replace Footer Text
find $PTERO_DIR -type f -exec sed -i 's/Pterodactyl/Rendzz Official/g' {} +

# 4. Rebuild Panel
cd $PTERO_DIR
npm install
npm run build

php artisan view:clear
php artisan cache:clear

echo "✅ RENDZZ OFFICIAL THEME INSTALLED!"
echo "🚀 Refresh browser (CTRL+SHIFT+R)"
