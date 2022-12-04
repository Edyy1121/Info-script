
$excels=(gc .\excels.txt)
Add-Content .\excel.txt `t$excels`

echo 'Computer Name  User  Domain  Operating System  Version  Serial  Vendor  Model  Total Ram  HDD Model  HDD Size  Processor  Windows License' > excel3.txt

(gc excel.txt) -replace  '19043', '21H1' | Out-File -encoding ASCII excel1.txt
(gc excel1.txt) -replace  '19042', '20H2' | Out-File -encoding ASCII excel1.txt
(gc excel1.txt) -replace  '19041', '2004' | Out-File -encoding ASCII excel1.txt
(gc excel1.txt) -replace  '18363', '1909' | Out-File -encoding ASCII excel1.txt
(gc excel1.txt) -replace  '18362', '1903' | Out-File -encoding ASCII excel1.txt
(gc excel1.txt) -replace  '17763', '1809' | Out-File -encoding ASCII excel1.txt
(gc excel1.txt) -replace  '17134', '1803' | Out-File -encoding ASCII excel1.txt
(gc excel1.txt) -replace  '16299', '1709' | Out-File -encoding ASCII excel1.txt
(gc excel1.txt) -replace  '15063', '1703' | Out-File -encoding ASCII excel1.txt
(gc excel1.txt) -replace  '14393', '1607' | Out-File -encoding ASCII excel1.txt
(gc excel1.txt) -replace  '10586', '1511' | Out-File -encoding ASCII excel1.txt
(gc excel1.txt) -replace  '19044', '21H2' | Out-File -encoding ASCII excel1.txt
(gc excel1.txt) -replace  '19045', '22H2' | Out-File -encoding ASCII excel1.txt
(gc excel1.txt) -replace  '22000', '21H2' | Out-File -encoding ASCII excel1.txt
(gc excel1.txt) -replace  '22621', '22H2' | Out-File -encoding ASCII excel1.txt

Remove-Item .\excel.txt


(gc excel3.txt) -replace  '  ', ';' | Out-File -encoding ASCII excelx.txt
(gc excel1.txt) -replace  '  ', ';' | Out-File -encoding ASCII excel2.txt

gc .\excel2.txt | echo >> excelx.txt



$oXL = New-Object -comobject Excel.Application; $oXL.Visible = $true; $oXL.DisplayAlerts = $False; $file = (Get-Item .).FullName + '\excelx.txt'; $oXL.workbooks.OpenText($file,437,1,1,1,$True,$False,$True,$False,$False,$False)
Remove-Item .\excel1.txt
Remove-Item .\excel2.txt
Remove-Item .\excel3.txt

exit