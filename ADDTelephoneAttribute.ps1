# This code iterates over an input file called C:\Temp\usersTelephone.csv reads the work email and adds the office phone number into AD
# the input file contains two columns; one with the workemail and one with the phone number
# Import the Active Directory module

Import-Module ActiveDirectory

# Specify the path to the CSV file
$csvPath = "C:\Temp\usersTelephone.csv"

# Read the CSV file
$users = Import-Csv -Path $csvPath

# Loop through each user in the CSV file
foreach ($user in $users) {
    # Retrieve the work email and telephone number from the CSV
    $workEmail = $user.WorkEmail
    $telephoneNumber = $user.TelephoneNumber

    # Find the user in Active Directory by the work email
    $adUser = Get-ADUser -Filter "EmailAddress -eq '$workEmail'"

    # Check if the user exists in Active Directory
    if ($adUser) {
        # Set the telephone number for the user
        $adUser | Set-ADUser -OfficePhone $telephoneNumber

        Write-Host "Telephone number set for user: $($adUser.Name)"
    } else {
        Write-Host "User with work email '$workEmail' not found in Active Directory."
    }
}
