# ���������--------------------------------------

#�����, � ������� ����� ��������� ����� ���������� ����.
$TargetFolder = "PATH HERE"   #��������: "C:\Users\username\Downloads"

#���� ����� �������� �� ��� ������ �����. ������ .exe ����� ������� ��� ������, ���� .mp3, ���� .jpg
$FileType = "*.exe"   #��������: "*.exe"

#�������� "�������� ������������ (������������ ��������)". !!!���������!!! ������������ � �������������, ��� ��� ������ ����� ������� ��������� �����.
#���������� ������������ � ������ � "����� ������", ��������, C:\Users\username\Documents
$DeepScan = $false   # $true ��� $false

#�������� ������������ ����� �� ������� ��������� ������. ��� ������ - ��� �����, �� ��� ������ - ��� ������� �������� �� ���������.
$Interval = 1   #�������������: �� 1 �� 3

# -----------------------------------------------




# ��� ������ (������� �� ����������)-------------

function PressAnyKey() {
    Write-Host "������� ����� ������� ����� �����." -ForegroundColor DarkRed
    $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit
}
$DeepScanIsOn = "��� ��������� ������������."
$FileTypeReplace = $FileType.Replace("*", "")
if ($DeepScan -eq $true) {
    $DeepScanIsOn = "�������� ������������ ��������!"
}
if ($TargetFolder -eq "PATH HERE") {
    Write-Host "`n����������, ������� ���� � ������ ����� � `$TargetFolder.`n" -ForegroundColor Red
    PressAnyKey
}
if (!(Test-Path -Path $TargetFolder -PathType Container)) {
    Write-Host "`n������ �� ����� ��������� ���� ������, ��� ��� ��������� ����� �� ����������. ����������, ������� ������������ ����� � `$TargetFolder.`n" -ForegroundColor Red
    PressAnyKey
}
if ($Interval -lt 1) {
    Write-Host "`n�������� ��������� �� ����� ���� ����� 1 �������. ����������, ������� ������������� ����� � `$Interval.`n" -ForegroundColor Red
    PressAnyKey
}
Write-Host "���� ������������ ����� $($TargetFolder) �� ������� $($FileTypeReplace) ������. $($DeepScanIsOn)" -ForegroundColor Green
Write-Host "��������� �����: $($TargetFolder)`n��� ������: $($FileTypeReplace)`�������� ������������� (������������ ��������): $($DeepScanIsOn)`n�������� ������������: $($Interval) ���.`n" -ForegroundColor Gray
Write-Host "Ctrl + C - �����" -ForegroundColor DarkGray
while ($true) {
    $Executables = Get-ChildItem -Path $TargetFolder -Filter $FileType -File -Recurse: $DeepScan
    foreach ($key in $Executables) {
        $FileName = $key.FullName
        Write-Host "`n��������� $($FileTypeReplace) ���� $($FileName). ���� ������� ��������..." -ForegroundColor Red
        try {
            Remove-Item -Path $FileName -Force
            Write-Host "`n���� $($FileName) ��� ������� �������������.`n" -ForegroundColor Yellow
        }
        catch {
            Write-Warning "`n������ ��� �������� ����� $($FileName). ��������, ���� ��� ��������� ��� ������. $($_.Exception.Message)`n"
        }
    }
    Start-Sleep -Seconds $Interval
}

# -----------------------------------------------