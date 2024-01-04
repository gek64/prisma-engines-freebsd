#!/usr/bin/env sh

platform="$(uname -o)"

# 检查工具链
CheckTool() {
  ## 返回值判断 1为不存在 0为存在
  if [ ! "$(command -v "$1")" ]; then
    return 1
  else
    return 0
  fi
}

# 检测平台, 并安装对应的编译工具链
if [ "$platform" = "Linux" ]; then
  if CheckTool "apk"; then
    apk add build-base linux-headers zip git python3
  elif CheckTool "apt"; then
    apt install -y build-essential zip git
  fi
elif [ "$platform" = "FreeBSD" ]; then
  pkg install -y gmake zip git
  export CC=clang
  export CXX=clang++
fi

# nodejs
git clone --depth 1 --recurse-submodules --branch "v20.x" "https://github.com/nodejs/node.git" "$HOME/node"
cd node || exit
## 显示所有静态配置选项 ./configure --help | grep static
./configure --prefix=/tmp/node --enable-static && make install -j "$(sysctl -n hw.ncpu)"
## 压缩打包
cd /tmp/ && zip -9 -r -y -UN=UTF8 "$HOME/node-$(/tmp/node/bin/node -v)_$(uname -o)_$(uname -r)_$(uname -p).zip" node
