function New-DbAccess {
    param(
        [string]$Project,
        [string]$Database,
        [string]$AccessLevel
    )
    return [PSCustomObject]@{
        Project     = $Project
        Database    = $Database
        AccessLevel = $AccessLevel
    }
}

function Get-EnvironmentConfiguration {
    $irmParams = @{
        Method = 'Get'
        Uri    = 'https://gist.githubusercontent.com/tabs-not-spaces/6503b302cf451c1bd43c19184cb46940/raw/5e3dbcb59ccb084d28ac542440e5e245d009f42c/environments.json'
    }
    return Invoke-RestMethod @irmParams
}

function Invoke-ProjectNameCompleter {
    param($WordToComplete)
    Write-Host "Searching for: $WordToComplete"
    $values = $script:Configuration.projects.name | Select-Object -Unique
    return $values | Where-Object { $_ -like "$WordToComplete*" }
}

function Invoke-DatabaseNameCompleter {
    param($project, $wordToComplete)
    $filteredProjects = $script:Configuration.projects | Where-Object { $_.name -eq $project }
    $values = $filteredProjects.databases | Select-Object -Unique
    return $values | Where-Object { $_ -like "$wordToComplete*" }
}

function Invoke-ValidateParameters {
    param(
        [string]$Project,
        [string]$Database
    )

    if (-not ($Script:Configuration.projects.name -contains $Project)) {
        throw "Invalid Project value: $Project"
    }

    $projectDatabases = ($Script:Configuration.projects | Where-Object { $_.name -eq $Project }).databases
    if (-not ($projectDatabases -contains $Database)) {
        throw "Invalid Database value: $Database"
    }
}