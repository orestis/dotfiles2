# Anything beyond this point is not executed when fish isn't run interactively, 
# such as via `fish -c '...'`
if not status --is-interactive
    exit
end

test -e /opt/homebrew/bin/brew; and eval (/opt/homebrew/bin/brew shellenv)

source (brew --prefix asdf)/asdf.fish

test -e ~/dev/nosco/mongo/4.2.15; and set PATH $PATH ~/dev/nosco/mongo/4.2.15/bin;
test -e /Applications/Postgres.app/; and set PATH $PATH /Applications/Postgres.app/Contents/Versions/latest/bin;

test -e ~/.ebcli-virtual-env/executables; and set PATH $PATH ~/.ebcli-virtual-env/executables;
test -e ~/.pyenv/versions/3.9.1/bin; and set PATH $PATH ~/.pyenv/versions/3.9.1/bin;

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish;

