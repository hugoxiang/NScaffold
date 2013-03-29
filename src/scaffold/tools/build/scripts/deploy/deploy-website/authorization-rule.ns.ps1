param($config, $packageInfo, $installArgs, [ScriptBlock] $installAction)

$here = $MyInvocation.MyCommand.Path | Split-Path -Parent
. $here\authorization-rule.fn.ns.ps1

$webSiteName = $config.siteName
$appPoolUser = $config.AppPoolUser

& $installAction

if ((gwmi win32_computersystem).partofdomain -eq $true) {
    write-host -fore green "Set Authorization Rules based on Windows Domain Authentication"
	Config-Authorization $webSiteName $appPoolUser
} else {
    write-host -fore yellow "Not in Domain ENV! Authorization settings is skipped."
}
