// Preloaded through NODE_OPTIONS=--require (see start.sh).
//
// OpenMausBot's server hardcodes server.listen(PORT, "127.0.0.1"), with no
// setting to change it, but only 0.0.0.0:80 is routed to the app. This
// rewrites that one call to listen on 0.0.0.0 instead. It only touches a
// listen() on OMB_PORT bound to 127.0.0.1, so any other server in a process
// that inherits NODE_OPTIONS (the CLIs the bots spawn) is left alone.
const net = require("node:net");

const port = Number(process.env.OMB_PORT);
const listen = net.Server.prototype.listen;

net.Server.prototype.listen = function (...args) {
  const [first, second] = args;
  if (first === port && second === "127.0.0.1") {
    args[1] = "0.0.0.0";
  } else if (first && typeof first === "object" && first.port === port && first.host === "127.0.0.1") {
    args[0] = { ...first, host: "0.0.0.0" };
  }
  return listen.apply(this, args);
};
