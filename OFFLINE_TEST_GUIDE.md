# TESTING OFFLINE LICENSE ACTIVATION

## Untuk test offline mode, Anda bisa:

### Method 1: Disable Network (Simulasi)
1. Disconnect WiFi/network sementara
2. Lakukan instalasi hingga step license
3. Input serial number yang valid
4. System akan otomatis fallback ke offline mode

### Method 2: Block License Server (Simulasi di hosts file)
1. Edit file hosts Windows: `C:\Windows\System32\drivers\etc\hosts`
2. Tambahkan line: `127.0.0.1 license-server.silama.com`
3. Save file
4. Lakukan instalasi - akan simulate server unreachable

### Method 3: Modify LicenseService untuk Testing
Temporary modify untuk test offline:

```php
// In app/Services/LicenseService.php
public function activateLicense($serialNumber, $customerInfo = [])
{
    // Force offline mode untuk testing
    throw new \Exception('Simulated network error for testing');
}
```

## Expected Offline Behavior:
1. ✅ Connection attempt fails
2. ✅ Fallback to offline validation
3. ✅ Serial format validation only  
4. ⚠️ Warning message about offline mode
5. ✅ Continue installation with grace period
6. ✅ License saved with offline flag