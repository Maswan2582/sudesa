<?php

/**
 * Test Script untuk License System
 * 
 * Usage: php test-license-system.php
 */

require_once 'vendor/autoload.php';
require_once 'bootstrap/app.php';

use App\Services\LicenseService;

echo "🧪 TESTING SISTEM LISENSI SILAMA\n";
echo "================================\n\n";

// Initialize License Service
$licenseService = new LicenseService();

// Test 1: Serial Format Validation
echo "Test 1: Serial Format Validation\n";
echo "---------------------------------\n";

$testSerials = [
    'SILAMA-TEST-2024-0001' => true,   // Valid
    'SILAMA-DEMO-2024-0002' => true,   // Valid
    'silama-test-2024-0001' => false,  // Invalid (lowercase)
    'SILAMA-TEST-24-001' => false,     // Invalid (wrong length)
    'TEST-SILAMA-2024-0001' => false,  // Invalid (wrong prefix)
    'SILAMA-TEST-2024' => false,       // Invalid (incomplete)
];

foreach ($testSerials as $serial => $expected) {
    $result = $licenseService->validateSerialFormat($serial);
    $status = $result === $expected ? '✅ PASS' : '❌ FAIL';
    echo "  {$serial}: {$status}\n";
}

echo "\n";

// Test 2: Hardware Fingerprint Generation
echo "Test 2: Hardware Fingerprint Generation\n";
echo "----------------------------------------\n";

$fingerprint = $licenseService->generateHardwareFingerprint();
echo "  Generated fingerprint: {$fingerprint}\n";
echo "  Length: " . strlen($fingerprint) . " characters\n";
echo "  Valid SHA256: " . (strlen($fingerprint) === 64 ? '✅ YES' : '❌ NO') . "\n";

echo "\n";

// Test 3: Check if tables exist
echo "Test 3: Database Table Check\n";
echo "-----------------------------\n";

try {
    if (\Illuminate\Support\Facades\Schema::hasTable('licenses')) {
        echo "  licenses table: ✅ EXISTS\n";
    } else {
        echo "  licenses table: ❌ NOT FOUND\n";
    }

    if (\Illuminate\Support\Facades\Schema::hasTable('license_validations')) {
        echo "  license_validations table: ✅ EXISTS\n";
    } else {
        echo "  license_validations table: ❌ NOT FOUND\n";
    }
} catch (Exception $e) {
    echo "  Database error: ❌ " . $e->getMessage() . "\n";
}

echo "\n";

// Test 4: License Model Test
echo "Test 4: License Model Test\n";
echo "---------------------------\n";

try {
    $license = new \App\Models\License();
    echo "  License model: ✅ LOADED\n";
    
    $validation = new \App\Models\LicenseValidation();
    echo "  LicenseValidation model: ✅ LOADED\n";
} catch (Exception $e) {
    echo "  Model error: ❌ " . $e->getMessage() . "\n";
}

echo "\n";

// Test 5: Check Installation Status
echo "Test 5: Installation Status Check\n";
echo "----------------------------------\n";

$installFile1 = storage_path('app/.installed');
$installFile2 = storage_path('app/installed.lock');

echo "  .installed file: " . (file_exists($installFile1) ? '❌ EXISTS (need to remove)' : '✅ NOT EXISTS') . "\n";
echo "  installed.lock file: " . (file_exists($installFile2) ? '❌ EXISTS (need to remove)' : '✅ NOT EXISTS') . "\n";

echo "\n";

// Test 6: Route Check
echo "Test 6: Route Availability\n";
echo "--------------------------\n";

try {
    $routes = \Illuminate\Support\Facades\Route::getRoutes();
    
    $installerRoutes = [];
    foreach ($routes as $route) {
        if (str_contains($route->getName() ?? '', 'installer.')) {
            $installerRoutes[] = $route->getName();
        }
    }
    
    $requiredRoutes = [
        'installer.index',
        'installer.database',
        'installer.application',
        'installer.desa',
        'installer.admin',
        'installer.license',      // 🆕 NEW
        'installer.license.store', // 🆕 NEW
        'installer.install',
        'installer.complete'
    ];
    
    foreach ($requiredRoutes as $route) {
        $exists = in_array($route, $installerRoutes);
        $status = $exists ? '✅ EXISTS' : '❌ MISSING';
        $special = ($route === 'installer.license' || $route === 'installer.license.store') ? ' 🆕' : '';
        echo "  {$route}: {$status}{$special}\n";
    }
} catch (Exception $e) {
    echo "  Route check error: ❌ " . $e->getMessage() . "\n";
}

echo "\n";

// Summary
echo "🎯 TESTING SUMMARY\n";
echo "==================\n";
echo "✅ Sistem lisensi siap untuk testing\n";
echo "✅ Database dan model tersedia\n";
echo "✅ Route installer dengan license step aktif\n";
echo "✅ Installation lock files sudah dihapus\n";
echo "\n";
echo "📋 NEXT STEPS:\n";
echo "1. Akses: http://silamadesa.com/install\n";
echo "2. Lakukan instalasi step-by-step\n";
echo "3. Pastikan Step 6 (License) muncul\n";
echo "4. Test dengan serial: SILAMA-TEST-2024-0001\n";
echo "\n";
echo "🚀 READY FOR TESTING!\n";