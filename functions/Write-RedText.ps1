function Write-RedText{
    <#
    .SYNOPSIS
        Prints a message with a red foreground color and a black background color
    .DESCRIPTION
        Outputs to the console a message with a red foreground color and a black background color
        without having to specify the parameters with Write-Host
    .EXAMPLE
        Write-RedText -Message "This is red text with a black background"
    .INPUTS
        String
    .FUNCTIONALITY
        Useful for printing warning messages
    #>   
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $message
    )
    Write-Host $message -ForegroundColor Red -BackgroundColor Black
    
}
