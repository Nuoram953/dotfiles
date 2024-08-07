#!/bin/bash

rustup update
cargo install --locked zellij

git clone https://github.com/alma3lol/zellij-bar.git

cd ~/zellij-bar/

cargo build --release
cp target/wasm32-wasi/release/zellij-bar.wasm ~/dotfiles/.config/zellij/plugins/
