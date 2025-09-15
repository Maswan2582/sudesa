# Fix: SQLSTATE[42S22] Column 'status' not found

## Problem
Error terjadi pada `ProgramController.php` line 196 karena query menggunakan kolom `status` yang tidak ada pada tabel RPJM.

## Root Cause
Tabel RPJM menggunakan kolom `status_pelaksanaan` bukan `status`:
- `rpjmdes_program` table: menggunakan `status_pelaksanaan`
- `rpjmdes_kegiatan` table: menggunakan `status_pelaksanaan`

Enum values yang benar:
- 'belum_mulai'
- 'sedang_berjalan' 
- 'selesai'
- 'tertunda'
- 'dibatalkan'

## Files Fixed

### 1. ProgramController.php
**Before:**
```php
'kegiatan_selesai' => $program->kegiatan()->where('status', 'selesai')->count(),
'kegiatan_progress' => $program->kegiatan()->where('status', 'progress')->count(),
'program_selesai' => RPJMDesProgram::whereHas('sasaran.tujuan', function($query) use ($rpjmdes) {
    $query->where('rpjmdes_id', $rpjmdes->id);
})->where('status', 'selesai')->count(),
'program_berjalan' => RPJMDesProgram::whereHas('sasaran.tujuan', function($query) use ($rpjmdes) {
    $query->where('rpjmdes_id', $rpjmdes->id);
})->where('status', 'pelaksanaan')->count(),
```

**After:**
```php
'kegiatan_selesai' => $program->kegiatan()->where('status_pelaksanaan', 'selesai')->count(),
'kegiatan_progress' => $program->kegiatan()->where('status_pelaksanaan', 'sedang_berjalan')->count(),
'program_selesai' => RPJMDesProgram::whereHas('sasaran.tujuan', function($query) use ($rpjmdes) {
    $query->where('rpjmdes_id', $rpjmdes->id);
})->where('status_pelaksanaan', 'selesai')->count(),
'program_berjalan' => RPJMDesProgram::whereHas('sasaran.tujuan', function($query) use ($rpjmdes) {
    $query->where('rpjmdes_id', $rpjmdes->id);
})->where('status_pelaksanaan', 'sedang_berjalan')->count(),
```

### 2. statistics-widget.blade.php
**Before:**
```php
$kegiatanSelesai = \App\Models\RPJMDesKegiatan::where('rpjmdes_id', $rpjmdes->id)->where('status', 'selesai')->count();
$kegiatanBerjalan = \App\Models\RPJMDesKegiatan::where('rpjmdes_id', $rpjmdes->id)->where('status', 'pelaksanaan')->count();
$kegiatanPerencanaan = \App\Models\RPJMDesKegiatan::where('rpjmdes_id', $rpjmdes->id)->where('status', 'perencanaan')->count();
```

**After:**
```php
$kegiatanSelesai = \App\Models\RPJMDesKegiatan::where('rpjmdes_id', $rpjmdes->id)->where('status_pelaksanaan', 'selesai')->count();
$kegiatanBerjalan = \App\Models\RPJMDesKegiatan::where('rpjmdes_id', $rpjmdes->id)->where('status_pelaksanaan', 'sedang_berjalan')->count();
$kegiatanPerencanaan = \App\Models\RPJMDesKegiatan::where('rpjmdes_id', $rpjmdes->id)->where('status_pelaksanaan', 'belum_mulai')->count();
```

### 3. MonitoringController.php
**Before:**
```php
'kegiatan_selesai' => $monitoring->where('status', 'selesai')->count(),
```

**After:**
```php
'kegiatan_selesai' => $monitoring->where('status_pelaksanaan', 'selesai')->count(),
```

### 4. SasaranController.php
**Before:**
```php
'program_selesai' => $sasaran->program()->where('status', 'selesai')->count(),
```

**After:**
```php
'program_selesai' => $sasaran->program()->where('status_pelaksanaan', 'selesai')->count(),
```

## Notes
- RKPDes tetap menggunakan kolom `status` dengan values yang berbeda (planned, ongoing, completed, cancelled)
- Hanya tabel RPJM yang menggunakan `status_pelaksanaan`
- Pastikan nilai enum yang digunakan sesuai dengan yang didefinisikan di migration

## Status
✅ Fixed - All RPJM-related status queries now use correct column name and enum values
- ✅ app/Services/DesaConfigService.php
- ✅ app/Helpers/DesaHelper.php  
- ✅ resources/views/admin/users/form.blade.php
- ✅ app/Http/Requests/DetailUserRequest.php
- ✅ app/Http/Controllers/AdminDashboard/UserController.php

## STATUS: READY FOR TESTING
Form edit user seharusnya sudah bisa menyimpan data dengan dusun dinamis.