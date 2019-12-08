function Write-YellowText{ # Helper function to display text yellow with a black background to the console
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $message
    )
    Write-Host $message -ForegroundColor Yellow -BackgroundColor Black
}
