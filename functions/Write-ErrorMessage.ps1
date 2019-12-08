function Write-ErrorMessage{ # Helper function to display an error message to the console
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Message
    )
    Write-RedText -message $Message
    Write-RedText($Error[0].Exception.Message)
    Write-RedText("Error category: $($Error[0].Exception.GetType().Name)")
}
