[cmdletbinding()]
param (
    [Parameter(Mandatory = $true)]
    [ArgumentCompleter({
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

        $json = Get-Content -Path "$PSScriptRoot\configuration.json" | ConvertFrom-Json
        $values = $json.projects.name | Select-Object -Unique
        
        Write-Host "`ncommandName: $commandName"
        Write-Host "parameterName: $parameterName"
        Write-Host "wordToComplete: $wordToComplete"
        Write-Host "commandAst: $commandAst"
        Write-Host "fakeBoundParameters: $($fakeBoundParameters | ConvertTo-Json -Depth 10)"

        return $values | Where-Object { $_ -like "$wordToComplete*" }
    })]
    [string]$Project,

    [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'The database(s) to grant access to.')]
    [ArgumentCompleter({
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

        $project = $fakeBoundParameters['Project']
        $json = Get-Content -Path "$PSScriptRoot\configuration.json" | ConvertFrom-Json

        $filteredProjects = $json.projects | Where-Object { $_.name -eq $project }
        $values = $filteredProjects.databases | Select-Object -Unique

        Write-Host "`ncommandName: $commandName"
        Write-Host "parameterName: $parameterName"
        Write-Host "wordToComplete: $wordToComplete"
        Write-Host "commandAst: $commandAst"
        Write-Host "fakeBoundParameters: $($fakeBoundParameters | ConvertTo-Json -Depth 10)"

        return $values | Where-Object { $_ -like "$wordToComplete*" }
    })]
    [string]$Database,

    [Parameter(Mandatory=$false)]
    [ValidateSet('Read', 'ReadWrite')]
    [string]$AccessLevel = 'Read',

    [Parameter(Mandatory=$false)]
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