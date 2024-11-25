[cmdletbinding()]
param (
    [Parameter(Mandatory = $true)]
    [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            . "$PSScriptRoot\functions.ps1"
            return Get-ProjectNames -wordToComplete $wordToComplete
        })]
    [string]$Project,

    [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'The database(s) to grant access to.')]
    [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            $project = $fakeBoundParameters['Project']
            . "$PSScriptRoot\functions.ps1"
            return Get-DatabaseNames -project $project -wordToComplete $wordToComplete
        })]
    [string]$Database,

    [Parameter(Mandatory = $false)]
    [ValidateSet('Read', 'ReadWrite')]
    [string]$AccessLevel = 'Read',

    [Parameter(Mandatory = $false)]
    [ValidateRange(1, 12)]
    [int]$DeleteAfterHours = 2
)

# Load functions
. "$PSScriptRoot\functions.ps1"

# Validate parameters
Invoke-ValidateParameters -Project $Project -Database $Database -AccessLevel $AccessLevel

try {
    $newUser = @{
        UserName         = "$($env:USER)_Temp"
        Password         = (New-Guid).Guid
        DeleteAfterHours = $DeleteAfterHours
        Databases        = $(foreach ($db in $Database) { New-DbAccess -Database $db -AccessLevel $AccessLevel })
    }
    ## Send the request to the database api - we don't know how this works yet, so let's just display the request data.
    return $($newUser | ConvertTo-Json -Depth 10)
}
catch {
    Write-Warning $_.Exception.Message
}