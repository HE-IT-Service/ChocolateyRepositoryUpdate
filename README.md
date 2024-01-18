# Chocolatey Repository Update
Using powershell to update nuget package on custom repositories

# Function
Get all folders in the repository root folder. The script checks the current version from chocolatey community repository and compares the version with the subfolders. If an update is available, the script will download the package.

Run this script by the task scheduler on a weekly base to be always up to date.
