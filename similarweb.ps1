
<# 
Requirements (always use the latest version):
    Firefox - https://download.mozilla.org/?product=firefox-esr-latest-ssl&os=win64&lang=en-US
    geckodriver.exe - 
        https://github.com/mozilla/geckodriver/releases/latest
            https://github.com/mozilla/geckodriver/releases/tag/v0.31.0
                https://github.com/mozilla/geckodriver/releases/download/v0.31.0/geckodriver-v0.31.0-win64.zip
    WebDriver.dll - https://www.nuget.org/api/v2/package/Selenium.WebDriver/


#> 

#Import-Module 'D:\BIN\WebDriver.dll'
Import-Module '.\WebDriver.dll'

Clear-Host

$FirefoxOptions = New-Object OpenQA.Selenium.Firefox.FirefoxOptions
$FirefoxOptions.AcceptInsecureCertificates = $true
#$FirefoxOptions.AddArgument('--headless')

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


$FirefoxDriver.Url = 'https://www.similarweb.com/website/matahari.com/'



Write-Host $FirefoxDriver.PageSource

Start-Sleep -Seconds 10

$FirefoxDriver.Close()
$FirefoxDriver.Quit()



