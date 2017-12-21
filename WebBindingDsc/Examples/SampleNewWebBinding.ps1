Configuration NewWebBinding
{
    param
	(
        [Parameter(Mandatory = $false)]
		[pscredential]$ComputerName,
        [Parameter(Mandatory = $true)]
		[pscredential]$Credential
	)

    Import-DscResource -ModuleName WebBindingDsc

    Node $ComputerName
    {
        WebBinding NewWebBinding
        {
            Name = $Node.Name
            Protocol = $Node.Protocol
            Port = $Node.Port
            IPAddress = $Node.IPAddress
            HostHeader = $Node.HostHeader
            SslFlags = $Node.SslFlags
            Ensure = 'Present'
            PsDscRunAsCredential = $Credential
        }
    }
}

$ConfigData = @{
    AllNodes = @(
        @{
            Name = 'contoso'
            Protocol = 'https'
            Port = '443'
            IPAddress = '192.168.100.100'
            HostHeader = 'www.contoso.com'
            SslFlags = '3' 
            PsDscAllowPlainTextPassword = $true
            PsDscAllowDomainUser = $true
        }
    )
}

NewWebBinding -ComputerName $ComputerName -ConfigurationData $ConfigData -OutputPath C:\dsc
Start-DscConfiguration -Path C:\dsc -Wait -Verbose