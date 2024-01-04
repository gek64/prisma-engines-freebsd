# prisma-engines-freebsd

## how to use

- https://www.prisma.io/docs/concepts/components/prisma-engines#using-custom-engine-libraries-or-binaries

### environment variable

```sh
## rename libquery_engine.so to libquery_engine.so.node
mv "./libquery_engine.so" "./libquery_engine.so.node"

## set environment variables
PRISMA_QUERY_ENGINE_BINARY="./query-engine"
PRISMA_QUERY_ENGINE_LIBRARY="./libquery_engine.so.node"
PRISMA_SCHEMA_ENGINE_BINARY="./schema-engine"
PRISMA_CLI_QUERY_ENGINE_TYPE="library"
PRISMA_CLIENT_ENGINE_TYPE="library"

## test
npx prisma -v
```

### library file

```sh
## rename libquery_engine.so to libquery_engine.so.node
mv "./prisma-engines/libquery_engine.so" "./prisma-engines/libquery_engine-freebsd13.so.node"
```