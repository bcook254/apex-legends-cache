#!/bin/bash

VERSION=0.0.2

function echo_err {
    >&2 echo "$1"
}

function help {
    echo -e "\e[1mUsage:\e[0m"
    echo -e "  \e[1mmerge_local_cache_file.sh\e[0m [options]"
    echo ""
    echo -e "\e[1mMETA OPTIONS\e[0m"
    echo -e "  \e[1m-h\e[0m, \e[1m--help\e[0m"
    echo "      show list of command-line options"
    echo ""
    echo -e "  \e[1m-v\e[0m, \e[1m--version\e[0m"
    echo "      show version of this script"
    echo ""
    echo -e "\e[1mOPTIONS\e[0m"
    echo -e "  \e[1m--shader-cache-file\e[0m=\e[4mfile\e[0m (Required)"
    echo "      the location of the local r5apex.dxvk-cache file"
    echo "      default locations include:"
    echo "        \$HOME/.local/share/Steam/steamapps/shadercache/1172470/DXVK_state_cache/r5apex.dxvk-cache"
    echo "        \$HOME/Steam/steamapps/common/Apex Legends/r5apex.dxvk-cache"
    echo ""
    echo -e "  \e[1m--repository-folder\e[0m=\e[4mfolder\e[0m (Optional; Default=./)"
    echo "      the location of the cloned repo containing the r5apex.dxvk-cache file"
    echo ""
    echo -e "  \e[1m--output-file\e[0m=\e[4mfile\e[0m (Optional; Default=./r5apex.dxvk-cache)"
    echo "      the output file created by dxvk-cache-tool"
    echo ""
    echo " For more information or help please visit https://github.com/bcook254/apex-legends-cache"
}

function check_prereqs {
    # Check if git is installed
    git --version > /dev/null
    if [ $? -ne 0 ]; then
        echo_err "git is not available, ensure it is installed and in your PATH."
        exit 1
    fi

    # Check if git-lfs is installed
    git-lfs --version > /dev/null
    if [ $? -ne 0 ]; then
        echo_err "git-lfs is not available, ensure it is installed and in your PATH"
        exit 1
    fi

    # Check if dxvk-cache-tool is installed
    dxvk-cache-tool --version > /dev/null
    if [ $? -ne 0 ]; then
        echo_err "dxvk-cache-tool is not available, ensure it is installed and in your PATH"
        exit 1
    fi
}

function check_files {
    if [ ! -f $shader_cache_file ]; then
        echo_err "Local shader cache file does not exist."
        exit 2
    fi

    if [ ! -f $repository_folder/r5apex.dxvk-cache ]; then
        echo_err "Repository shader cache file does not exist."
        exit 2
    fi
}

function merge_cache_files {
    merge_result=$(dxvk-cache-tool "$repository_folder/r5apex.dxvk-cache" "$shader_cache_file" --output "$output_file")
    new_entries=$(echo "$merge_result" | grep -Po '(?<=\(2\/2\)\.{3}\s)\d+?(?=\snew entries)')
    total_entries=$(echo "$merge_result" | grep -Po '(?<=Writing\s)\d+?(?=\sentries)')
}

while [ $# -gt 0 ]; do
    case "$1" in
        --shader-cache-file*)
            if [[ "$1" != *"="* ]]; then shift; fi # Value is next arg when '=' is missing
            shader_cache_file_arg="${1#*=}"
            ;;
        --repository-folder*)
            if [[ "$1" != *"="* ]]; then shift; fi # Value is next arg when '=' is missing
            repository_folder_arg=$(echo "${1#*=}" | sed 's/\/*$//') # Remove all trailing '/'
            ;;
        --output-file*)
            if [[ "$1" != *"="* ]]; then shift; fi # Value is next arg when '=' is missing
            output_file_arg="${1#*=}"
            ;;
        --version|-v)
            echo "Version $VERSION"
            exit 0
            ;;
        --help|-h)
            help
            exit 0
            ;;
    esac
    shift
done

# In the future this should allow checking some
# default locations for the local cache file
# For now, show help and exit with error if arg is missing
shader_cache_file=${shader_cache_file_arg}
if [ -z "$shader_cache_file" ]; then
    help
    exit 3
fi

# Default to the current directory
repository_folder=${repository_folder_arg:-"."}

# Default to overwriting the repository cache file
output_file=${output_file_arg:-"$repository_folder/r5apex.dxvk-cache"}

check_prereqs
check_files

merge_cache_files

echo -e "\e[1m$new_entries\e[0m new entries were found."
echo -e "\e[1m$total_entries\e[0m total entries were written."