$BaseURL = "https://community.chocolatey.org/api/v2/package/"
$BasePath = "C:\tools\chocolatey.server\App_Data\Packages\"

Function Get-RedirectedUrl 
{
    Param (
        [Parameter(Mandatory=$true)]
        [String]$URL
    )

    $response = Invoke-WebRequest $URL -MaximumRedirection 0 -ErrorAction SilentlyContinue;
    return $response.Links.href;
}

$files = Get-ChildItem -Filter "*.nupkg" $BasePath

foreach ($file in $files)
{
    rm $file.FullName;
    Write-Host "Remove $($file.Name)";
}

$folders = Get-ChildItem -Directory $BasePath;

foreach ($folder in $folders)
{
    $PackageName = $folder.Name.ToLower();
    Write-Host "Check $PackageName";
    $URL = "$($BaseURL)$($PackageName)";
    $FileName = [System.IO.Path]::GetFileName((Get-RedirectedUrl $URL)).ToLower();
    $Version = ($FileName.Substring($PackageName.Length + 1)).TrimEnd(".nupkg")
    Write-Host "Version: $Version";

    $verfolders = Get-ChildItem -Directory "$($BasePath)$($PackageName)";
    $update = $true;

    foreach ($verfolder in $verfolders)
    {
        if ($verfolder.Name -eq $Version)
        {
            Write-Host "No Updates for $PackageName";
            $update = $false;
            break;
        }
    }

    if ($update)
    {
        Write-Host "Download $PackageName";
        $Path = "$($BasePath)$($FileName)"
        wget $URL -OutFile $Path;
    }
}
