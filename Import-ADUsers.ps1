<#
.SYNOPSIS
Import-ADUsers.ps1 takes an input .csv and creates users as a batch.
.DESCRIPTION
Import-ADUsers.ps1 creates a password, builds a username from the CSV, then creates a user. 
.PARAMETER domain 
Examples:
$Domain=’@contoso.com'
.PARAMETER InCSV
$InCSV="C:\Users\mcvicker\Desktop\ADImport2013\Input\test.csv"
.PARAMETER OutCSV
$OutCSV="C:\Users\mcvicker\Desktop\ADImport2013\Output\UserPass.csv"
.PARAMETER Container
$Container='ad.cusys.edu/Accounts/External'
.PARAMETER DC
$DC='dc01.contoso.com'
.EXAMPLE
Import-ADUsers 
.NOTES

Written by Dan McVicker, based on a number of sources
2013-07-24
#>

# Put our Domain name, DC, and parent container of the accounts we want to create into Placeholders
params (

$Domain='contoso.com'

#domain name

$DC='dc01.contoso.com' 

#name of your DC

$Container='contoso.com/Accounts/External'

#container to create accounts in

$InCSV="C:\ADImport\Input\test.csv"

#the csv to run the import from

$OutCSV="C:\ADImport\Output\UserPass.csv"

#the csv to export to.
)

# Get credentials

$Credentials=GET-CREDENTIAL

#------------------------------

# Begin Create Password Function

#------------------------------

function CreatePassword([int]$length)

{

   $specialCharacters = "!@#$%^&*()_+-"

   $lowerCase = "abcdefghijklmnopqrstuvwxyz"

   $upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

   $numbers = "1234567890"

   $res = ""

   $rnd = New-Object System.Random

   do

   {

       $flag = $rnd.Next(4);

       if ($flag -eq 0)

       {$res += $specialCharacters[$rnd.Next($specialCharacters.Length)];

       } elseif ($flag -eq 1)

       {$res += $lowerCase[$rnd.Next($lowerCase.Length)];

       } elseif ($flag -eq 2)

       {$res += $upperCase[$rnd.Next($upperCase.Length)];

       } else

       {$res += $numbers[$rnd.Next($numbers.Length)];

       }

   } while (0 -lt $length--)

   return $res

}

#------------------------------

# End Password Function

#------------------------------


# Import list of Users From CSV into $Userlist

$UserList=IMPORT-CSV $InCSV 

# Step through Each Item in the List

FOREACH ($Person in $UserList) {

# Build Username from Login field

$Username=$Person.LoginName

# Build the User Principal Name Username with Domain added to it

$UPN=$Username+$Domain

# Create the Displayname

$Name="$Person.Firstname+” “+$Person.Lastname"

# Generate Password

$UserPass = createpassword 10

# Wait 250ms so that next Pseudorandom password is unique 

start-sleep -m 250   

# Create User in Active Directory

NEW-ADUSER –Name $Username –FirstName $Person.Firstname –Lastname $Person.Lastname -DisplayName $Name –credential $Credentials  –UserPassword $UserPass –UserPrincipalName $UPN  –ParentContainer $Container

# Output Password Information

$ExportInfo = $Name,$UPN,$UserPass

$ExportInfo -join "," >> $OutCSV

}

# Disconnect from Domain

 Disconnect-QADService -service $DC -credential $Credentials