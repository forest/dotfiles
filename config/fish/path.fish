export GOPATH=$HOME/go

set PATH $PATH \
    ./bin \
    ~/.bin \
    ~/bin \
    /usr/local/bin \
    /usr/local/homebrew/bin \
    /opt/homebrew/bin \
    ./node_modules/.bin \
    ~/.cargo/bin \
    $GOPATH \
    $GOPATH/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/code/google-cloud-sdk/path.fish.inc" ]
    . "$HOME/code/google-cloud-sdk/path.fish.inc"
end
