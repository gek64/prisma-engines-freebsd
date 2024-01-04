# prisma-engines-freebsd

1. Scripts for building the prisma engine on your own device
2. [Precompiled prisma engine](https://github.com/gek64/prisma-engines-freebsd/releases) for freebsd 11-14
3. Prisma engine usage guide in freebsd

## usage

- for freebsd < 14, download `prisma-engines-FreeBSD_13.2-RELEASE_amd64.zip`, test on freebsd 13.2, freebsd 12.4

- for freebsd >= 14, download `prisma-engines-FreeBSD_14.0-RELEASE_amd64.zip`, test on freebsd 14.0

### use as environment variable

- https://www.prisma.io/docs/concepts/components/prisma-engines#using-custom-engine-libraries-or-binaries

```sh
# detect os
case "$(uname -r)" in
*"11."*)
  FreeBSD_Version=freebsd11
  Prisma_Build=https://github.com/gek64/prisma-engines-freebsd/releases/download/latest/prisma-engines-FreeBSD_13.2-RELEASE_amd64.zip
  ;;
*"12."*)
  FreeBSD_Version=freebsd12
  Prisma_Build=https://github.com/gek64/prisma-engines-freebsd/releases/download/latest/prisma-engines-FreeBSD_13.2-RELEASE_amd64.zip
  ;;
*"13."*)
  FreeBSD_Version=freebsd13
  Prisma_Build=https://github.com/gek64/prisma-engines-freebsd/releases/download/latest/prisma-engines-FreeBSD_13.2-RELEASE_amd64.zip
  ;;
*"14."* | *)
  FreeBSD_Version=freebsd14
  Prisma_Build=https://github.com/gek64/prisma-engines-freebsd/releases/download/latest/prisma-engines-FreeBSD_14.0-RELEASE_amd64.zip
  ;;
esac

# download prisma-engines
curl -Lo "/tmp/prisma-engines.zip" $Prisma_Build

# unzip prisma-engines
unzip -o "/tmp/prisma-engines.zip" -d /tmp/prisma-engines

# rename libquery_engine.so
mv "/tmp/prisma-engines/libquery_engine.so" "/tmp/prisma-engines/libquery_engine.so.node"

# move to `/usr/share/prisma-engines`
mv /tmp/prisma-engines /usr/share/prisma-engines

# set env
export PRISMA_QUERY_ENGINE_BINARY="/usr/share/prisma-engines/query-engine"
export PRISMA_QUERY_ENGINE_LIBRARY="/usr/share/prisma-engines/libquery_engine.so.node"
export PRISMA_SCHEMA_ENGINE_BINARY="/usr/share/prisma-engines/schema-engine"
export PRISMA_CLI_QUERY_ENGINE_TYPE="library"
export PRISMA_CLIENT_ENGINE_TYPE="library"

# run test
npx prisma -v
```

### use as library

```sh
# copy libquery_engine.so.node to project ncc(https://github.com/vercel/ncc) dist folder
cp "/usr/share/prisma-engines/libquery_engine.so.node" "$HOME/moneybook/dist/libquery_engine-$FreeBSD_Version.so.node"

# copy libquery_engine.so.node to project node_modules folder
cp "/usr/share/prisma-engines/libquery_engine.so.node" "$HOME/moneybook/node_modules/.prisma/client/libquery_engine-$FreeBSD_Version.so.node"
```

## compile yourself

```sh
curl -sSf https://raw.githubusercontent.com/gek64/prisma-engines-freebsd/main/build-prisma-engines.sh | sh

ls "$HOME/prisma-engines-*.zip"
```
