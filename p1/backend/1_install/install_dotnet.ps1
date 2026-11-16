# Don't do this. Use winget install dotnet-sdk-10 instead.
$script_url = 'https://dot.net/v1/dotnet-install.ps1'
WriteInfo "Downloading dotnet install script..."
Invoke-WebRequest -Uri "$script_url" -OutFile "$env:TEMP/dotnet-install.ps1"

WriteInfo "Installing dotnet version $DOTNET_MAJOR_VERSION.0..."
"$env:TEMP/dotnet-install.ps1" -Channel "$DOTNET_MAJOR_VERSION.0"

dotnet --version

