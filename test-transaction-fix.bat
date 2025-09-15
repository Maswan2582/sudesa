@echo off
echo Testing Installation Transaction Safety...
echo.

echo [TEST 1] Reset environment...
call reset-installer.bat

echo.
echo [TEST 2] Starting installation test...
echo Access: http://localhost/silamadesa.com/install
echo.
echo Watch for these key points:
echo - Progress should move smoothly from step 1-6
echo - No "transaction" errors during cache clearing  
echo - Installation should complete successfully
echo - Should redirect to completion page
echo.

pause