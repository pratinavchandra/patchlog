#Enable-PSRemoting -Force
$file="hosts.txt"
#credentials input and object creation
$user = Read-Host "Enter username" 
$pass= Read-Host "Enter password" -AsSecureString
$cred = New-Object System.Management.Automation.PSCredential($user, $pass)
echo "Generating report..."
#Extracting hosts and running commands on each server
$output=foreach($line in (Get-Content $file)){
      Set-Item WSMan:\localhost\Client\TrustedHosts -Value "$line" -Force
      Invoke-Command -ComputerName $line -ScriptBlock { get-hotfix } -credential $cred
      Invoke-Command -ComputerName $line -ScriptBlock { Get-CimInstance -ClassName win32_operatingsystem | select csname, lastbootuptime } -credential $cred
      echo " "
   }
#Writing output to text file   
$output | tee output.txt   
echo "Report saved - hotfix-output.txt"