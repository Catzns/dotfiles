#!/usr/bin/env bash
set -euo pipefail

function usage() {
	printf "%s\n\n" "USAGE: $(basename "$0") PATH [ALIAS]"
	printf "%s\n" "PATH  - Path of the .dotfile you want linked"
	printf "%s\n" "ALIAS - What you want the .dotfile's name to be"
	exit 1
}

if [[ "$#" -lt 1 ]] || [[ "$#" -gt 2 ]]; then
	usage
fi

# Intermediary variables
dotfile_dir=$(dirname $(realpath "$0"))
file_path=$(realpath -s "$1")
file_dir=$(dirname "$file_path")
link_name="${2:-$(basename "$file_path")}" # If no 2nd argument is given, use existing filename
link_path="$dotfile_dir/$link_name"

# Guards against invalid links
if ! [[ -f "$file_path" ]] then
	printf "%s\n" "INVALID PATH: Specified file '$1' does not exist." >&2
	usage
elif [[ -h "$file_path" ]] then
	printf "%s\n" "INVALID PATH: Specified file '$1' is already a symlink."
	usage
elif [[ "$file_dir" == "$dotfile_dir" ]] then
	printf "%s\n" "REDUNDANT PATH: Attempted to create link inside .dotfiles/ directory."
	usage
elif grep -w "^$link_name " "$dotfile_dir/LINKS"; then
	read -p "You are about to overwrite an existing link. Proceed? (Y/N) " response
	if [[ $response != [Yy] ]] then
		exit 2
	fi
fi
# Move to .dotfiles, then symlink in place
cp "$file_path" "$link_path"
ln -sf "$link_path" "$file_path"

# Delete old listings of named alias, and append new one
linkfile=$(grep -wv "^$link_name	" "$dotfile_dir/LINKS" || cat "$dotfile_dir/LINKS")
linkfile+=$'\n'
linkfile+="$link_name	$file_path"
printf "%s\n" "$linkfile" | sed "s|$HOME|~|" > "$dotfile_dir/LINKS"

printf "%s\n" "Successfully linked "$file_path" to "$link_name"!"
