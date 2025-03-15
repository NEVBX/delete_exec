# НАСТРОЙКИ--------------------------------------

#Папка, в которой будут удаляться файлы выбранного типа.
$TargetFolder = "PATH HERE"   #Например: "C:\Users\username\Downloads"

#Этот пункт отвечает за тип самого файла. Вместо .exe можно указать что угодно, хоть .mp3, хоть .jpg
$FileType = "*.exe"   #Например: "*.exe"

#Включает "глубокое сканирование (сканирование подпапок)". !!!ВНИМАЕНИЕ!!! Использовать с осторожностью, так как скрипт может удалить системные файлы.
#Рекомендую использовать в папках с "одним концом", например, C:\Users\username\Documents
$DeepScan = $false   # $true или $false

#Интервал сканирования папки на наличие указанных файлов. Чем меньше - тем лучше, но чем меньше - тем сильнее нагрузка на процессор.
$Interval = 1   #Рекомендуемое: от 1 до 3

# -----------------------------------------------




# САМ СКРИПТ (трогать не рекомендую)-------------

function PressAnyKey() {
    Write-Host "Нажмите любую клавишу чтобы выйти." -ForegroundColor DarkRed
    $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit
}
$DeepScanIsOn = "Без глубокого сканирования."
$FileTypeReplace = $FileType.Replace("*", "")
if ($DeepScan -eq $true) {
    $DeepScanIsOn = "Глубокое сканирование включено!"
}
if ($TargetFolder -eq "PATH HERE") {
    Write-Host "`nПожалуйста, укажите путь к нужной папке в `$TargetFolder.`n" -ForegroundColor Red
    PressAnyKey
}
if (!(Test-Path -Path $TargetFolder -PathType Container)) {
    Write-Host "`nСкрипт не может выполнить свою работу, так как указанной папки не существует. Пожалуйста, укажите существующую папку в `$TargetFolder.`n" -ForegroundColor Red
    PressAnyKey
}
if ($Interval -lt 1) {
    Write-Host "`nЗначение интервала не может быть менее 1 секунды. Пожалуйста, укажите положительное число в `$Interval.`n" -ForegroundColor Red
    PressAnyKey
}
Write-Host "Идет сканирование папки $($TargetFolder) на наличие $($FileTypeReplace) файлов. $($DeepScanIsOn)" -ForegroundColor Green
Write-Host "Указанная папка: $($TargetFolder)`nТип файлов: $($FileTypeReplace)`Глубокое сканрирование (сканирование подпапок): $($DeepScanIsOn)`nИнтервал сканирования: $($Interval) сек.`n" -ForegroundColor Gray
Write-Host "Ctrl + C - выход" -ForegroundColor DarkGray
while ($true) {
    $Executables = Get-ChildItem -Path $TargetFolder -Filter $FileType -File -Recurse: $DeepScan
    foreach ($key in $Executables) {
        $FileName = $key.FullName
        Write-Host "`nОбнаружен $($FileTypeReplace) файл $($FileName). Идет попытка удаления..." -ForegroundColor Red
        try {
            Remove-Item -Path $FileName -Force
            Write-Host "`nФайл $($FileName) был успешно нейтрализован.`n" -ForegroundColor Yellow
        }
        catch {
            Write-Warning "`nОшибка при удалении файла $($FileName). Возможно, файл был перемещен или удален. $($_.Exception.Message)`n"
        }
    }
    Start-Sleep -Seconds $Interval
}

# -----------------------------------------------