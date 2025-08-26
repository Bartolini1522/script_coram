Import-Module ActiveDirectory

# Soglia: 6 mesi fa
$threshold = (Get-Date).AddMonths(-6)

# Prendi tutti gli utenti con un LastLogonDate valorizzato
Get-ADUser -Filter {Enabled -eq $true -and lastLogonTimestamp -like "*"} `
    -Properties lastLogonTimestamp, SamAccountName, Enabled |
    Where-Object {
        $_.lastLogonTimestamp -ne $null -and
        ([DateTime]::FromFileTime($_.lastLogonTimestamp) -lt $threshold)
    } |
    Select-Object Name, SamAccountName,
        @{Name='LastLogonDate';Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}},
        Enabled |
    Export-Csv "C:\Users\lorenzo.delforno\Desktop\utenti_inattivi.csv" -NoTypeInformation -Encoding UTF8
