#!/usr/bin/env sh

pkg install -y gmake git
export CC=clang
export CXX=clang++

# nodejs
nodejs="https://github.com/nodejs/node"
nodejs="https://gh-proxy.com/https://github.com/nodejs/node"
branch="v22.19.0"
git clone --depth 1 --recurse-submodules --branch $branch $nodejs "/root/nodejs-src"
cd "/root/nodejs-src" || exit

## 显示所有静态配置选项 ./configure --help | grep static
./configure --prefix=/usr/local/node --fully-static --enable-static 
gmake -j "$(nproc)" && gmake install
## 压缩打包
tar -zcvf "$HOME/node-$(/usr/local/node/bin/node -v)_$(uname -o)_$(uname -r)_$(uname -p).tar.gz" -C "/usr/local" node
