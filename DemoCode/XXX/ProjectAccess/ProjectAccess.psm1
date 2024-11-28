#region Get public and private function definition files.
$Public = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)
$Script:Configuration = get-content -Path "$PSScriptRoot\Config\configuration.json" | ConvertFrom-Json

#region Dot source the files
foreach ($import in @($Public + $Private)) {
    try {
        . $import.FullName
    }
    catch {
        Write-Error -Message "Failed to import function $($import.FullName): $_"
    }
}















#region argument completers
$projectFilter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $values = $Script:Configuration.projects.name | Select-Object -Unique
    return $values | Where-Object { $_ -like "$wordToComplete*" }
}
$databaseFilter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $project = $fakeBoundParameters['Project']
    $filteredProjects = $Script:Configuration.projects | Where-Object { $_.name -eq $project }
    $values = $filteredProjects.databases | Select-Object -Unique
    return $values | Where-Object { $_ -like "$wordToComplete*" }
}
Register-ArgumentCompleter -CommandName Get-ProjectAccess -ParameterName Project -ScriptBlock $projectFilter
Register-ArgumentCompleter -CommandName Get-ProjectAccess -ParameterName Database -ScriptBlock $databaseFilter
#endregion