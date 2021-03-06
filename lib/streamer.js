const { EventEmitter } = require("events");
const { spawn } = require("child_process");

const priv = new WeakMap();
const children = new Set();

class Streamer extends EventEmitter {
  constructor({ command = "/usr/local/bin/mjpg_streamer", frameRate = 15, resolution = "640x480" } = {}) {
    super();
    priv.set(this, { command, frameRate, resolution });
  }

  start() {
    const state = priv.get(this);
    const { command, frameRate, resolution } = state;
    const args = ["-i", `input_uvc.so -f ${frameRate} -r ${resolution}`, "-o", "output_http.so"];
    const mjpg = spawn(command, args, {stdio: "inherit"});
    state.mjpg = mjpg;
    children.add(mjpg);
    mjpg.on("exit", (code, signal) => {
      children.delete(mjpg);
      this.emit("stopped", { code, signal });
    });
  }

  stop() {
    const { mjpg } = priv.get(this);
    mjpg.kill("SIGINT");
  }
}

const cleanupOnExit = (event) => {
  for (let mjpg of children) {
    mjpg.kill("SIGINT");
  }
  if (event) {
    console.error(event);
  }
  process.exit();
};

const exitEvents = [
  "exit",
  "SIGINT",
  "SIGTERM",
  "uncaughtException"
];

exitEvents.forEach(event => process.on(event, cleanupOnExit));

module.exports = Streamer;
