# 🎯 PANDUAN PRAKTIK TESTING SISTEM LISENSI SILAMA DENGAN LARAGON

## ✅ SEMUA PERSIAPAN SUDAH SELESAI!

Sistem lisensi telah sepenuhnya diintegrasikan dan siap untuk diuji. Berikut adalah summary lengkap cara praktiknya:

---

## 🚀 TESTING ENVIRONMENT READY

### Status Saat Ini:
- ✅ **Database**: `silamadesa_test` sudah dibuat
- ✅ **Installation locks**: Sudah dihapus untuk fresh install
- ✅ **Routes**: License routes sudah terdaftar
- ✅ **Server**: Laravel development server running di `http://127.0.0.1:8000`
- ✅ **Browser**: Installer sudah bisa diakses

---

## 🧪 STEP-BY-STEP TESTING

### STEP 1: Test Fresh Installation
```
1. Buka browser ke: http://127.0.0.1:8000/install
2. Ikuti wizard installer:
   ✅ Welcome
   ✅ Database Config (silamadesa_test, root, no password)
   ✅ App Config (SILAMA TEST)
   ✅ Desa Config (data test)
   ✅ Admin Config (admin@test.com)
   🆕 LICENSE ACTIVATION ← STEP BARU!
   ✅ Installation Process
   ✅ Complete
```

### STEP 2: Test License Activation (Step 6)
```
Serial Number untuk Testing:
✅ SILAMA-TEST-2024-0001  (Valid)
✅ SILAMA-DEMO-2024-0002  (Valid)
✅ SILAMA-PROD-2024-0003  (Valid)

Customer Info:
- Name: Test Customer
- Email: customer@test.com  
- Phone: 08123456789

✅ Agree to terms and conditions
```

### STEP 3: Test Validation
```
Test Invalid Serials:
❌ silama-test-2024-0001  (lowercase - harus error)
❌ SILAMA-TEST-24-001     (wrong format - harus error)
❌ TEST-SILAMA-2024-0001  (wrong prefix - harus error)

Expected: Error messages dan tidak bisa lanjut
```

### STEP 4: Test Installation Completion
```
Setelah license activation berhasil:
✅ Redirect ke installation process
✅ Migration jalan (including license tables)
✅ License data tersimpan di database
✅ Installation complete
✅ Redirect ke login page
```

---

## 🔍 VERIFICATION TESTS

### Test A: Database Check
```sql
-- Connect to test database
mysql -u root silamadesa_test

-- Check license data
SELECT * FROM licenses;
SELECT * FROM license_validations;

-- Should show your license record
```

### Test B: Middleware Protection
```
1. Complete installation normal
2. Akses: http://127.0.0.1:8000/
3. Expected: Login page (normal access)

4. Hapus license dari database:
   DELETE FROM licenses;

5. Akses: http://127.0.0.1:8000/ lagi
6. Expected: Redirect ke license activation
```

### Test C: License Management
```
1. http://127.0.0.1:8000/license/status
2. http://127.0.0.1:8000/license/activate
3. Expected: License management pages accessible
```

---

## 🎛️ TESTING SCENARIOS

### Scenario 1: Online Activation
```
✅ Normal installation dengan internet
✅ License activation berhasil online
✅ Data tersimpan dengan activation_mode: 'online'
```

### Scenario 2: Offline Activation
```
Para test offline mode:
1. Disconnect internet/WiFi
2. Atau edit hosts file: 127.0.0.1 license-server.silama.com
3. Lakukan installation
4. Expected: Fallback ke offline mode dengan warning
```

### Scenario 3: Error Handling
```
Test berbagai error conditions:
❌ Invalid serial format
❌ Empty required fields
❌ Terms not agreed
❌ Network timeout (offline fallback)
```

---

## 🚨 TROUBLESHOOTING

### Jika Step 6 (License) tidak muncul:
```bash
# Clear cache
php artisan cache:clear
php artisan config:clear

# Check routes
php artisan route:list --name=installer.license

# Restart server
Ctrl+C di terminal server
php artisan serve --host=127.0.0.1 --port=8000
```

### Jika database error:
```bash
# Re-create database
mysql -u root -e "DROP DATABASE silamadesa_test; CREATE DATABASE silamadesa_test;"

# Update .env
DB_DATABASE=silamadesa_test

# Clear config
php artisan config:clear
```

### Jika license validation error:
```bash
# Check license config
cat config/license.php

# Test license service manually
php artisan tinker
>>> $service = new App\Services\LicenseService();
>>> $service->validateSerialFormat('SILAMA-TEST-2024-0001');
```

---

## 🎯 SUCCESS CRITERIA

Testing berhasil jika:
```
✅ Step 6 (License) muncul dalam installer
✅ License form validation bekerja
✅ Valid serial numbers diterima
✅ Invalid serial numbers ditolak
✅ Installation berhasil dengan license
✅ License data tersimpan di database
✅ Middleware protection aktif post-install
✅ License management pages accessible
✅ Error handling graceful
```

---

## 📱 QUICK TESTING COMMANDS

Untuk cek status cepat:
```bash
# Cek server status
curl http://127.0.0.1:8000/install

# Cek database
mysql -u root silamadesa_test -e "SHOW TABLES;"

# Cek license data
mysql -u root silamadesa_test -e "SELECT * FROM licenses;"

# Cek routes
php artisan route:list --name=installer
```

---

## 🎉 WHAT TO EXPECT

### Saat Testing Berhasil:
1. **Welcome Page** → Standard installer welcome
2. **Database Step** → Connect ke silamadesa_test
3. **App Step** → Configure app settings  
4. **Desa Step** → Configure village data
5. **Admin Step** → Create admin account
6. **🆕 LICENSE STEP** → **AKTIVASI LISENSI (MANDATORY)**
7. **Installation** → Run migrations + save license
8. **Complete** → Installation finished with license

### Fitur Baru yang Bisa Dilihat:
- ✨ **Step 6 License** dengan form aktivasi
- ✨ **Serial number auto-formatting**
- ✨ **Real-time validation feedback**  
- ✨ **Online/offline mode detection**
- ✨ **Terms & conditions**
- ✨ **License data di database**
- ✨ **Middleware protection**

---

## 🚀 READY TO TEST!

**Environment testing sudah sepenuhnya siap!** 

Anda bisa langsung:
1. ✅ Buka browser ke `http://127.0.0.1:8000/install`
2. ✅ Ikuti wizard sampai Step 6 (License)  
3. ✅ Test dengan serial: `SILAMA-TEST-2024-0001`
4. ✅ Complete installation
5. ✅ Verify license protection

**Sistem lisensi SILAMA siap untuk production setelah testing ini berhasil!** 🎯

---

*Dokumentasi ini memberikan panduan lengkap untuk menguji sistem lisensi yang telah diintegrasikan dengan installer SILAMA menggunakan Laragon.*