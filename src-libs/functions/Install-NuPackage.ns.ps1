
Function Install-NuPackage($package, $workingDir, [string]$version = "", [scriptblock] $postInstall) {
    Write-Host "Downloading package [$package] from [$nugetSource] to [$workingDir]...." -f cyan
    
    if ($version) {
        $versionSection = "-version $version"
    }

    if($nugetSource){
        $sourceSection = "-source $nugetSource"
    }

    # need $nuget to be set, if not set, will search $root directory    
    if(!$nuget){
        throw "`$nuget need to be set. "
    }
    
    $argument = "install $package $versionSection $sourceSection -nocache -OutputDirectory $workingDir"
    Write-Host "Executing: $nuget $argument"

    $nuGetInstallOutput = Redo-OnError $nuget $argument
    Write-Host "Output: $nuGetInstallOutput" -f cyan

    if($LastExitCode -ne 0){
        throw "$nuGetInstallOutput"     
    }

    if($version){
        $installedVersion = $version
    } else {
        $installedVersion = $nuGetInstallOutput -match "(?i)\'$package (?<version>.*)\'" | % { $matches.version }  
    }

    if ($nuGetInstallOutput -match "Unable") {
        throw "$nuGetInstallOutput"
    }

    if(-not $installedVersion){
        throw "$nuGetInstallOutput"
    }

    $packageDir = "$workingDir\$package.$installedVersion"
    Write-Host "Package [$package] has been downloaded to [$packageDir]." -f cyan
    if(($nuGetInstallOutput -match "Successfully installed") -or ($nuGetInstallOutput -match "already installed")){
        if($postInstall){
            &$postInstall $packageDir           
        }
    }
    $packageDir
}


