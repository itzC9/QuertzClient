#!/bin/bash

main() {
    clear
    echo -e "QuertzClientMac Install Script (non-admin) - Begin"
    curl -s "https://git.raptor.fun/main/jq-macos-amd64" -o "./jq"
    chmod +x ./jq

    [ -d "Applications" ] || mkdir "Applications"
    echo -e "Downloading Latest Roblox..."
    
    [ -f ./RobloxPlayer.zip ] && rm ./RobloxPlayer.zip
    local versionInfo=$(curl -s "https://raw.githubusercontent.com/itzC9/QuertzClient/refs/heads/main/version.json")
    
    local mChannel=$(echo $versionInfo | ./jq -r ".channel")
    local version=$(echo $versionInfo | ./jq -r ".\"roblox-client\"")
    curl "http://setup.rbxcdn.com/mac/$version-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    
    echo -n "Installing Latest Roblox... "
    [ -d "Applications/Roblox.app" ] && rm -rf "Applications/Roblox.app"
    unzip -o -q "./RobloxPlayer.zip"
    mv ./RobloxPlayer.app ./Applications/Roblox.app
    rm ./RobloxPlayer.zip
    echo -e "Done."

    echo -e "Downloading QuertzClientMac..."
    curl "https://raw.githubusercontent.com/itzC9/QuertzClient/refs/heads/main/main/QuertzClient.zip" -o "./QuertzClient.zip"

    echo -n "Installing QuertzClientMac... "
    unzip -o -q "./QuertzClient.zip"
    echo -e "Done."

    echo -n "Updating Dylib..."
    curl -Os "https://raw.githubusercontent.com/itzC9/QuertzClient/refs/heads/main/$mChannel/libQuertzClient.dylib"
    
    echo -e " Done."
    echo -e "Patching Roblox..."
    local pat=$(pwd)

    mv ./libQuertzClient.dylib "Applications/Roblox.app/Contents/MacOS/libQuertzClient.dylib"
    ./insert_dylib "$pat/Applications/Roblox.app/Contents/MacOS/libQuertzClient.dylib" "$pat/Applications/Roblox.app/Contents/MacOS/RobloxPlayer" --strip-codesig --all-yes
    mv "Applications/Roblox.app/Contents/MacOS/RobloxPlayer_patched" "Applications/Roblox.app/Contents/MacOS/RobloxPlayer"
    rm -r "Applications/Roblox.app/Contents/MacOS/RobloxPlayerInstaller.app"
    rm ./insert_dylib

    echo -n "Installing QuertzClient App... "
    [ -d "Applications/MacSploit.app" ] && rm -rf "Applications/MacSploit.app"
    mv "./QuertzClientMac.app" "./Applications/QuertzClientMac.app"
    rm ./QuertzClient.zip
    rm ./jq

    echo -e "Done."
    echo -e "Install Complete! QuertzClient Read To used!"
    exit
}

main
