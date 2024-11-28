function Get-ProjectAccess {
    [cmdletbinding()]
    param(
        [parameter(Mandatory = $true)]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            $script:Configuration = $script:Configuration ?? $(Get-EnvironmentConfiguration)
            Invoke-ProjectNameCompleter -WordToComplete $wordToComplete
        })]
        [string]$Project,

        [parameter(Mandatory = $true)]
        [string[]]$Database,

        [parameter(Mandatory = $false)]
        [ValidateSet('Read', 'ReadWrite')]
        [string]$AccessLevel = 'Read',

        [parameter(Mandatory = $false)]
        [ValidateRange(1, 12)]
        [int]$DeleteAfterHours = 2
    )
    try {
        $newUser = @{
            UserName         = "$($env:USER ?? $env:USERNAME)_Temp"
            Password         = (New-Guid).Guid
            DeleteAfterHours = $DeleteAfterHours
            Databases        = $(foreach ($db in $Database) { New-DbAccess -Project $Project -Database $db -AccessLevel $AccessLevel })
        }
        ## Send the request to the database api - we don't know how this works yet, so let's just display the request data.
        return $($newUser | ConvertTo-Json -Depth 10)
    }
    catch {
        Write-Warning $_.Exception.Message
    }
}