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
.PARAMETER Words
    Number of words that the password will contain. The default is 3. Example: "car-HORSE-staple" is a 3 word password
.PARAMETER Delimiter
    Separator for the passwords. Default is a dash (-). Example: "car!HORSE!staple" the delimiter here would be the exclamation point (!)
.Parameter Count
    Number of passwords you want generated. Default is 3.
.PARAMETER short
    Specifies to take from the list of short words (1-4 characters long)
.PARAMETER medium
    Specifies to take from the list of medium words (5-8 characters long) (default if no list is specified)
.PARAMETER long
    Specifies to take from the list of long words (9+ characters long)
.NOTES
    General notes # To do later
.FUNCTIONALITY
    The functionality that best describes this cmdlet # To do later
#>

[CmdletBinding(DefaultParameterSetName="-medium")]
param (
    [Parameter(Mandatory=$false,Position=0,ParameterSetName="Words")] # Number of words that the password will contain. Default is 3
    [int]
    $Words,
    [Parameter(Mandatory=$false,Position=1,ParameterSetName="Delimiter")] # Delimiter for the words. Default is a dash (-)
    [ValidateNotNullOrEmpty]
    [string]
    $Delimiter,
    [Parameter(Mandatory=$false,Position=2,ParameterSetName="Count")]
    [int]
    $Count,
    [Parameter(Mandatory=$false,Position=3,ParameterSetName="-short")] # Selects short words (1-4 chars)
    [switch]
    $short,
    [Parameter(Mandatory=$false,Position=4, ParameterSetName="-medium")] # Selects medium words (5-8 chars)
    [switch]
    $medium,
    [Parameter(Mandatory=$false,Position=5, ParameterSetName="-long")] # Selects long words (9+ chars)
    [switch]
    $long
)

$PSDefaultParameterValues=@{ # Default values for the parameters
    "Get-RandomPassword:Words"=3;
    "Get-RandomPassword:Delimiter"="-";
    "Get-RandomPassword:Count"=3;
    "Get-RandomPassword:short"=$false;
    "Get-RandomPassword:medium"=$true;
    "Get-RandomPassword:long"=$false
}

$ErrorActionPreference = "Stop"



function Send-YellowText{ # Helper function to display text yellow with a black background to the console
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $message
    )
    Write-Host $message -ForegroundColor Yellow -BackgroundColor Black
}

function Send-RedText{ # Helper function to display text red with a black background to the console
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $message
    )
    Write-Host $message -ForegroundColor Red -BackgroundColor Black
    
}

function Send-ErrorMessage{ # Helper function to display an error message to the console
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Message
    )
    Send-RedText -message $Message
    Send-RedText($Error[0].Exception.Message)
    Send-RedText("Error category: $($Error[0].Exception.GetType().Name)")
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

function Get-XPasswords{  # Helper function to get passwords based on the length of each word and also to get a certain number of passowrds

}


function Get-RandomPassword{
    [CmdletBinding(DefaultParameterSetName="-medium")]
    param (
        [Parameter(Mandatory=$false,Position=0)] # Number of words that the password will contain. Default is 3
        [int]
        $Words,
        [Parameter(Mandatory=$false,Position=1)] # Delimiter for the words. Default is a dash (-)
        [string]
        $Delimiter,
        [Parameter(Mandatory=$false,Position=2)]
        [int]
        $Count,
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


    try{
        Send-YellowText -message "Importing dictionnaries"
        $longpassword = Get-Content -Path "$PSScriptRoot\ressources\google-10000-english-usa-no-swears-long.txt"
        $mediumpassword = Get-Content -Path "$PSScriptRoot\ressources\google-10000-english-usa-no-swears-medium.txt"
        $shortpassword = Get-Content -Path "$PSScriptRoot\ressources\google-10000-english-usa-no-swears-short.txt"
    }
    catch [ItemNotFoundException]{
        Send-RedText("The required dictionnary files are not present. Please make sure the required files are in the ressources folder.")
    }
    catch{
        Send-ErrorMessage -Message "An error occured importing the dictionaries! See below for more information:"
    }

    if ($short -eq $true){
        try{
            $random_words = Get-Random -Count $Words -InputObject $shortpassword
            Add-Delimiter -random_words $random_words -Delimiter $Delimiter
        }
        catch{
            Send-ErrorMessage -message "Error occured generating the password. See message below:"
        }
    }

    if ($medium -eq $true){
        try{
            $random_words = Get-Random -Count $Words -InputObject $mediumpassword
            Add-Delimiter -random_words $random_words -Delimiter $Delimiter
        }
        catch{
            Send-ErrorMessage -message "Error occured generating the password. See message below:"
        }
    }
    if ($long -eq $true){
        try{
            $random_words = Get-Random -Count $Words -InputObject $longpassword
            Add-Delimiter -random_words $random_words -Delimiter $Delimiter
        }
        catch{
            Send-ErrorMessage -message "Error occured generating the password. See message below:"
        }
    }

}

