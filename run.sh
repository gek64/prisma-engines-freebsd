#!/usr/bin/env sh

# nodejs
PATH=node/bin:$PATH

# prisma
## https://www.prisma.io/docs/concepts/components/prisma-engines#using-custom-engine-libraries-or-binaries
PRISMA_QUERY_ENGINE_BINARY=prisma-engines/query-engine
PRISMA_QUERY_ENGINE_LIBRARY=prisma-engines/libquery_engine.so.node
PRISMA_SCHEMA_ENGINE_BINARY=prisma-engines/schema-engine
PRISMA_CLI_QUERY_ENGINE_TYPE=library
PRISMA_CLIENT_ENGINE_TYPE=library
