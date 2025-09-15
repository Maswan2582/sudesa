# 🧪 QUICK TEST CHECKLIST UNTUK SISTEM LISENSI

## ✅ STEP 1: Cek Status Saat Ini

Jalankan command berikut untuk memastikan environment siap:

```bash
# Cek database
mysql -u root -e "SHOW DATABASES LIKE 'silamadesa_test';"

# Cek installation locks (harus kosong)
dir storage\app\*.lock
dir storage\app\.installed

# Cek routes license
php artisan route:list --name=installer.license
```

## ✅ STEP 2: Test Installer Via Browser

### 1. Akses Installer
```
URL: http://silamadesa.com/install
Expected: Menampilkan halaman installer welcome
```

### 2. Test Flow Normal
```
✅ Step 1: Welcome → Continue
✅ Step 2: Database Configuration
   - Host: 127.0.0.1
   - Port: 3306
   - Database: silamadesa_test
   - Username: root
   - Password: (kosong)
   
✅ Step 3: Application Configuration
   - App Name: SILAMA TEST
   - URL: http://silamadesa.com
   - Timezone: Asia/Makassar
   
✅ Step 4: Desa Configuration
   - Fill with test data
   
✅ Step 5: Admin Configuration
   - Name: Test Admin
   - Email: admin@test.com
   - Password: password123
   
🆕 Step 6: LICENSE ACTIVATION ← YANG BARU!
   - Serial: SILAMA-TEST-2024-0001
   - Customer: Test Customer
   - Email: customer@test.com
   - Phone: 08123456789
   - ✅ Agree to terms
```

## ✅ STEP 3: Test License Validation

### Test Serial Numbers:
```
✅ VALID:
- SILAMA-TEST-2024-0001
- SILAMA-DEMO-2024-0002  
- SILAMA-PROD-2024-0003

❌ INVALID:
- silama-test-2024-0001 (lowercase)
- SILAMA-TEST-24-001 (wrong format)
- TEST-SILAMA-2024-0001 (wrong prefix)
```

### Expected Behavior:
```
✅ Valid serial → Continue to installation
❌ Invalid serial → Error message, stay on page
✅ Empty fields → Validation errors
✅ Terms not agreed → Error message
```

## ✅ STEP 4: Test Installation Process

Setelah license activation berhasil:
```
✅ Redirect ke installation process page
✅ Migration runs (including license tables)
✅ Database seeded
✅ License data saved to database
✅ Installation complete page
```

## ✅ STEP 5: Test Post-Installation

### Test Normal Access:
```
URL: http://silamadesa.com/
Expected: Login page (normal access)
```

### Test License Protection:
```bash
# Akses database dan hapus license data
mysql -u root silamadesa_test -e "DELETE FROM licenses;"

# Test akses lagi
URL: http://silamadesa.com/
Expected: Redirect ke license activation page
```

## ✅ STEP 6: Database Verification

```sql
-- Check license data
SELECT * FROM licenses;

-- Check validation history  
SELECT * FROM license_validations;

-- Check if installation completed
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM roles;
```

## 🚨 TROUBLESHOOTING

### Jika Step 6 tidak muncul:
```bash
# Clear cache
php artisan cache:clear
php artisan config:clear

# Check routes
php artisan route:list --name=installer

# Check controller
grep -n "license" app/Http/Controllers/InstallController.php
```

### Jika license validation error:
```bash
# Check config exists
cat config/license.php

# Check service
php artisan tinker
>>> new App\Services\LicenseService();
```

### Jika database error:
```bash
# Check connection
php artisan tinker
>>> DB::connection()->getPdo();

# Check tables exist
>>> Schema::hasTable('licenses');
```

## 🎯 SUCCESS CRITERIA

Testing berhasil jika:
```
✅ Step 6 (License) muncul dalam installer
✅ License validation bekerja dengan benar
✅ Online/offline activation functional
✅ Installation berhasil dengan license data tersimpan
✅ Post-installation middleware protection aktif
✅ Error handling graceful dan user-friendly
```

## 📝 NEXT STEPS SETELAH TESTING

Jika semua test berhasil:
```
1. ✅ Sistem lisensi ready for production
2. ✅ Buat serial numbers untuk customers
3. ✅ Setup license server (optional)
4. ✅ Prepare distribution package
5. ✅ Create customer documentation
```

---

**CATATAN:** Testing ini dilakukan di environment Laragon lokal. Untuk production, pastikan juga test di server dengan environment yang sama dengan deployment target.