[cmdletbinding()]
param(
    [parameter(Mandatory = $true)]
    [ValidateSet('Customers', 'Orders', 'Secrets', 'Telemetry')]
    [string[]]$Database,

    [parameter(Mandatory = $false)]
    [ValidateSet('Read', 'Write', 'Admin')]
    [string]$AccessLevel = 'Read',

    [parameter(Mandatory = $false)]
    [ValidateRange(1, 12)]
    [int]$DeleteAfterHours = 2
)
try {
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