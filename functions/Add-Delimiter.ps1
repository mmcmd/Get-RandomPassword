function Add-Delimiter{ # Helper function that converts the list of words into a usable password - also adds the delimiter
    <#
    .SYNOPSIS
        Helper function to concatenate and delimit each word
    .DESCRIPTION
        Helper function that converts the list of words into a usable password - also adds the delimiter
    .PARAMETER Source
        A set of words separated by spaces
    .PARAMETER DelimiterParameter
        The delimiter that separates each word
    .EXAMPLE
        Add-Delimiter -Source "mmcmd POWERSHELL SCRIPT" -Delimiter -
    .COMPONENT
        Get-RandomPassword
    #>
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
