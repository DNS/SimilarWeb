
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

$FirefoxDriver.Url = 'https://www.similarweb.com/website/' + $args[0]

$s = $FirefoxDriver.PageSource
#Write-Host $FirefoxDriver.PageSource

#Start-Sleep -Seconds 10

$FirefoxDriver.Close()
$FirefoxDriver.Quit()


$m = $s -imatch '(?ims)globalRank\"\:(\d+?)\,.*?countryUrlCode\"\:\"(.*?)\"\,.*?countryRank\"\:(\d*?)\,'

$result =  [System.Collections.ArrayList] @()

if ($m) {
    #Write-Host $args[0] 'Global rank:' $Matches[1]
    #Write-Host $args[0] (Get-Culture).TextInfo.ToTitleCase($Matches[2]) 'rank:' $Matches[3]
    $h = @{}
    $h['Website'] = $args[0]
    $h['Global Rank'] = $Matches[1]
    $h['Country'] = (Get-Culture).TextInfo.ToTitleCase($Matches[2])
    $h['Country Rank'] = $Matches[3]
    $result.Add( [pscustomobject] $h ) > $null

} else {
    Write-Host $args[0] 'not ranked'
}


$result
