# Batch Font Installer for Windows
# Скрипт для массовой установки всех шрифтов из выбранной папки (и её подпапок) в Windows
# Требует права администратора

Add-Type -AssemblyName System.Windows.Forms
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowser.Description = "Выберите папку со шрифтами (ttf, otf)"

if ($folderBrowser.ShowDialog() -eq "OK") {
    $source = $folderBrowser.SelectedPath
    $fonts = Get-ChildItem -Path $source -Recurse -Include *.ttf,*.otf
    $errors = @()

    foreach ($font in $fonts) {
        try {
            Copy-Item $font.FullName -Destination "C:\Windows\Fonts" -Force -ErrorAction Stop
        } catch {
            $errors += $font.Name
        }
    }

    if ($errors.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Готово! Все шрифты установлены. Рекомендуется перезагрузить компьютер.","Установка завершена")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Установлены не все шрифты. Ошибки для файлов:`n$($errors -join "`n")`nНекоторые файлы могли быть защищены системой или уже установлены.","Частичная установка")
    }
}
