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