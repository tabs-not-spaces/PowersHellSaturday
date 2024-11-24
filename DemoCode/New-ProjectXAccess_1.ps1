[cmdletbinding()]
param(
    [parameter(Mandatory = $true)]
    [string[]]$Database,

    [parameter(Mandatory = $false)]
    [string]$AccessLevel = 'Read',

    [parameter(Mandatory = $false)]
    [int]$DeleteAfterHours = 2
)
try {
    $allowedDatabaseNames = "Customers", "Orders", "Secrets", "Telemetry"
    $newUser = @{
        UserName         = "$($env:USER)_Temp"
        Password         = (New-Guid).Guid
        DeleteAfterHours = $DeleteAfterHours
    }
    $dbs = @()
    foreach ($db in $Database) {
        # if the database name provided doesnt match the allowed names including case sensitivity, throw an error
        if ($allowedDatabaseNames -cnotcontains $db) {
            throw "Database $db is not allowed. Allowed databases are: $($allowedDatabaseNames -join ', ')"
        }
        $dbs += @{
            Database    = $db
            AccessLevel = $AccessLevel
        }
    }
    $newUser.Databases = $dbs
    ## Send the request to the database api - we don't know how this works yet, so let's just display the request data.
    return $($newUser | ConvertTo-Json -Depth 10)
}
catch {
    Write-Warning $_.Exception.Message
}