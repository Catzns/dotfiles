#!/usr/bin/env bash
set -euo pipefail

function usage() {
	printf "%s\n\n" "USAGE: $(basename $0) FILE"
	printf "%s\n" "FILE - Dotfile you'd like to return to its native directory."
	exit 1
}

if [[ $# != 1 ]] then
	usage
fi

# Intermediary variables
dotfiles_dir=$(dirname $(realpath "$0"))
link_name="$1"
link_dir=$(grep -wm 1 "^$link_name	" "$dotfiles_dir/LINKS" || printf "%s" "")
link_dir=${link_dir#*	}
link_abs=$(printf "%s" "$link_dir" | sed "s|~|$HOME|")

# Guard against invalid removals
if ! [[ -f "$dotfiles_dir/$link_name" ]] then
	printf "%s\n" "INVALID FILE: Specified file '$link_name' does not exist in .dotfiles/ directory." >&2
	usage
elif [[ -z $link_dir ]] then
	printf "%s\n" "INVALID FILE: Specified file '$link_name' does not exist in LINKS" >&2
	usage
fi

# Unlink in origin directory, then move into place
unlink "$link_abs"
mv "$dotfiles_dir/$link_name" "$link_abs"

# Delete old listings of specified directory
linkfile=$(grep -v "$link_dir" "$dotfiles_dir/LINKS" || printf "%s" "")
printf "%s\n" "$linkfile" > "$dotfiles_dir/LINKS"

printf "%s\n" "Sucessfully returned $link_name to original location!"
