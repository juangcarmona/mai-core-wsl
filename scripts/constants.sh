#!/bin/bash

export REPO_DIR="$(pwd)"

export VENV_DIR="$REPO_DIR/.venv"
export MAI_TEMP="$REPO_DIR/.temp"
export ZSHRC="$HOME/.zshrc"

mkdir -p "$MAI_TEMP"
export EXTERNAL_REPOS_DIR="$(dirname "$REPO_DIR")"  # Go one level up
export LLAMA_DIR="$EXTERNAL_REPOS_DIR/llama.cpp"
export LLAMA_BIN_DIR="$LLAMA_DIR/build"

