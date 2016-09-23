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

    this.update({ x: 0, y: 0 });
  }

  get pan() {
    return priv.get(this)[0];
  }

  get tilt() {
    return priv.get(this)[1];
  }

  stop() {
    priv.get(this).stop();
  }

  update(axis) {
    let ms = 250;
    let { x, y } = axis;

    this.stop();

    if (x === 0) {
      this.pan.to(PAN_CENTER);
    }

    if (y === 0) {
      this.tilt.to(TILT_CENTER);
    }

    // DOWN
    if (y < 0) {
      this.tilt.to(Fn.scale(y, 0, -100, TILT_CENTER, TILT_MAX));
    }

    // UP
    if (y > 0) {
      this.tilt.to(Fn.scale(y, 0, 100, TILT_CENTER, TILT_MIN));
      // this.tilt.to(TILT_MIN, ms);
    }

    // LEFT
    if (x < 0) {
      this.pan.to(Fn.scale(x, 0, -100, PAN_CENTER, PAN_MIN));
    }

    if (x > 0) {
      this.pan.to(Fn.scale(x, 0, 100, PAN_CENTER, PAN_MAX));
    }
    return this;
  }
}

module.exports = Camera;
