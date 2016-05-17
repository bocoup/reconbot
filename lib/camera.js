const { Board, Fn, Servos } = require("johnny-five");
const priv = new WeakMap();

const TILT_CENTER = 33;
const TILT_MIN = 0;
const TILT_MAX = 100;

const PAN_CENTER = 79;
const PAN_MIN = 0;
const PAN_MAX = 180;

class Camera {
  constructor(pinDefs) {
    var pins = Object.keys(pinDefs).map(key => ({
      pin: pinDefs[key],
      id: key
    }));

    priv.set(this, new Servos(pins));

    this.update("center");
  }

  get pan() {
    return priv.get(this)[0];
  }

  get tilt() {
    return priv.get(this)[1];
  }

  update(direction) {
    let ms = 500;

    if (direction === "left") {
      this.pan.to(PAN_MIN, ms);
    }

    if (direction === "right") {
      this.pan.to(PAN_MAX, ms);
    }

    if (direction === "up") {
      this.tilt.to(TILT_MIN, ms);
    }

    if (direction === "down") {
      this.tilt.to(TILT_MAX, ms);
    }

    if (direction === "center") {
      this.stop();
      this.tilt.to(TILT_CENTER);
      this.pan.to(PAN_CENTER);
    }

    return this;
  }

  stop() {
    priv.get(this).stop();
  }
}

module.exports = Camera;
