$filePath = "app\Http\Controllers\RabRkpdesController.php"
$content = Get-Content $filePath -Raw
$content = $content -replace "\['rab_rkpde' =>", "['rabRkpdes' =>"
Set-Content $filePath -Value $content
Write-Host "Routes fixed successfully"