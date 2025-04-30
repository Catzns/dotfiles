# Plugin Manager
evaluate-commands %sh{
  # We're assuming the default bundle_path here...
  plugins="$kak_config/bundle"
  mkdir -p "$plugins"
  [ ! -e "$plugins/kak-bundle" ] && \
    git clone -q https://codeberg.org/jdugan6240/kak-bundle "$plugins/kak-bundle"
  printf "%s\n" "source '$plugins/kak-bundle/rc/kak-bundle.kak'"
}
bundle-noload kak-bundle https://codeberg.org/jdugan6240/kak-bundle

# Personal Settings
colorscheme tokyonight

set-option global tabstop 4
set-option global indentwidth 0
set-option global scrolloff 1,3
add-highlighter global/ number-lines -min-digits 3 -hlcursor

map global user l ':enter-user-mode lsp<ret>' -docstring 'LSP mode'
map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'

# Plugins
bundle auto-pairs.kak https://github.com/alexherbo2/auto-pairs.kak %{
	enable-auto-pairs
}
bundle fzf.kak https://github.com/andreyorst/fzf.kak %{

}
bundle kakoune-phantom-selection https://github.com/occivink/kakoune-phantom-selection
bundle kakoune-surround https://github.com/h-youhei/kakoune-surround %{
	declare-user-mode surround
	map global surround s ':surround<ret>' -docstring 'surround'
	map global surround c ':change-surround<ret>' -docstring 'change'
	map global surround d ':delete-surround<ret>' -docstring 'delete'
	map global surround t ':select-surrounding-tag<ret>' -docstring 'select tag'
	map global user s ':enter-user-mode surround<ret>' -docstring 'Surround'
}

# LSP Plugin
eval %sh{kak-lsp}
lsp-enable

# Astro LSP & Syntax Highlighting
hook global BufCreate .*\.astro %{
	set-option buffer filetype astro
}

hook global WinSetOption filetype=astro %{
    require-module html

    hook window ModeChange pop:insert:.* -group "astro-trim-indent"  html-trim-indent
    hook window InsertChar '>' -group "astro-indent" html-indent-on-greater-than
    hook window InsertChar \n -group "astro-indent" html-indent-on-new-line

    hook -once -always window WinSetOption "filetype=.*" "
        remove-hooks window ""astro-.+""
    "
}

hook -group lsp-filetype-astro global BufSetOption filetype=astro %{
	set-option buffer lsp_servers %{
		[astro-ls]
		args = ["--stdio"]
		root_globs = ["astro.config.mjs", "tsconfig.json", ".git", ".hg"]
		settings_section = "_"
		[astro-ls.settings._]
		typescript.tsdk = "node_modules/typescript/lib"
	}
}

# LSP Bindings
map global object a '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object <a-a> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object f '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
map global object t '<a-semicolon>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'
map global object d '<a-semicolon>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'
map global object D '<a-semicolon>lsp-diagnostic-object<ret>' -docstring 'LSP errors'

