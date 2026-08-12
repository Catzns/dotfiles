#!/usr/bin/env bash
set -e

BOOTSTRAP=false
EVERYTHING=false
DRYRUN=false
declare -A PROFILES
declare -A LINKS
declare -A PACKAGES
declare -A SCRIPTS

function usage {
   local MSG="   USAGE: ./install PROFILE [...] [--bootstrap]

   PROFILES: basic | base | b
             graphical | gui | g
             applications | apps | a
             [CUSTOM...]

   ARGUMENTS:
  -b, --bootstrap
                  Run potentially intrusive setup scripts that cannot be
                  easily reversed i.e. changing the login shell.
 -e, --everything
                  Include every profile available for installation with
                  no further specification.
    -d, --dry-run
                  Announce actions taken without modifying the system.
       -h, --help
                  Print this message.\n"
   if test $1 -eq 0; then
      printf "$MSG"
   else
      printf "$MSG" >&2
   fi
   exit $1
}

function parse-args {
   while [[ $1 != "" ]]; do
      local ARG=$1
      case $ARG in
         basic | base | b) PROFILES[.]=true ;;
         graphical | gui | g) PROFILES[./gui]=true ;;
         applications | apps | a) PROFILES[./apps]=true ;;
         --) local OPTEND=true ;;
         --*)
            if [ -v OPTEND ]; then
               PROFILES[$ARG]=true
            else
               case $ARG in
                  --bootstrap) BOOTSTRAP=true ;;
                  --everything) EVERYTHING=true ;;
                  --dry-run) DRYRUN=true ;;
                  --help) usage 0 ;;
                  *)
                     printf "Invalid option: $ARG\n"
                     usage 1 ;;
               esac
            fi ;;
         -*)
            if [ -v OPTEND ]; then
               PROFILES[$ARG]=true
            else
               for ((i = 1; i < ${#ARG}; i++)); do
                  local OPT=${ARG:$i:1}
                  case $OPT in
                     b) BOOTSTRAP=true ;;
                     e) EVERYTHING=true ;;
                     d) DRYRUN=true ;;
                     h) usage 0 ;;
                     *)
                        printf "Invalid option: -$OPT\n"
                        usage 1 ;;
                  esac
               done
            fi ;;
         *)
            PROFILES[$ARG]=true ;;
      esac
      shift
   done
}

function fill-from-dirs {
      while read -r file; do
         local path=$(realpath "$file")
         file=$(basename $file)
         case $file in
            links.tsv) LINKS[$path]="1" ;;
            packages.tsv) PACKAGES[$path]="1" ;;
            bootstrap*) SCRIPTS[$path]="1" ;;
         esac
      done <<< $(find "$@" -maxdepth 1 -type f)
}

function has-pkg {
   # Convenience function to check for a package manager with more minimal syntax.
   if command -v "$1" &>/dev/null; then
      return 0
   else
      return 1
   fi
}

function install-per-pm {
   if has-pkg "pacman"; then
      if [ -n "${!PACKAGES[*]}" ]; then
         local pkgs=$(comm -12 <(pacman -Slq | sort) <(sort <<< $(tr "\t" "\n" <<< $(cat "${!PACKAGES[@]}"))))
         local amount=$(pacman -Sp --needed $pkgs)
         if [ -z "$amount" ]; then return; fi
         amount=$(wc -l <<< $amount)
         if $DRYRUN; then
            printf "Pretending to install $amount packages:\n"
            pacman -S --needed --print-format "   %r/%n-%v" $pkgs
         else
            printf "Installing $amount packages:\n"
            sudo pacman -S --needed $pkgs
         fi
      fi
   elif false; then
      :
      # Add cases for previously unsupported package managers here.
   fi
   printf "\n"
}

function run-scripts {
   local scripts="${!SCRIPTS[@]}"
   if [ -n "${!SCRIPTS[*]}" ]; then
      printf "You are about to run the following scripts:\n"
      printf "   - %s\n" $scripts
      if ! $DRYRUN; then
         printf "\nThis could cause unwanted changes. "
         while printf "Proceed? [y/n]: " && read -r -n 1 answer; do
            printf "\n"
            if [ "$answer" = 'n' ]; then
               return
            elif
               [ "$answer" = 'y' ]; then
               break
            else
               printf "Answer must be 'y' or 'n'. "
            fi
         done
      fi
      for script in $scripts; do
            printf "Evaluating %s...\n" "$script"
         if $DRYRUN; then
            return
         else
            eval $script
         fi
      done
   fi
}

function build-symlinks {
   echo "${!LINKS[*]}"
}

cd "$(dirname $(realpath $0))/meta"
parse-args "$@"

if (! $EVERYTHING) && [ ${#PROFILES[@]} -eq 0 ]; then
   usage 1;
fi

if $EVERYTHING; then
   PROFILES="*"
   echo "$PROFILES"
   exit 0
fi

fill-from-dirs "${!PROFILES[@]}"
install-per-pm
run-scripts
build-symlinks

# fill-from-dir "$ROOT"
# fill-depth-1 "$ROOT"
# printf "%s\n" "${!PROFILES[@]}"
# printf "%s\n" "${!LINKS[@]}"
# printf "%s\n" "${!PACKAGES[@]}"
# printf "%s\n" "${!SCRIPTS[@]}"

# #!/usr/bin/env bash
# set -euo pipefail
#
# read -p "This will symlink every .dotfile listed in the LINKS file. Proceed? (Y\N) " resp
# if [[ $resp != [Yy]* ]] then
# 	exit 1
# fi
#
# dotfiles_dir=$(dirname $(realpath $0))
#
# while read -r entry; do
# # Exclude empty lines
# 	if [[ -z $entry ]] then
# 		continue
# 	fi
#
# # Intermediary variables
# 	link=${entry%	*}
# 	path=${entry#*	}
# 	path=$(printf "%s" "$path" | sed "s|~|$HOME|")
# 	dir=$(dirname "$path")
#
# 	if ! [[ -f "$dotfiles_dir/$link" ]] then
# 		printf "%s\n" "File '$link' not present, skipping..."
# 		continue
# 	fi
#
# # Make target directory, then create link & overwrite existing file
# 	if ! [[ -d $path ]]; then
# 		mkdir -p "$dir"
# 	fi
# 	ln -sf "$dotfiles_dir/$link" "$path"
# 	printf "%s\n" "'$link' successfully linked..."
# done < "$dotfiles_dir/LINKS"
#
# printf "%s\n" "Installation complete!"
