$script_url = 'https://dot.net/v1/dotnet-install.ps1'
Invoke-WebRequest -Uri "$script_url" -OutFile "$env:TEMP/dotnet-install.ps1"

"$env:TEMP/dotnet-install.ps1" -Channel "$DOTNET_MAJOR_VERSION.0"
