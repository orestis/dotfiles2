# Anything beyond this point is not executed when fish isn't run interactively, 
# such as via `fish -c '...'`
if not status --is-interactive
    exit
end

test -e /opt/homebrew/bin/brew; and eval (/opt/homebrew/bin/brew shellenv)

source (brew --prefix asdf)/asdf.fish

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

