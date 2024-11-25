#region dbAccess
function New-DbAccess {
    param(
        [string]$Database,
        [string]$AccessLevel
    )
    return @{
        Database    = $Database
        AccessLevel = $AccessLevel
    }
}
#endregion
#region validate parameters
function Invoke-ValidateParameters {
    param(
        [string]$Project,
        [string]$Database
    )
    $config = Get-Content -Path "$PSScriptRoot\configuration.json" | ConvertFrom-Json

    if (-not ($config.projects.name -contains $Project)) {
        throw "Invalid Project value: $Project"
    }

    $projectDatabases = ($config.projects | Where-Object { $_.name -eq $Project }).databases
    if (-not ($projectDatabases -contains $Database)) {
        throw "Invalid Database value: $Database"
    }
}
#endregion
function Get-EnvironmentConfiguration {
    $irmParams = @{
        Method = 'Get'
        Uri    = 'https://gist.githubusercontent.com/tabs-not-spaces/6503b302cf451c1bd43c19184cb46940/raw/5e3dbcb59ccb084d28ac542440e5e245d009f42c/environments.json'
    }
    return Invoke-RestMethod @irmParams
}
function Get-ProjectNames {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $json = Get-EnvironmentConfiguration
    $values = $json.projects.name | Select-Object -Unique
    return $values | Where-Object { $_ -like "$wordToComplete*" }
}

function Get-DatabaseNames {
    param($project, $wordToComplete)
    $json = Get-EnvironmentConfiguration
    $filteredProjects = $json.projects | Where-Object { $_.name -eq $project }
    $values = $filteredProjects.databases | Select-Object -Unique
    return $values | Where-Object { $_ -like "$wordToComplete*" }
}