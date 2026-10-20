#!/bin/sh
set -e

# Everything OpenMausBot needs to keep lives under $HOME. On the Node runtime
# that is /app, the persistent volume: chats and config in ~/.openmausbot,
# the Claude login in ~/.claude and the Codex login in ~/.codex.
export HOME=/app
export OMB_DATA_DIR=/app/.openmausbot

# claude and codex are installed by npm into the app, not globally.
export PATH="/app/node_modules/.bin:$PATH"

# The server only listens on 127.0.0.1, but only 0.0.0.0:80 is routed to the
# app. bind.cjs rewrites that one listen() call (see the comment in it). The
# server runs as a child of `serve` and inherits this environment.
export OMB_PORT=80
export NODE_OPTIONS="--require /app/bind.cjs ${NODE_OPTIONS:-}"

# The server writes its PID to a lease file in the data dir and treats the dir
# as in use while that PID is alive. A restart kills the old container without
# letting the server release it, and PIDs start low again in the new container,
# so the old PID is alive again (often the new server itself) and the server
# refuses to start. Nothing else in this container can be using the data dir
# yet, so clear the leases. Do not turn on graceful restart for this app: it
# runs two containers on /app at once, and this would drop the old one's lease.
rm -f /app/.openmausbot/openmausbot-server.lease \
  /app/.openmausbot/.openmausbot-server-child/openmausbot-server.lease

# PUBLIC_ORIGIN is resolved from the {DOMAIN} placeholder at deploy time (see
# the app's env vars) to this app's public URL. It goes into pairing links and
# the server's same-origin check.
set -- --port 80
if [ -n "$PUBLIC_ORIGIN" ]; then
  set -- "$@" --public-url "$PUBLIC_ORIGIN"
fi

# A pairing code is printed to the logs on every start (single use, valid for
# five minutes). Open <app url>/pair and type it to sign a browser in.
exec openmausbot serve "$@"
