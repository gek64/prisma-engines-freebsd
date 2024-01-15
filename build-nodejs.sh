#!/usr/bin/env sh

pkg install -y gmake zip git
export CC=clang
export CXX=clang++

# nodejs
git clone --depth 1 --recurse-submodules --branch "v20.x" "https://github.com/nodejs/node.git" "$HOME/node"
cd "$HOME/node" || exit
## 显示所有静态配置选项 ./configure --help | grep static
./configure --prefix=/tmp/node --enable-static
make -j "$(sysctl -n hw.ncpu)" && make install
## 压缩打包
tar -czvf "$HOME/node-$(/tmp/node/bin/node -v)_$(uname -o)_$(uname -r)_$(uname -p).tar.gz" -C "/tmp" node
