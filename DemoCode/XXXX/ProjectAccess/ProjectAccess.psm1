#region Get public and private function definition files.
$Public = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)

#region Dot source the files
foreach ($import in @($Public + $Private)) {
    try {
        . $import.FullName
    }
    catch {
        Write-Error -Message "Failed to import function $($import.FullName): $_"
    }
}

$Script:Configuration = Get-EnvironmentConfiguration









#region argument completers
# [ArgumentCompleter({
#     param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
#     Invoke-ProjectNameCompleter -wordToComplete $wordToComplete
# })]
#endregion