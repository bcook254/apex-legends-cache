#!/bin/bash

# Prerequisites for this script:
# git, git-lfs, dxvk-cache-tool,

# Prerequisites for manual steps: 
# GitHub account, ssh-key/access-token

manualSteps="Manual steps for merging shaders and updating repo: 
1. fork this repo: https://github.com/bcook254/apex-legends-cache
2. git clone the forked repo
3. cd into cloned repo
4. git lfs track r5apex.dxvk-cache -> should return \"r5apex.dxvk-cache\" already supported
5. Copy the shaders from steam shadercache to the local repo: cp ~/.local/share/Steam/steamapps/shadercache/1172470/DXVK_state_cache/r5apex.dxvk-cache ./r5apex-local.dxvk-cache
6. Use the merge tool to merge your own shadercache with the shadercache files in the repo: dxvk-cache-tool ./r5apex.dxvk-cache ./r5apex-local.dxvk-cache
7. Extract amount of new entries to the shader from return value of the merge tool
8. Rename the merge tool output file to the same name of the repo cache files to overwrite the repo cache files: mv ./output.dxvk-cache ./r5apex.dxvk-cache
9. git add r5apex.dxvk-cache
10. git commit -m \"\$(date +%s)\" -> might need to enter user.email and user.name
11. git push origin main -> might need to enter personal access token if ssh is not setup
12. Go to GitHub, login and go to your forked repository. Then create a new pull request and add a resonable comment. Don't forget to add how many new entries you add with this PR"

# Print help

if [[ "$1" == "-h" || $# -le 2 ]]; then
    echo "Usage: ";
    echo "      $0 STEAM_APEX_GAME_DIR LOCAL_REPO_DIR [MERGE_TOOL_DIR]";
    echo;
    echo "Best way to find STEAM_APEX_GAME_DIR is to open steam, go to library, right click on Apex Legends and select Manage->Browse local files. Your file browser should open up and you can copy the path to the Apex Legends game directory and supply it to this script."
    echo;
    echo "$manualSteps";
    exit 0;
fi

gamefilepth=$1;
clonedrepo=$2;
mergetoolpth=$3;
downloadaddr="https://lutris.nyc3.cdn.digitaloceanspaces.com/games/overwatch/merge-tool.tar.xz";
downloaddir="$HOME";
downloadfilename="merge-tool.tar.xz";
mergeTooldir="$downloaddir/merge-tool";
mergeToolLog="$HOME/mergeToolLog.log";

if [[ ! -d $gamefilepth ]];
then
    echo "Game file path does not exist. Exit now!";
    exit 1;
fi

if [[ ! -d $clonedrepo ]];
then
    echo "Cloned repo path does not exist. Exit now!";
    exit 1;
fi


# Check if path to merge tool directory was provided on CLI.
# If not, then ask if it should be downloaded. If download is denied, then exit.

if [[ ! -d $mergetoolpth ]]; then
    echo "Merge tool path does not exist or was not provided.";
    read -p "Download merge tool now? [yes/no]: " isDownload;
    if [[ $isDownload == "yes"  ]]; then
        echo "Downloading now!";
        retCode=$(curl -sSl -w "%{http_code}" -o "$downloaddir/$downloadfilename" $downloadaddr);
        if [[  "$retCode" =~ ^2 ]]; then
            echo "Download successful!";
            if [[ ! -d $mergeTooldir ]]; then
                mkdir $mergeTooldir;
            fi
            tar -xf "$downloaddir/$downloadfilename" -C $mergeTooldir;
        elif [[ "$retCode" = 404 ]]; then
            echo "Download failed!";
            echo "Server returned 404. Exit now!";
            exit 1;
        else
            echo "ERROR: server returned HTTP code $retCode";
            exit 1;
        fi
    else
        echo "Provide merge tool path. Exit now!"
        exit 1;
    fi
fi

shaderfilename="r5apex.dxvk-cache";
searchstring="Steam/steamapps";
relshaderpth="/shadercache/1172470/DXVK_state_cache";
steamappspth="$(echo $gamefilepth | grep -o -E '.*(Steam\/steamapps)')";

if [[ -z "$steamappspth" ]];    # Parse steam cache file directory
then
   echo "Could not find correct shader path. Exit now!";
   exit 1;
fi
shaderpth="$steamappspth$relshaderpth";
if [[ -d $shaderpth ]];
then
    echo "Found shader path:";
    echo $shaderpth;
fi

if [[ -e "$shaderpth/$shaderfilename" ]]; then
    cp -i "$shaderpth/$shaderfilename" "$clonedrepo/local-$shaderfilename";
else
    echo "Shader file does not exist. Exit now!";
    exit 1;
fi

# TODO: Check if git and git lfs is installed
touch "$mergeToolLog";
cd "$clonedrepo";
git status > "$mergeToolLog";
git lfs install >> "$mergeToolLog";
git lfs track "$shaderfilename" >> "$mergeToolLog";
$mergeTooldir/dxvk-cache-tool "$shaderfilename" "local-$shaderfilename" >> "$mergeToolLog";
mv "output.dxvk-cache" "$shaderfilename";

newEntries=$(grep -o -E '\)\.\.\.\ ([0-9]*)' $mergeToolLog | grep -o -E '[0-9]*');
if [[ ${newEntries[@]} -neq 2 ]]; then
    echo "Could not parse amount of new entries. Exit now!";
    exit 1;
fi
echo "Amount of entries before merge: ${newEntries[0]}";
echo "Amount of new entires: ${newEntries[1]}";

git add "$shaderfilename";
echo "Now manually do: git push origin main";
