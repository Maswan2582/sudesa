# DEBUG SESSION CHECKER

Tambahkan script debugging ini di method license() untuk melihat session data:

```php
public function license()
{
    if ($this->isInstalled()) {
        return redirect('/')->with('warning', 'Aplikasi sudah terinstall!');
    }

    // DEBUG: Check session data
    \Log::info('License method - Session Debug:', [
        'admin_config' => session('admin_config') ? 'EXISTS' : 'MISSING',
        'desa_config' => session('desa_config') ? 'EXISTS' : 'MISSING', 
        'app_config' => session('app_config') ? 'EXISTS' : 'MISSING',
        'db_config' => session('db_config') ? 'EXISTS' : 'MISSING',
        'all_sessions' => session()->all()
    ]);

    // Check if previous steps completed
    if (!session('admin_config') || !session('desa_config') || !session('app_config') || !session('db_config')) {
        return redirect()->route('installer.index')->with('error', 'Silakan selesaikan konfigurasi sebelumnya terlebih dahulu.');
    }

    return view('installer.license');
}
```

Atau test dengan browser console:
```javascript
// Di browser, buka developer tools dan jalankan:
fetch('/install/license', {method: 'GET'})
  .then(response => response.text())
  .then(data => console.log(data));
```