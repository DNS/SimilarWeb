
<# 
Requirements (always use the latest version):
    Firefox - https://download.mozilla.org/?product=firefox-esr-latest-ssl&os=win64&lang=en-US
    geckodriver.exe - https://github.com/mozilla/geckodriver/releases/latest
    WebDriver.dll - https://www.nuget.org/api/v2/package/Selenium.WebDriver/
#> 

#[System.Reflection.Assembly]::LoadFrom('D:\BIN\WebDriver.dll')
Import-Module 'D:\BIN\WebDriver.dll'
#Import-Module '.\WebDriver.dll'



#Clear-Host

if (-not $args[0]) {
    Write-Host "usage:`n    .\similarweb.ps1 website.com"
    exit
}

$FirefoxOptions = New-Object OpenQA.Selenium.Firefox.FirefoxOptions
$FirefoxOptions.AcceptInsecureCertificates = $true

# Sets GeckoDriver log level to Fatal
$FirefoxOptions.LogLevel = [OpenQA.Selenium.Firefox.FirefoxDriverLogLevel]::Error
$FirefoxOptions.AddArgument('--log-level 1')


#$FirefoxOptions.AddArgument('> NUL')
$FirefoxOptions.AddArgument('--headless')   # hide browser window

# 0: Unknown, 1: Allow, 2: Deny, 3: Prompt action
$FirefoxOptions.SetPreference('permissions.default.camera', 2)
$FirefoxOptions.SetPreference('permissions.default.desktop-notification', 2)
$FirefoxOptions.SetPreference('permissions.default.geo', 2)
$FirefoxOptions.SetPreference('permissions.default.image', 2)
$FirefoxOptions.SetPreference('permissions.default.microphone', 2)
$FirefoxOptions.SetPreference('permissions.default.shortcuts', 2)
$FirefoxOptions.SetPreference('permissions.default.xr', 2)

$FirefoxOptions.SetPreference('media.autoplay.block-event.enabled', $true)
$FirefoxOptions.SetPreference('media.autoplay.block-webaudio', $true)
$FirefoxOptions.SetPreference('media.autoplay.blocking_policy', 2)
$FirefoxOptions.SetPreference('media.autoplay.default', 5)

$FirefoxDriver = New-Object OpenQA.Selenium.Firefox.FirefoxDriver -ArgumentList $FirefoxOptions

$result =  [System.Collections.ArrayList] @()

function GetPageSource ($w) {
    $FirefoxDriver.Url = 'https://www.similarweb.com/website/' + $w
    $s = $FirefoxDriver.PageSource

    $m = $s -imatch '(?ims)globalRank\"\:(\d+?)\,.*?countryUrlCode\"\:\"(.*?)\"\,.*?countryRank\"\:(\d*?)\,'

    if ($m) {
        $h = [ordered] @{
            'Website'      = $w;
            'Global Rank'  = $Matches[1];
            'Country'      = (Get-Culture).TextInfo.ToTitleCase($Matches[2]);
            'Country Rank' = $Matches[3];
        }

        $result.Add( [pscustomobject] $h ) > $null

    } else {
        Write-Host $w 'not ranked'
    }
    #Start-Sleep 3
}


foreach ($w in $args) {
    GetPageSource($w)
}

$result


$FirefoxDriver.Close()
$FirefoxDriver.Quit()