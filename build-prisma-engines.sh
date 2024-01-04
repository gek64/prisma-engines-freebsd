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
    apk add build-base linux-headers zip git curl python3
  elif CheckTool "apt"; then
    apt install -y build-essential zip git curl
  fi
elif [ "$platform" = "FreeBSD" ]; then
  pkg install -y zip git curl protobuf
  export CC=clang
  export CXX=clang++
fi

# prisma-engines(memory>=8G)
## 安装 rust
curl -sSf https://sh.rustup.rs | sh
export PATH=$HOME/.cargo/bin:$PATH

## 下载源码并编译
git clone --depth 1 --recurse-submodules "https://github.com/prisma/prisma-engines.git" "$HOME/prisma-engines"
cd prisma-engines && cargo build --release

## 压缩打包
cd "$HOME/prisma-engines/target/release" && ls
zip -9 -r -UN=UTF8 "$HOME/prisma-engines-$(uname -o)_$(uname -r)_$(uname -p).zip" query-engine libquery_engine.so schema-engine
