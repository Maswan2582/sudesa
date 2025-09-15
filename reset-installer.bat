@echo off
echo =================================
echo  SILAMA-DESA Installer Reset Tool
echo =================================
echo.

echo [1/7] Stopping any running server...
taskkill /F /IM php.exe 2>nul

echo [2/7] Removing ALL lock files...
if exist "storage\app\*.lock" del /Q "storage\app\*.lock"
if exist "storage\app\.installed" del /Q "storage\app\.installed"
if exist "storage\app\installation.lock" del /Q "storage\app\installation.lock"

echo [3/7] Dropping all database tables...
php artisan db:wipe --force

echo [4/7] Clearing ALL Laravel caches...
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan optimize:clear

echo [5/7] Recreating database if needed...
@echo off
setlocal EnableDelayedExpansion

echo ====================================
echo      Reset Installer SILAMA-DESA
echo ====================================
echo.

echo [1] Hapus database 'sudes'...
mysql -u root -e "DROP DATABASE IF EXISTS sudes;" 2>nul
if errorlevel 1 (
    echo Warning: Database 'sudes' mungkin tidak ada atau MySQL tidak berjalan
) else (
    echo ✓ Database 'sudes' berhasil dihapus
)

echo.
echo [2] Buat database 'sudes' baru...
mysql -u root -e "CREATE DATABASE sudes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>nul
if errorlevel 1 (
    echo Error: Gagal membuat database 'sudes'
    echo Pastikan MySQL berjalan dan dapat diakses
    pause
    exit /b 1
) else (
    echo ✓ Database 'sudes' berhasil dibuat
)

echo.
echo [3] Hapus file lock instalasi...
if exist storage\app\installed.lock (
    del /f storage\app\installed.lock
    echo ✓ File installed.lock dihapus
) else (
    echo - File installed.lock tidak ditemukan
)

if exist storage\app\.installed (
    del /f storage\app\.installed  
    echo ✓ File .installed dihapus
) else (
    echo - File .installed tidak ditemukan
)

echo.
echo [4] Clear cache aplikasi...
php artisan config:clear 2>nul
php artisan cache:clear 2>nul  
php artisan view:clear 2>nul
php artisan route:clear 2>nul
echo ✓ Cache aplikasi dibersihkan

echo.
echo [5] Clear session instalasi...
php artisan session:flush 2>nul
echo ✓ Session instalasi dibersihkan

echo.
echo [6] Clear progress cache...
php -r "file_put_contents('storage/framework/cache/data/.gitignore', '*' . PHP_EOL . '!.gitignore');" 2>nul
if exist storage\framework\cache\data (
    for /d %%d in (storage\framework\cache\data\*) do (
        if exist "%%d" rmdir /s /q "%%d" 2>nul
    )
    for %%f in (storage\framework\cache\data\*) do (
        if not "%%~nxf"==".gitignore" del /f "%%f" 2>nul
    )
)
echo ✓ Progress cache dibersihkan

echo.
echo ====================================
echo         Reset Selesai!
echo ====================================
echo.
echo Sekarang Anda dapat mengakses installer di:
echo http://localhost/silamadesa.com/install
echo.

pause

echo [6/7] Verifying clean state...
php artisan db:show

echo [7/7] Starting Laravel server...
echo.
echo =======================================
echo  RESET COMPLETE - READY FOR INSTALL
echo =======================================
echo Server: http://127.0.0.1:8000/
echo Auto-redirect to installer: ENABLED
echo.
echo Press Ctrl+C to stop server
php artisan serve --host=127.0.0.1 --port=8000