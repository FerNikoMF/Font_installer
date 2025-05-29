# Batch Font Installer for Windows (с прогресс-баром)
Add-Type -AssemblyName System.Windows.Forms
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowser.Description = "Выберите папку со шрифтами (ttf, otf)"

if ($folderBrowser.ShowDialog() -eq "OK") {
    $source = $folderBrowser.SelectedPath
    $fonts = Get-ChildItem -Path $source -Recurse -Include *.ttf,*.otf
    $errors = @()
    $total = $fonts.Count
    $i = 0

    foreach ($font in $fonts) {
        $i++
        Write-Progress -Activity "Установка шрифтов..." -Status "$i из $total: $($font.Name)" -PercentComplete (($i / $total) * 100)
        try {
            Copy-Item $font.FullName -Destination "C:\Windows\Fonts" -Force -ErrorAction Stop
        } catch {
            $errors += $font.Name
        }
    }

    Write-Progress -Activity "Установка шрифтов..." -Completed

    if ($errors.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Готово! Все шрифты установлены. Рекомендуется перезагрузить компьютер.","Установка завершена")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Установлены не все шрифты. Ошибки для файлов:`n$($errors -join "`n")`nНекоторые файлы могли быть защищены системой или уже установлены.","Частичная установка")
    }
}
