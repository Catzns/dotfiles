colorscheme tokyonight

set-option global tabstop 4
set-option global indentwidth 0
set-option global scrolloff 1,3
add-highlighter global/ number-lines -min-digits 3 -hlcursor

map global user l ':enter-user-mode lsp<ret>' -docstring 'LSP mode'

map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'

evaluate-commands %sh{
    plugins="$kak_config/plugins"
    mkdir -p "$plugins"
    [ ! -e "$plugins/plug.kak" ] && \
        git clone -q https://github.com/andreyorst/plug.kak.git "$plugins/plug.kak"
    printf "%s\n" "source '$plugins/plug.kak/rc/plug.kak'"
}
plug "andreyorst/plug.kak" noload

eval %sh{kak-lsp}
lsp-enable

hook -group lsp-filetype-javascript global BufSetOption filetype=(?:javascript|typescript) %{
	set-option buffer lsp_servers %{
        [deno]
        root_globs = ["package.json", "tsconfig.json", ".git", ".hg"]
        args = ["lsp"]
        settings_section = "deno"
        [deno.settings.deno]
        enable = true
        lint = true
    }
}

map global object a '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object <a-a> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object f '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
map global object t '<a-semicolon>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'
map global object d '<a-semicolon>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'
map global object D '<a-semicolon>lsp-diagnostic-object<ret>' -docstring 'LSP errors'

