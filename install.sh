#!/usr/bin/env bash
set -euo pipefail

read -p "This will symlink every .dotfile listed in the LINKS file. Proceed? (Y\N) " resp
if [[ $resp != [Yy]* ]] then
	exit 1
fi

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
	fi

# Make target directory, then create link & overwrite existing file
	if ! [[ -d $path ]]; then
		mkdir -p "$dir"
	fi
	ln -sf "$dotfiles_dir/$link" "$path"
	printf "%s\n" "'$link' successfully linked..."
done < "$dotfiles_dir/LINKS"

printf "%s\n" "Installation complete!"
