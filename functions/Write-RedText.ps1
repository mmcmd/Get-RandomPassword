function Write-RedText{ # Helper function to display text red with a black background to the console
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $message
    )
    Write-Host $message -ForegroundColor Red -BackgroundColor Black
    
}
