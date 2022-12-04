$hf=hostname

wmic computersystem get DNSHostName | Select-Object -skip 2 > $hf\excels.txt


quser | Select-Object -skip 1  > $hf\x2.txt

Get-Content $hf\x2.txt | ForEach-Object -Begin {$i = 1} -Process {
    Set-Variable "var${i}" ($_ -split ' ')[0]
    $i++
}

echo $var1 >> $hf\excels.txt

echo '  ' >> $hf\excels.txt

wmic computersystem get domain | Select-Object -skip 2 >> $hf\excels.txt

wmic os get caption | Select-Object -skip 2 >> $hf\excels.txt

wmic os get buildnumber | Select-Object -skip 2 >> $hf\excels.txt

wmic csproduct get identifyingnumber | Select-Object -skip 2 >> $hf\excels.txt
wmic csproduct get vendor | Select-Object -skip 2 >> $hf\excels.txt
wmic csproduct get version | Select-Object -skip 2 >> $hf\excels.txt

(systeminfo | Select-String 'Total Physical Memory:').ToString().Split(':')[1].Trim() >> $hf\excels.txt
echo '  ' >> $hf\excels.txt

wmic diskdrive get model | Select-Object -skip 2 | Select-Object -First 1 >> $hf\excels.txt
$gb = (wmic diskdrive get size | Select-Object -skip 2 | Select-Object -First 1)
($gb/1gb).ToString(".") >> $hf\excels.txt


echo '  ' >> $hf\excels.txt

wmic cpu get name | Select-Object -skip 2 >> $hf\excels.txt



wmic path SoftwareLicensingService get OA3xOriginalProductKey  | Select-Object -skip 2 >> $hf\excels.txt

Remove-Item $hf\x2.txt

exit