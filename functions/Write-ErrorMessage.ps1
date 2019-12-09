function Write-ErrorMessage{
    <#
    .SYNOPSIS
        Prints a user-friendly error message
    .DESCRIPTION
        Writes a simple error message without a sea of red text
    .EXAMPLE
        Write-ErrorMessage -Message "An error occured doing x! See error message below:"
    .INPUTS
        Location where the error occured
    .OUTPUTS
        Information about where the error occured as well as the error message 
        and error category associated with it
    .FUNCTIONALITY
        Useful for printing error messages with sufficient details without being a sea of red text
    #>
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
