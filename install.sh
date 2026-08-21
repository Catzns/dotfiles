#!/usr/bin/env bash
set -e

REPO=$(dirname $(realpath $0))
ROOTNAME="meta"
BACKUPNAME="dotfiles"

BOOTSTRAP=false
EVERYTHING=false
DRYRUN=false
PROFILES=()
FLINKS=()
FPACKAGES=()
FSCRIPTS=()

function usage {
   local MSG="   USAGE: ./install PROFILE [...] [--bootstrap]

   PROFILES: base | basic | b
             gui | graphical | g
             apps | applications | a
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

function expand-home {
   printf "${1/\~/$HOME}"
}

function compress-home {
   printf "${1/$HOME/\~}"
}

function has-pkg {
   # Convenience function to check for a package manager with more minimal syntax.
   if command -v "$1" &>/dev/null; then
      return 0
   else
      return 1
   fi
}

function parse-opt {
   case $1 in
      b | --bootstrap) BOOTSTRAP=true ;;
      e | --everything) EVERYTHING=true ;;
      d | --dry-run) DRYRUN=true ;;
      h | --help) usage 0 ;;
      *)
         printf "Invalid option: $1\n"
         usage 1 ;;
   esac
}

function parse-args {
   while [[ $1 != "" ]]; do
      local ARG=$1
      case $ARG in
         basic | base | b) PROFILES+=(".") ;;
         graphical | gui | g) PROFILES+=("./gui") ;;
         applications | apps | a) PROFILES+=("./apps") ;;
         --) local OPTEND=true ;;
         --*)
            if [ -v OPTEND ]; then
               PROFILES[$ARG]=true
            else
               parse-opt $ARG
            fi ;;
         -*)
            if [ -v OPTEND ]; then
               PROFILES[$ARG]=true
            else
               for ((i = 1; i < ${#ARG}; i++)); do
                  local OPT=${ARG:$i:1}
                  parse-opt $OPT
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
            links.tsv) FLINKS+=("$path") ;;
            packages.tsv) FPACKAGES+=("$path") ;;
            bootstrap*) [ -x "$path" ] && FSCRIPTS+=("$path") ;;
         esac
      done <<< $(find "$@" -maxdepth 1 -type f)
}

function archive-old-files {
   if [ -n $XDG_STATE_HOME ]; then
      local DATAHOME="$XDG_STATE_HOME/$BACKUPNAME"
   else
      local DATAHOME="$HOME/.$BACKUPNAME.bak"
   fi
   mkdir -p "$DATAHOME"
   printf "Backing up to $(compress-home $DATAHOME):\n"
   while IFS=$'\t'$'\n' read -ra LINE; do
      for TARGET in "${LINE[@]:1}"; do
         local ARCHIVE=${TARGET#\~/}
         TARGET=$(expand-home $TARGET)
         if [ -f "$TARGET" ] || [ -d "$TARGET" ] && ! [ -L "$TARGET" ]; then
            printf "   - $ARCHIVE\n"
            if ! $DRYRUN; then
               mkdir -p $(dirname "$ARCHIVE")
               cp -r "$TARGET" "$DATAHOME/$ARCHIVE"
            fi
            break
         fi
      done
   done < <(cat ${FLINKS[@]})
   printf "\n"
}

function build-symlinks {
   for LINK in "${FLINKS[@]}"; do
      local name=$(basename $(dirname $LINK))
      name=${name/$ROOTNAME/base}
      printf "Linking profile '$name' to $HOME/...\n"
      while IFS=$'\t'$'\n' read -ra LINE; do
         [ -z $LINE ] && continue
         local TARGET="${LINE[0]}"
         [ -L "$TARGET" ] || ! [ -f "$TARGET" ] && ! [ -d "$TARGET" ] && continue
         for DEST in "${LINE[@]:1}"; do
            printf "   - $TARGET to $DEST\n"
            DEST=$(expand-home "$DEST")
            local DIR=$(dirname "$DEST")
            if ! $DRYRUN; then
               mkdir -p "$DIR"
               ln -srf "$TARGET" "$DEST"
            fi
         done
      done < $LINK
      printf "\n"
   done
}

function install-per-pm {
   local pkgs
   local amount
   if has-pkg "pacman"; then
      if [ -n "${FPACKAGES[*]}" ]; then
         pkgs=$(comm -23 <(pacman -Sql | sort) <(pacman -Qqe | sort))
         pkgs=$(comm -12 <(sort <<< $(tr "\t " "\n\n" <<< $(cat "${FPACKAGES[@]}"))) <(printf "%s\n" "${pkgs[@]}"))
         if [ -z "$pkgs" ]; then return; fi
         amount=$(pacman -Sp --needed $pkgs)
         amount=$(wc -l <<< $amount)
         printf "Installing $amount packages with pacman:\n"
         if $DRYRUN; then
            pacman -S --needed --print-format "   - %r/%n-%v" $pkgs
         else
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
   if [ -z "${FSCRIPTS[*]}" ] || ! $BOOTSTRAP; then
      return
   fi
   if ! $DRYRUN; then
      printf "You are about to run the following scripts:\n"
      for script in "${FSCRIPTS[@]}"; do
         printf "   - %s\n" $(compress-home $script)
      done
      printf "\nThis could cause unwanted changes. "
      while printf "Proceed? [y/n]: " && read -r -n 1 answer; do
         printf "\n"
         if [ "$answer" = 'n' ]; then
            printf "Bootstrap aborted."
            exit 0
         elif
            [ "$answer" = 'y' ]; then
            break
         else
            printf "Answer must be 'y' or 'n'. "
         fi
      done
      printf "\n"
   fi
   for script in "${FSCRIPTS[@]}"; do
      printf "Evaluating %s...\n" "$script"
      if ! $DRYRUN; then
         eval $script
      fi
   done
   printf "\n"
}

cd "$REPO/$ROOTNAME"
parse-args "$@"

if (! $EVERYTHING) && [ ${#PROFILES[@]} -eq 0 ]; then
   usage 1;
fi

if $EVERYTHING; then
   fill-from-dirs "." */
else
   fill-from-dirs "${PROFILES[@]}"
fi

cd "$REPO"

archive-old-files
build-symlinks
install-per-pm
run-scripts
printf "Installation complete!\n"
