# Backup Directory Migration

## Overview
Folder backup telah dipindahkan dari `storage/backups` ke `backups` (di root aplikasi) untuk alasan keamanan yang lebih baik.

## Changes Made

### 1. New Directory Structure
```
silamadesa.com/
├── backups/              # NEW - Secure backup location
│   ├── .htaccess        # Access protection
│   ├── database/        # Database backups
│   └── file_backups/    # File backups
└── storage/
    └── (backups removed) # OLD - No longer used
```

### 2. Configuration
- Created `config/backup.php` with new path configurations
- All backup paths now use `config('backup.backup_path')`
- Configurable retention days and size limits

### 3. Updated Files
- `app/Http/Controllers/Admin/BackupController.php`
- `app/Services/FileBackupService.php`
- `app/Services/HostingCompatibleBackupService.php`
- `app/Console/Commands/CreateDatabaseBackup.php`
- `app/Console/Commands/CleanupOldBackups.php`

### 4. Security Improvements
- Backups moved outside web-accessible directories
- Added `.htaccess` file to deny direct access
- Better path isolation from storage folder

## Benefits

1. **Security**: Backup files are no longer in storage/ or public/
2. **Organization**: Clear separation from Laravel storage
3. **Maintenance**: Easier backup management and cleanup
4. **Scalability**: Independent backup location configuration

## Migration Status
✅ All existing backup files migrated successfully
✅ All code references updated
✅ New configuration system in place
✅ Security protections implemented
✅ Tested with new backup creation

## Configuration Options

In `config/backup.php`:
- `backup_path`: Base backup directory
- `database_backup_path`: Database backup subdirectory
- `file_backup_path`: File backup subdirectory
- `retention_days`: Days to keep backups
- `max_backup_size_mb`: Size warning threshold

## Testing
- ✅ Database backup creation: `php artisan backup:database`
- ✅ Backup file listing in admin panel
- ✅ Download functionality
- ✅ Delete functionality
- ✅ File backup service