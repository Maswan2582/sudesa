@echo off
echo ===============================================
echo SILAMA-DESA Installation Script
echo Sistem Informasi Layanan Masyarakat dan Administrasi Desa dan Administrasi Desa
echo ===============================================
echo.

:: Check if composer is installed
where composer >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Composer tidak ditemukan! Silakan install Composer terlebih dahulu.
    echo Download dari: https://getcomposer.org/download/
    pause
    exit /b 1
)

:: Check if PHP is installed
where php >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] PHP tidak ditemukan! Silakan install PHP 8.2 atau lebih tinggi.
    pause
    exit /b 1
)

:: Check if Node.js is installed
where node >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Node.js tidak ditemukan! Silakan install Node.js terlebih dahulu.
    echo Download dari: https://nodejs.org/
    pause
    exit /b 1
)

echo [INFO] Memulai instalasi SILAMA-DESA...
echo.

:: Step 1: Install PHP dependencies
echo [1/8] Installing PHP dependencies...
composer install
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Gagal menginstall PHP dependencies!
    pause
    exit /b 1
)
echo [SUCCESS] PHP dependencies berhasil diinstall.
echo.

:: Step 2: Install JavaScript dependencies
echo [2/8] Installing JavaScript dependencies...
call npm install
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Gagal menginstall JavaScript dependencies!
    pause
    exit /b 1
)
echo [SUCCESS] JavaScript dependencies berhasil diinstall.
echo.

:: Step 3: Setup environment file
echo [3/8] Setting up environment file...
if not exist .env (
    if exist .env.example (
        copy .env.example .env
        echo [SUCCESS] File .env berhasil dibuat dari .env.example
    ) else (
        echo [WARNING] File .env.example tidak ditemukan!
        echo [INFO] Membuat file .env default...
        echo APP_NAME="SILAMA-DESA"> .env
        echo APP_ENV=local>> .env
        echo APP_KEY=>> .env
        echo APP_DEBUG=true>> .env
        echo APP_URL=http://localhost>> .env
        echo.>> .env
        echo LOG_CHANNEL=stack>> .env
        echo LOG_DEPRECATIONS_CHANNEL=null>> .env
        echo LOG_LEVEL=debug>> .env
        echo.>> .env
        echo DB_CONNECTION=mysql>> .env
        echo DB_HOST=127.0.0.1>> .env
        echo DB_PORT=3306>> .env
        echo DB_DATABASE=silama_desa>> .env
        echo DB_USERNAME=root>> .env
        echo DB_PASSWORD=>> .env
        echo.>> .env
        echo BROADCAST_DRIVER=log>> .env
        echo CACHE_DRIVER=file>> .env
        echo FILESYSTEM_DISK=local>> .env
        echo QUEUE_CONNECTION=sync>> .env
        echo SESSION_DRIVER=file>> .env
        echo SESSION_LIFETIME=120>> .env
        echo.>> .env
        echo MEMCACHED_HOST=127.0.0.1>> .env
        echo.>> .env
        echo REDIS_HOST=127.0.0.1>> .env
        echo REDIS_PASSWORD=null>> .env
        echo REDIS_PORT=6379>> .env
        echo.>> .env
        echo MAIL_MAILER=smtp>> .env
        echo MAIL_HOST=mailpit>> .env
        echo MAIL_PORT=1025>> .env
        echo MAIL_USERNAME=null>> .env
        echo MAIL_PASSWORD=null>> .env
        echo MAIL_ENCRYPTION=null>> .env
        echo MAIL_FROM_ADDRESS="hello@example.com">> .env
        echo MAIL_FROM_NAME="${APP_NAME}">> .env
    )
) else (
    echo [INFO] File .env sudah ada, melanjutkan...
)
echo.

:: Step 4: Generate application key
echo [4/8] Generating application key...
php artisan key:generate --force
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Gagal generate application key!
    pause
    exit /b 1
)
echo [SUCCESS] Application key berhasil di-generate.
echo.

:: Step 5: Ask for database configuration
echo [5/8] Konfigurasi Database
echo.
echo Silakan konfigurasikan database Anda:
echo.
set /p db_name="Nama database (default: silama_desa): "
if "%db_name%"=="" set db_name=silama_desa

set /p db_user="Username database (default: root): "
if "%db_user%"=="" set db_user=root

set /p db_pass="Password database (kosong jika tidak ada): "

set /p db_host="Host database (default: 127.0.0.1): "
if "%db_host%"=="" set db_host=127.0.0.1

set /p db_port="Port database (default: 3306): "
if "%db_port%"=="" set db_port=3306

echo.
echo [INFO] Updating database configuration in .env file...

:: Update .env file with database configuration
powershell -Command "(Get-Content .env) -replace 'DB_DATABASE=.*', 'DB_DATABASE=%db_name%' | Set-Content .env"
powershell -Command "(Get-Content .env) -replace 'DB_USERNAME=.*', 'DB_USERNAME=%db_user%' | Set-Content .env"
powershell -Command "(Get-Content .env) -replace 'DB_PASSWORD=.*', 'DB_PASSWORD=%db_pass%' | Set-Content .env"
powershell -Command "(Get-Content .env) -replace 'DB_HOST=.*', 'DB_HOST=%db_host%' | Set-Content .env"
powershell -Command "(Get-Content .env) -replace 'DB_PORT=.*', 'DB_PORT=%db_port%' | Set-Content .env"

echo [SUCCESS] Database configuration updated.
echo.

:: Step 6: Create storage link
echo [6/8] Creating storage symbolic link...
php artisan storage:link
if %ERRORLEVEL% neq 0 (
    echo [WARNING] Gagal membuat symbolic link storage. Anda mungkin perlu menjalankan sebagai administrator.
) else (
    echo [SUCCESS] Storage symbolic link berhasil dibuat.
)
echo.

:: Step 7: Ask if user wants to run migrations
echo [7/8] Database Migration
echo.
set /p run_migrate="Apakah Anda ingin menjalankan database migration sekarang? (y/n): "
if /i "%run_migrate%"=="y" (
    echo [INFO] Running database migrations...
    php artisan migrate --force
    if %ERRORLEVEL% neq 0 (
        echo [ERROR] Database migration gagal!
        echo [INFO] Pastikan database '%db_name%' sudah dibuat dan konfigurasi database benar.
        echo [INFO] Anda dapat menjalankan migration manual dengan: php artisan migrate
    ) else (
        echo [SUCCESS] Database migrations berhasil!
        
        :: Ask for seeder
        set /p run_seed="Apakah Anda ingin menjalankan database seeder untuk data awal? (y/n): "
        if /i "!run_seed!"=="y" (
            echo [INFO] Running database seeders...
            php artisan db:seed --force
            if %ERRORLEVEL% neq 0 (
                echo [WARNING] Database seeder gagal, namun aplikasi tetap dapat digunakan.
            ) else (
                echo [SUCCESS] Database seeder berhasil!
            )
        )
    )
) else (
    echo [INFO] Skipping database migration. Jalankan manual dengan: php artisan migrate
)
echo.

:: Step 8: Build assets
echo [8/8] Building assets...
set /p build_assets="Apakah Anda ingin build assets sekarang? (y/n): "
if /i "%build_assets%"=="y" (
    echo [INFO] Building assets for production...
    call npm run build
    if %ERRORLEVEL% neq 0 (
        echo [WARNING] Asset build gagal. Anda dapat menjalankan 'npm run build' nanti.
    ) else (
        echo [SUCCESS] Assets berhasil di-build!
    )
) else (
    echo [INFO] Skipping asset build. Jalankan manual dengan: npm run build
)
echo.

:: Installation complete
echo ===============================================
echo INSTALASI SELESAI!
echo ===============================================
echo.
echo Aplikasi SILAMA-DESA berhasil diinstall!
echo.
echo LANGKAH SELANJUTNYA:
echo 1. Pastikan web server (Apache/Nginx) mengarah ke folder 'public'
echo 2. Buat database '%db_name%' jika belum ada
echo 3. Jalankan 'php artisan migrate' jika belum dijalankan
echo 4. Jalankan 'php artisan db:seed' untuk data awal
echo 5. Akses aplikasi melalui web browser
echo.
echo USER DEFAULT:
echo - Super Admin: admin / password
echo - Kepala Desa: kades / password  
echo - Staff Desa: staff / password
echo.
echo UNTUK DEVELOPMENT:
echo - Jalankan: php artisan serve
echo - Akses: http://127.0.0.1:8000
echo.
echo Dokumentasi lengkap tersedia di INSTALL.md
echo.
echo Terima kasih telah menggunakan SILAMA-DESA!
echo ===============================================
pause