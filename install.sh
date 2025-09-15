#!/bin/bash

# SILAMA-DESA Installation Script
# Sistem Informasi Layanan Masyarakat dan Administrasi Desa dan Administrasi Desa

echo "==============================================="
echo "SILAMA-DESA Installation Script"
echo "Sistem Informasi Layanan Masyarakat dan Administrasi Desa"
echo "==============================================="
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Check if composer is installed
if ! command -v composer &> /dev/null; then
    print_error "Composer tidak ditemukan! Silakan install Composer terlebih dahulu."
    echo "Download dari: https://getcomposer.org/download/"
    exit 1
fi

# Check if PHP is installed
if ! command -v php &> /dev/null; then
    print_error "PHP tidak ditemukan! Silakan install PHP 8.2 atau lebih tinggi."
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_error "Node.js tidak ditemukan! Silakan install Node.js terlebih dahulu."
    echo "Download dari: https://nodejs.org/"
    exit 1
fi

print_info "Memulai instalasi SILAMA-DESA..."
echo

# Step 1: Install PHP dependencies
echo "[1/8] Installing PHP dependencies..."
if composer install; then
    print_success "PHP dependencies berhasil diinstall."
else
    print_error "Gagal menginstall PHP dependencies!"
    exit 1
fi
echo

# Step 2: Install JavaScript dependencies
echo "[2/8] Installing JavaScript dependencies..."
if npm install; then
    print_success "JavaScript dependencies berhasil diinstall."
else
    print_error "Gagal menginstall JavaScript dependencies!"
    exit 1
fi
echo

# Step 3: Setup environment file
echo "[3/8] Setting up environment file..."
if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
        print_success "File .env berhasil dibuat dari .env.example"
    else
        print_warning "File .env.example tidak ditemukan!"
        print_info "Membuat file .env default..."
        cat > .env << EOF
APP_NAME="SILAMA-DESA"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=silama_desa
DB_USERNAME=root
DB_PASSWORD=

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="\${APP_NAME}"
EOF
    fi
else
    print_info "File .env sudah ada, melanjutkan..."
fi
echo

# Step 4: Generate application key
echo "[4/8] Generating application key..."
if php artisan key:generate --force; then
    print_success "Application key berhasil di-generate."
else
    print_error "Gagal generate application key!"
    exit 1
fi
echo

# Step 5: Ask for database configuration
echo "[5/8] Konfigurasi Database"
echo
echo "Silakan konfigurasikan database Anda:"
echo

read -p "Nama database (default: silama_desa): " db_name
db_name=${db_name:-silama_desa}

read -p "Username database (default: root): " db_user
db_user=${db_user:-root}

read -s -p "Password database (kosong jika tidak ada): " db_pass
echo

read -p "Host database (default: 127.0.0.1): " db_host
db_host=${db_host:-127.0.0.1}

read -p "Port database (default: 3306): " db_port
db_port=${db_port:-3306}

echo
print_info "Updating database configuration in .env file..."

# Update .env file with database configuration
sed -i.bak "s/DB_DATABASE=.*/DB_DATABASE=$db_name/" .env
sed -i.bak "s/DB_USERNAME=.*/DB_USERNAME=$db_user/" .env
sed -i.bak "s/DB_PASSWORD=.*/DB_PASSWORD=$db_pass/" .env
sed -i.bak "s/DB_HOST=.*/DB_HOST=$db_host/" .env
sed -i.bak "s/DB_PORT=.*/DB_PORT=$db_port/" .env

print_success "Database configuration updated."
echo

# Step 6: Set permissions and create storage link
echo "[6/8] Setting permissions and creating storage symbolic link..."

# Set permissions
chmod -R 755 storage bootstrap/cache 2>/dev/null || print_warning "Tidak dapat mengatur permissions. Pastikan anda memiliki akses yang cukup."

# Create storage link
if php artisan storage:link; then
    print_success "Storage symbolic link berhasil dibuat."
else
    print_warning "Gagal membuat symbolic link storage."
fi
echo

# Step 7: Ask if user wants to run migrations
echo "[7/8] Database Migration"
echo
read -p "Apakah Anda ingin menjalankan database migration sekarang? (y/n): " run_migrate
if [[ $run_migrate =~ ^[Yy]$ ]]; then
    print_info "Running database migrations..."
    if php artisan migrate --force; then
        print_success "Database migrations berhasil!"
        
        # Ask for seeder
        read -p "Apakah Anda ingin menjalankan database seeder untuk data awal? (y/n): " run_seed
        if [[ $run_seed =~ ^[Yy]$ ]]; then
            print_info "Running database seeders..."
            if php artisan db:seed --force; then
                print_success "Database seeder berhasil!"
            else
                print_warning "Database seeder gagal, namun aplikasi tetap dapat digunakan."
            fi
        fi
    else
        print_error "Database migration gagal!"
        print_info "Pastikan database '$db_name' sudah dibuat dan konfigurasi database benar."
        print_info "Anda dapat menjalankan migration manual dengan: php artisan migrate"
    fi
else
    print_info "Skipping database migration. Jalankan manual dengan: php artisan migrate"
fi
echo

# Step 8: Build assets
echo "[8/8] Building assets..."
read -p "Apakah Anda ingin build assets sekarang? (y/n): " build_assets
if [[ $build_assets =~ ^[Yy]$ ]]; then
    print_info "Building assets for production..."
    if npm run build; then
        print_success "Assets berhasil di-build!"
    else
        print_warning "Asset build gagal. Anda dapat menjalankan 'npm run build' nanti."
    fi
else
    print_info "Skipping asset build. Jalankan manual dengan: npm run build"
fi
echo

# Installation complete
echo "==============================================="
echo "INSTALASI SELESAI!"
echo "==============================================="
echo
print_success "Aplikasi SILAMA-DESA berhasil diinstall!"
echo
echo -e "${BLUE}LANGKAH SELANJUTNYA:${NC}"
echo "1. Pastikan web server (Apache/Nginx) mengarah ke folder 'public'"
echo "2. Buat database '$db_name' jika belum ada"
echo "3. Jalankan 'php artisan migrate' jika belum dijalankan"
echo "4. Jalankan 'php artisan db:seed' untuk data awal"
echo "5. Akses aplikasi melalui web browser"
echo
echo -e "${YELLOW}USER DEFAULT:${NC}"
echo "- Super Admin: admin / password"
echo "- Kepala Desa: kades / password"
echo "- Staff Desa: staff / password"
echo
echo -e "${GREEN}UNTUK DEVELOPMENT:${NC}"
echo "- Jalankan: php artisan serve"
echo "- Akses: http://127.0.0.1:8000"
echo
echo "Dokumentasi lengkap tersedia di INSTALL.md"
echo
echo "Terima kasih telah menggunakan SILAMA-DESA!"
echo "==============================================="