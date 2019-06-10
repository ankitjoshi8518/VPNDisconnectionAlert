
read-host -assecurestring | convertfrom-securestring | out-file C:\mysecurestring.txt      # Run this command first to save the Password for the Email account and note down the location of the txt file. Password will be stored Encrypted in the .txt file

$ipaddress = Read-Host -Prompt "Enter the IP Address to Monitor"
$username="<Enter your username here>"
$password=Get-Content 'C:\mysecurestring.txt' | ConvertTo-SecureString                      # Enter the path to .txt file created in step 1
$cred=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password       # saving the username and password
function sendmail
{
    Send-MailMessage -UseSsl -SmtpServer smtp.gmail.com -Port 587 -To <Email address> -From <Email address> -Credential $cred -Body "Corporate VPN Disconnected" -Subject "Dear Team, Corporate VPN has been disconnected. "
}
 
if ($ipaddress.Split('.').Length -eq 4)          # Check IF the entered IP Address is in the format X.X.X.X
{

"VALID IP ADDRESS FOUND"

"CHECKING IF THE IP ADDRESS IS REACHABLE ON THE NETWORK"

while(1)                                          #checking IF the IP address is reachable over the network continuously
{
    $pingdata=ping -n 10 $ipaddress
    if ($pingdata.Length -lt 16)                  # Length of valid response for 10 times ping is 17 and for failed response is 15.. checking if the IP address is responding
        {
            sendmail                              #send Email when the IP address is unreachable for consecutive 10 ping commands
            "IP ADDRESS UNREACHABLE. EMAIL SENT"
            break                                 #breaking the loop so that the Email is sent only once
        }
    else
        {
            "IP ADDRESS IS REACHABLE"
        }
}


}


