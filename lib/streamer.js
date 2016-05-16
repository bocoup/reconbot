const EventEmitter = require("events").EventEmitter;
const spawn = require("child_process").spawn;

const priv = new WeakMap();

class Streamer extends EventEmitter {
  constructor({command = "mjpg-streamer", frameRate = 15, resolution = "640x480" }) {
    super();
    priv.set(this, { command, frameRate, resolution });
  }

  start() {
    const state = priv.get(this);
    const { command, frameRate, resolution } = state;
    const args = ["-i", `input_uvc.so -f ${frameRate} -r ${resolution}`, "-o", "output_http.so -w ./www"];
    const mjpg = spawn(command, args);
    state[mjpg] = mjpg;
    mjpg.on("exit", (code, signal) => {
      this.emit("stopped", code, signal);
    });
  }

  stop() {
    const { mjpg } = priv.get(this);
    mjpg.kill("SIGINT");
  }
}

module.exports = Streamer;
