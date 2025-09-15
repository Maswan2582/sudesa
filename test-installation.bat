@echo off
setlocal EnableDelayedExpansion

echo ====================================
echo     Test Instalasi SILAMA-DESA
echo ====================================
echo.

echo [1] Reset database dan cache...
call reset-installer.bat
if errorlevel 1 (
    echo Error: Reset gagal!
    pause
    exit /b 1
)

echo.
echo [2] Akses installer...
echo Browser akan membuka halaman installer.
echo Silakan ikuti proses instalasi hingga selesai.
echo.

start http://localhost/silamadesa.com/install

echo [3] Menunggu konfirmasi...
echo.
echo Setelah instalasi selesai, tekan Enter untuk melanjutkan test...
pause > nul

echo.
echo [4] Test akses halaman utama...
start http://localhost/silamadesa.com

echo.
echo [5] Test akses login...
start http://localhost/silamadesa.com/login

echo.
echo ====================================
echo        Test Instalasi Selesai
echo ====================================
echo.
echo Pastikan:
echo - Instalasi berjalan tanpa error
echo - Redirect otomatis ke login bekerja
echo - Tidak ada data dummy warga
echo - Halaman utama dapat diakses
echo.

pause