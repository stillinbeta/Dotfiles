. /etc/environment # get a fresh PATH
# Rust
PATH="$PATH:$HOME/Scripts:$HOME/.cargo/bin"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# go
export GOBIN=~/.local/bin

# Pyenv
PYENV_ROOT="$HOME/.pyenv"
PATH=$PYENV_ROOT/bin:~/.local/bin:~/bin:$PATH

# Shell stuff
export LC_ALL=en_GB.UTF-8
export EDITOR="$HOME/.local/bin/ec"
