function fish_greeting
	sleep .01
	fastfetch
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    fish_vi_key_bindings insert
    fish_add_path ~/.config/emacs/bin
end

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end
