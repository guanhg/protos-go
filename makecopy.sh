####################################################################################
# This script is used to copy generated *.pb.go files from the bazel output directory
####################################################################################
#!/bin/bash

set -e

BAZEL_OUTPUT_BASE=$(pwd)/lib
echo "Copying *.pb.go files to '$BAZEL_OUTPUT_BASE'"

# bazel output directory
zz=$(readlink ./bazel-bin)
if [ ! -d "$zz" ]; then
  echo "Error: bazel-bin symlink not found."
  exit 1
fi

# export BAZEL_OUTPUT_BASE so that it can be used in makecopy function
export BAZEL_OUTPUT_BASE
function makecopy {
    local _file="$1"
    local _dir=$(dirname "$_file" | awk -F '/' '{print $NF}')
    local dir="$BAZEL_OUTPUT_BASE/$_dir"
    
    # Create the directory if it does not exist
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    fi
    
    cp -f "$_file" "$dir"
}

export -f makecopy
find "$zz"/ -path "$zz/external" -prune -o -name '*.pb.go' -exec \
  bash -c 'makecopy "$0"' {} \;
