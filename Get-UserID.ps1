# This code uses an input file called Users.csv that contains one column; all users work email addresses
# The script iterates over this file and GETS the AD SAMAccount name for that user and adds it into a result file called:
# C:\temp\Userid-Result.csv

# Start transcript
Start-Transcript -Path C:\Temp\get-userid.log -Append

# Import AD Module
Import-Module ActiveDirectory

# Import the data from CSV file and assign it to variable
$Users = Import-Csv "C:\Temp\Users.csv"

foreach ($User in $Users) {
    # Retrieve UPN
    $UPN = $User.WorkEmail

    # Retrieve UPN related SamAccountName
    $ADUser = Get-ADUser -Filter "UserPrincipalName -eq '$UPN'" | Select-Object SamAccountName

    # User from CSV not in AD
    if ($ADUser -eq $null) {
        Write-Host "$UPN does not exist in AD" -ForegroundColor Red
    }
    else {
	    Get-ADUser -Filter "UserPrincipalName -eq '$UPN'" | Select UserPrincipalName, SamAccountName | export-csv "C:\temp\Userid-Result.csv" -append -notypeinformation
        Write-Host "Retrieved $UPN login ID" -ForeGroundColor Green		
        }    
}
Stop-Transcript
