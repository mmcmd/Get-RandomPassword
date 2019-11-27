<#
.SYNOPSIS
    Generates a random password using random common words
.DESCRIPTION
    This cmdlet generates a series of random words which are easy to remember and have fairly high entropy. Based on the xkcd comic (https://xkcd.com/936/)
    Short words: 1 to 4 characters long
    Medium words: 5-8 characters long (default)
    Long words: 9+ characters long
.EXAMPLE
    Get-RandomPassword -Words 3
.EXAMPLE
    Get-RandomPassword -Words 5 -Delimiter "-"
.NOTES
    General notes # To do later
.FUNCTIONALITY
    The functionality that best describes this cmdlet # To do later
#>

[CmdletBinding(DefaultParameterSetName="-medium")]
param (
    [Parameter(Mandatory=$false,Position=0)] # Number of words that the password will contain. Default is 3
    [int]
    $Words,
    [Parameter(Mandatory=$false,Position=1)] # Delimiter for the words. Default is a dash (-)
    [string]
    $Delimiter,
    [Parameter(Mandatory=$false,Position=2,ParameterSetName="-short")] # Selects short words (1-4 chars)
    [switch]
    $short,
    [Parameter(Mandatory=$false,Position=3, ParameterSetName="-medium")] # Selects medium words (5-8 chars)
    [switch]
    $medium,
    [Parameter(Mandatory=$false,Position=4, ParameterSetName="-long")] # Selects long words (9+ chars)
    [switch]
    $long
)

$ErrorActionPreference = "Stop"



function Yellow-Text{ # Helper function to make text yellow with a black background
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $message
    )
    Write-Host $message -ForegroundColor Yellow -BackgroundColor Black
}

function Red-Text{ # Helper function to make text red with a black background
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $message
    )
    Write-Host $message -ForegroundColor Red -BackgroundColor Black
    
}

function Error-Message{ # Helper function to display an error message
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Message
    )
    Red-Text -message $Message
    Red-Text($Error[0].Exception.Message)
    Red-Text("Error category: $($Error[0].Exception.GetType().Name)")
}

function Add-Delimiter{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $random_words,
        [Parameter(Mandatory=$true)]
        [string]
        $Delimiter
    )
    
    $sanitized = $random_words -Join " "
    $sanitized.Replace(" ","$delimiter")
    $sanitized
}


function Import-Dictionnary{
    try{
        Yellow-Text("Importing dictionaries")
        $longpassword = Get-Content -Path "$PSScriptRoot\ressources\google-10000-english-usa-no-swears-long.txt"
        $mediumpassword = Get-Content -Path "$PSScriptRoot\ressources\google-10000-english-usa-no-swears-medium.txt"
        $shortpassword = Get-Content -Path "$PSScriptRoot\ressources\google-10000-english-usa-no-swears-short.txt"
    }
    catch [ItemNotFoundException]{
        Red-Text("The required dictionnary files are not present. Please make sure the required files are in the ressources folder.")
    }
    catch{
        Red-Text("An error occured importing the dictionaries! See below for more information:")
        Error-Message
    }
}

function Get-RandomPassword{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [TypeName]
        $ParameterName
    )
    Import-Dictionnary

    if ($medium -eq $true -and $long -eq $true){
        throw "Too many switches were given"
    }
    if ($medium -eq $true -and $short -eq $true){
        throw "Too many switches were given"
    }
    if ($short -eq $true -and $long -eq $true){
        throw "Too many switches were given"
    }
    if ($short -eq $true -and $medium -eq $true -and $long -eq $true){
        throw "Too many switches were given"
    }

    if ($medium -eq $true){
        try{
            $random_words = Get-Random -Count $Words -InputObject $mediumpassword
        }
        catch{
            Write-Host "Error occured generating the password. See message below:" -ForegroundColor Red -BackgroundColor Black
            Error-Message -message "Error occured generating the password. See message below:"
        }
    }
    if ($short -eq $true){
        try{
            $random_words = Get-Random -Count $Words -InputObject $shortpassword
        }
        catch{
            Write-Host "Error occured generating the password.  See message below:"
            Error-Message -message "Error occured generating the password. See message below:"
        }
    }
    if ($long -eq $true){
        try{
            $random_words = Get-Random -Count $Words -InputObject $shortpassword
        }
        catch{
            Red-Text -message "Error occured generating the password. See message below:"
        }
    }

}
