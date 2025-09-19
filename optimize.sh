#!/bin/bash

# Script de optimización de rendimiento para Filltech-production
echo "🚀 Iniciando optimización de rendimiento..."

# 1. Crear versiones WebP de las imágenes
echo "📸 Optimizando imágenes..."
cd /home/filltech_server/Filltech-production/assets/img

# Instalar herramientas si no están disponibles
if ! command -v cwebp &> /dev/null; then
    echo "Instalando herramientas de optimización de imágenes..."
    sudo apt update
    sudo apt install -y webp imagemagick
fi

# Convertir JPEG a WebP (mejor compresión)
if [ -f "pexels-photo-1470167.jpeg" ]; then
    cwebp -q 80 pexels-photo-1470167.jpeg -o pexels-photo-1470167.webp
    echo "✅ Creada versión WebP de pexels-photo-1470167.jpeg"
fi

# Optimizar JPG existente
if [ -f "screen-content-iphone-6.jpg" ]; then
    cwebp -q 80 screen-content-iphone-6.jpg -o screen-content-iphone-6.webp
    echo "✅ Creada versión WebP de screen-content-iphone-6.jpg"
fi

# 2. Minificar CSS y JS
echo "🗜️ Minificando CSS y JS..."
cd /home/filltech_server/Filltech-production

# Instalar minificadores si no están disponibles
if ! command -v minify &> /dev/null; then
    echo "Instalando minificadores..."
    sudo apt install -y npm
    sudo npm install -g minify
fi

# Minificar archivos CSS personalizados
find assets/css -name "*.css" ! -name "*.min.css" -exec sh -c 'minify "$1" > "${1%.css}.min.css"' _ {} \;

# 3. Crear bundle de CSS crítico
echo "📦 Creando bundles optimizados..."
cat > assets/css/bundle.min.css << 'EOF'
/* CSS crítico combinado y minificado */
.navbar{background:rgb(255,255,255)!important}.navbar-brand{font-size:25px}.nav-link{transition:background-color .3s,color .3s;font-size:20px}.nav-link:hover{background-color:black;color:white}.hero{padding:100px 0;text-align:center;width:100%;height:100vh;display:flex;flex-direction:column;justify-content:center;align-items:center;background:linear-gradient(black 57%,white),#f8f9fa}.hero h1{font-size:60px;color:rgb(255,255,255)}.hero p{color:rgb(178,195,213);font-size:25px}.hero .btn{background:linear-gradient(rgb(0,0,0) 0%,#0788ff 100%,#595959 100%);border-color:rgb(0,0,0)}.glassmorphism{backdrop-filter:blur(10px);background-color:rgba(255,255,255,.3);border-radius:8px;transition:all .3s ease}.glassmorphism:hover{background-color:rgba(255,255,255,.5);box-shadow:0 4px 8px rgba(0,0,0,.2)}.pulse{animation:pulse 2s infinite}@keyframes pulse{0%{transform:scale(1)}50%{transform:scale(1.05)}100%{transform:scale(1)}}
EOF

echo "✅ Bundle CSS creado"

# 4. Actualizar el archivo principal con las optimizaciones
cp index-optimized.html index.html

echo "🎯 Optimización completada!"
echo ""
echo "📊 Mejoras implementadas:"
echo "  ✅ CSS crítico inline (elimina bloqueo de renderizado)"
echo "  ✅ Carga asíncrona de recursos no críticos"
echo "  ✅ Preload de recursos importantes"
echo "  ✅ Imágenes WebP para mejor compresión"
echo "  ✅ Headers de caché optimizados"
echo "  ✅ Compresión gzip habilitada"
echo "  ✅ Semántica HTML mejorada para SEO"
echo "  ✅ Eliminación de CSS/JS duplicados"
echo ""
echo "🚀 Para aplicar cambios, rebuilda el contenedor Docker:"
echo "   docker build -t mi-sitio-web:optimized ."
echo "   docker stop blissful_dewdney"
echo "   docker run -d --name filltech-optimized -p 3004:80 mi-sitio-web:optimized"