[cmdletbinding()]
param(
    [parameter(Mandatory = $false)]
    [string]$AccessLevel = 'Read',

    [parameter(Mandatory = $false)]
    [int]$DeleteAfterHours = 2
)

DynamicParam {
    $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
    $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

    $mandatoryAttribute = New-Object System.Management.Automation.ParameterAttribute
    $mandatoryAttribute.Mandatory = $true
    $attributeCollection.Add($mandatoryAttribute)

    $allowedDatabases = Get-Content "$PSScriptRoot\databases.json" | ConvertFrom-Json
    $validateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($allowedDatabases.databases)
    $attributeCollection.Add($validateSetAttribute)

    $runtimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter('Database', [string[]], $attributeCollection)
    $paramDictionary.Add('Database', $runtimeParameter)

    return $paramDictionary
}

begin {
    $Database = $PSBoundParameters['Database']
}

process {
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
end {
    Write-Output "Script completed"
}