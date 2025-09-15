# POST-INSTALLATION LICENSE VALIDATION TEST

## Test Middleware Protection

### Test 1: Normal Access dengan License Valid
```
1. Complete full installation dengan license
2. Akses: http://127.0.0.1:8000/
3. Expected: Login page (normal access)
```

### Test 2: Access tanpa License (Simulate License Invalid)
```sql
-- Connect ke database dan hapus license
mysql -u root silamadesa_test

-- Backup license data
CREATE TABLE licenses_backup AS SELECT * FROM licenses;

-- Hapus license data untuk test
DELETE FROM licenses;

-- Exit mysql
exit
```

```
4. Akses: http://127.0.0.1:8000/
5. Expected: Redirect ke license activation page
```

### Test 3: Restore License
```sql
-- Restore license data
INSERT INTO licenses SELECT * FROM licenses_backup;
```

### Test 4: License Management Pages
```
1. Akses: http://127.0.0.1:8000/license/status
2. Expected: License information page

3. Akses: http://127.0.0.1:8000/license/activate
4. Expected: License activation form
```

## Test Commands untuk Validation

```bash
# Check if license data exists
php artisan tinker
>>> App\Models\License::count();
>>> App\Models\License::first();

# Test license service validation
>>> $service = new App\Services\LicenseService();
>>> $result = $service->validateLicense();
>>> dd($result);
```

## Expected Results

### ✅ SUCCESS Indicators:
- Middleware blocks access when no license
- Valid license allows normal access
- License pages accessible
- Database records complete

### ❌ FAILURE Indicators:
- Access allowed without license
- Middleware not triggering
- License pages not found
- Database errors