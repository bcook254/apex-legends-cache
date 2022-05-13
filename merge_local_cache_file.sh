#!/bin/bash

VERSION=0.0.1

function echo_err {
    >&2 echo "$1"
}

function help {
    echo "Usage:";
    # TODO: Add usage instructions
    exit 0;
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
            repository_folder_arg=$(echo "${1#*=}" | 's/\/*$//') # Remove all trailing '/'
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