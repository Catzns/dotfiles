#!/usr/bin/env bash
set -uo pipefail

usage() {
	printf "%s\n" "USAGE: ./$(basename $0) [OLD NAME] [NEW NAME]"
	exit 1
}

if [[ $# -ne 2 ]]; then
	usage
fi

dotfile_dir=$(dirname $(realpath "$0"))
name_old="$1"
name_new="$2"

printf "$dotfile_dir\n"
link=$(grep "^$name_old	" "$dotfile_dir/LINKS" || printf "%s\n" "INVALID RENAME: Specified file is not currently linked." >&2; exit 1)
link=$(printf "%s" "${link#*	}")
link=$(printf "%s" "${link/\~/$HOME}")

if find "$dotfile_dir"/"$name_new" &> /dev/null; then
	printf "%s\n" "INVALID RENAME: Target file already exists." >&2
	exit 1
elif ! find "$dotfile_dir"/"$name_old" &> /dev/null; then
	printf "%s\n" "INVALID RENAME: Specified file does not exist." >&2
	exit 1
fi

sed -i "s|^$name_old	|$name_new	|" "$dotfile_dir/LINKS"
mv -n --no-copy "$name_old" "$name_new"
ln -sf "$dotfile_dir/$name_new" "$link"

printf "%s\n" "Renamed '$name_old' to '$name_new'."
