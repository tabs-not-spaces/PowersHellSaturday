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