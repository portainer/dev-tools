#!/bin/bash

build() {
  local img=${1:-ubuntu-debug}
  docker build --no-cache -t "$img" -f ubuntu-debug.Dockerfile .
}

build $1
