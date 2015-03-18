#AD Import

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
Written by Daniel McVicker, based on a number of sources  
2013-07-24
