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

#region remote configuration
function Get-EnvironmentConfiguration {
    $irmParams = @{
        Method = 'Get'
        Uri    = 'https://gist.githubusercontent.com/tabs-not-spaces/6503b302cf451c1bd43c19184cb46940/raw/5e3dbcb59ccb084d28ac542440e5e245d009f42c/environments.json'
    }
    $script:environmentJson = Invoke-RestMethod @irmParams
}
function Invoke-ProjectNameCompleter {
    param($wordToComplete)
    if ($null -eq $script:environmentJson) {
        Get-EnvironmentConfiguration
    }
    $values = $script:environmentJson.projects.name | Select-Object -Unique
    return $values | Where-Object { $_ -like "$wordToComplete*" }
}

function Invoke-DatabaseNameCompleter {
    param($project, $wordToComplete)
    if ($null -eq $script:environmentJson) {
        Get-EnvironmentConfiguration
    }
    $filteredProjects = $script:environmentJson.projects | Where-Object { $_.name -eq $project }
    $values = $filteredProjects.databases | Select-Object -Unique
    return $values | Where-Object { $_ -like "$wordToComplete*" }
}
#endregion