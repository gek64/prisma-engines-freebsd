#!/usr/bin/env sh

Check_Command() {
  ## 返回值判断 1为不存在 0为存在
  if [ ! "$(command -v "$1")" ]; then
    return 1
  else
    return 0
  fi
}

Install_Toolchain() {
  pkg install -y git curl protobuf ca_root_nss
  export CC=clang
  export CXX=clang++
}

Install_Openssl() {
  case "$(uname -r)" in
  *"11."* | *"12."* | *"13."*)
    pkg install -y openssl111
    ;;
  *"14."* | *)
    pkg install -y openssl32
    ;;
  esac
}

Compile_Openssl() {
  case "$(uname -r)" in
  *"11."* | *"12."* | *"13."*)
    git clone --depth 1 --recurse-submodules --branch "OpenSSL_1_1_1-stable" https://github.com/openssl/openssl.git "$HOME/openssl"
    ;;
  *"14."* | *)
    git clone --depth 1 --recurse-submodules --branch "openssl-3.2.0" https://github.com/openssl/openssl.git "$HOME/openssl"
    ;;
  esac
  cd "$HOME/openssl" || exit
  # 编译配置参数 https://wiki.openssl.org/index.php/Compilation_and_Installation
  ./config --prefix=/usr/local
  make -j "$(sysctl -n hw.ncpu)" && make install
}

Compile_Prisma() {
  ## 安装 rust(https://github.com/rust-lang/rustup/issues/297)
  curl -sSf https://sh.rustup.rs | sh -s -- -y
  export PATH=$HOME/.cargo/bin:$PATH

  ## 下载源码并编译
  git clone --depth 1 --recurse-submodules "https://github.com/prisma/prisma-engines.git" "$HOME/prisma-engines"
  cd "$HOME/prisma-engines" || exit
  RUSTFLAGS="-l static=ssl -l static=crypto -L /usr/local/lib" cargo build --release

  ## 压缩打包
  tar -czvf "$HOME/prisma-engines-$(uname -o)_$(uname -r)_$(uname -p).tar.gz" -C "$HOME/prisma-engines/target/release" test-cli prisma-fmt schema-engine query-engine libquery_engine.so
}

Init() {
  Compile_From_Source=false

  while [ $# -gt 0 ]; do
    case "$1" in
    "-c" | "--compile_openssl")
      Compile_From_Source=true
      shift 1
      ;;
    *)
      echo "$0: Unknown Arguments"
      Show_help
      shift 1
      exit 1
      ;;
    esac
  done

  Install_Toolchain

  if [ $Compile_From_Source = true ]; then
    Compile_Openssl
  else
    Install_Openssl
  fi

  Compile_Prisma
}

Init "$@"
