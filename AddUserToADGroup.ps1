# this file uses an input file called Users.csv. This file contains one column; all the email addresses of the users that need adding to the EXXON-Jabber-Group
# AD security group.  the scipt will also create a log file for the job. the AD group the users are added to is called "EXXON - Jabber" so you can change
# to your own liking.
# Start transcript
Start-Transcript -Path C:\Temp\Add-ADUsers-To-EXXON-Jabber-Group.log -Append

# Import AD Module
Import-Module ActiveDirectory

# Import the data from CSV file and assign it to variable
$Users = Import-Csv "C:\Temp\Users.csv"

# Specify target group name (pre-Windows 2000) where the users will be added to
# You can add the distinguishedName of the group. For example: CN=Exxon - Kabber,OU=MHP Groups,OU=EXXON,DC=diesel,DC=org,DC=au
$Group = "EXXON - Jabber"

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
        # Retrieve AD user group membership
        $ExistingGroups = Get-ADPrincipalGroupMembership $ADUser.SamAccountName | Select-Object Name

        # User already member of group
        if ($ExistingGroups.Name -eq $Group) {
            Write-Host "$UPN already exists in $Group" -ForeGroundColor Yellow
        }
        else {
            # Add user to group
            Add-ADGroupMember -Identity $Group -Members $ADUser.SamAccountName
            Write-Host "Added $UPN to $Group" -ForeGroundColor Green
        }
    }
}
Stop-Transcript