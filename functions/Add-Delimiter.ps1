function Add-Delimiter{ # Helper function that converts the list of words into a usable password - also adds the delimiter
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $Source,
        [Parameter(Mandatory=$true)]
        [string]
        $DelimiterParameter
    )
    
    $sanitized = $Source -Join " "
    $sanitized = $sanitized.Replace(" ","$DelimiterParameter")
    return $sanitized
}
