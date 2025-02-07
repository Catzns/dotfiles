#!/usr/bin/env bash
set -euo pipefail

dotfiles_dir=$(dirname $(realpath $0))

while read -r entry; do
# Exclude empty lines
	if [[ -z $entry ]] then
		continue
	fi

# Intermediary variables
	link=${entry%	*}
	path=${entry#*	}
	path=$(printf "%s" "$path" | sed "s|~|$HOME|")
	dir=$(dirname "$path")

	if ! [[ -f "$dotfiles_dir/$link" ]] then
		printf "%s\n" "File '$link' not present, skipping..."
		continue
	elif [[ -h "$path" ]] then
		printf "%s\n" "'$path' is already a symlink, skipping..."
		continue
	fi

# Make target directory, then create link & overwrite existing file
	mkdir -p "$dir"
	ln -sf "$dotfiles_dir/$link" "$path"
	printf "%s\n" "'$link' successfully linked..."
done < "$dotfiles_dir/LINKS"

printf "%s\n" "Installation complete!"
