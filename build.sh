#!/bin/bash

if ! [ -d webtorrent-desktop ]; then
  git clone https://github.com/webtorrent/webtorrent-desktop.git --depth 1 -b v0.24.0 webtorrent-desktop
fi

platform() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    printf "linux"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    printf "darwin"
  elif [[ "$OSTYPE" == "cygwin" ]]; then
    printf "win32"
  elif [[ "$OSTYPE" == "msys" ]]; then
    printf "win32"
  elif [[ "$OSTYPE" == "win32" ]]; then
    printf "win32"
  elif [[ "$OSTYPE" == "freebsd"* ]]; then
    printf "linux"
  else
    printf "win32"
  fi
}

rm -rf dist

pushd webtorrent-desktop
  git checkout .

  if ! [ -d node_modules ]; then
    npm install
  fi
  
  sed -i -e "s/VERSION_PREFIX +/'-qB3130-' +/g" src/renderer/webtorrent.js
  sed -i -e "s/map((x) => true)/reduce(function () { return [true].concat(arguments[3].slice(1).map(x=>false)); })/g" src/renderer/webtorrent.js
  sed -i -e "s/map((x) => true)/reduce(function () { return [true].concat(arguments[3].slice(1).map(x=>false)); })/g" src/renderer/controllers/torrent-controller.js
  sed -i -e "s/map((x) => true)/reduce(function () { return [true].concat(arguments[3].slice(1).map(x=>false)); })/g" src/renderer/lib/state.js

  git clean -f

  npm run package -- "$(platform)"
  mv dist ../
popd

