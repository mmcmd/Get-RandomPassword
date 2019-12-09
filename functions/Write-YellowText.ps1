function Write-YellowText{
    <#
    .SYNOPSIS
        Prints a message with a yellow foreground color and a black background color
    .DESCRIPTION
        Outputs to the console a message with a yellow foreground color and a black background color 
        without having to specify the parameters with Write-Host
    .EXAMPLE
        Write-YellowText -Message "This is yellow text with a black background"
    .INPUTS
        String
    .FUNCTIONALITY
        Useful for printing informational messages
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $message
    )
    Write-Host $message -ForegroundColor Yellow -BackgroundColor Black
}
