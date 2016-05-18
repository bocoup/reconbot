const { Board, Fn, Motor, Motors } = require("johnny-five");
const { RAD_TO_DEG, constrain, scale } = Fn;
const priv = new WeakMap();

const SPEED_MIN = 50;
const SPEED_MAX = 200;

class Rover {
  constructor(pinDefs) {

    var pins = [
      { pins: pinDefs[0], invertPWM: true },
      { pins: pinDefs[1], invertPWM: true },
    ];

    pins[0].threshold = pins[0].threshold || 0;
    pins[1].threshold = pins[1].threshold || 0;

    priv.set(this, new Motors(pins));

    this.stop();
  }

  get left() {
    return priv.get(this)[0];
  }
  get right() {
    return priv.get(this)[1];
  }

  update(axis) {
    let { x, y } = axis;

    // See drive.md
    //
    // Compute angle of joystick
    let angle = Math.acos(Math.abs(x) / Math.hypot(x, y)) * RAD_TO_DEG;

    // Compute "turn coefficient"
    let coeff = -1 + (angle / 90) * 2;
    let turn = coeff * Math.abs(Math.abs(y) - Math.abs(x));

    turn = Math.round(turn * 100) / 100;

    let move = Math.max(Math.abs(y), Math.abs(x));
    let direction = {
      left: "forward",
      right: "forward",
    };

    let speed = {
      left: 0,
      right: 0,
    };

    // Determine quadrant...
    if ((x >= 0 && y >= 0) || (x < 0 && y < 0)) {
      speed.left = move;
      speed.right = turn;
    } else {
      speed.right = move;
      speed.left = turn;
    }

    // Invert when reversing...
    if (y < 0) {
      speed.left *= -1;
      speed.right *= -1;
      // TODO: Can we flip these here? For Reverse-And-Turn?
    }

    speed.left = Math.round(Number.isNaN(speed.left) ? 0 : speed.left);
    speed.right = Math.round(Number.isNaN(speed.right) ? 0 : speed.right);

    if (speed.left < 0) {
      direction.left = "reverse";
      speed.left *= -1;
    }

    if (speed.right < 0) {
      direction.right = "reverse";
      speed.right *= -1;
    }

    if (speed.left === 0 && speed.right === 0) {
      this.stop();
    } else {
      let left = scale(speed.left, 0, 100, SPEED_MIN, SPEED_MAX);
      let right = scale(speed.right, 0, 100, SPEED_MIN, SPEED_MAX);

      this.left[direction.left](left);
      this.right[direction.right](right);
    }

    return this;
  }

  stop() {
    priv.get(this).stop();
  }
}

module.exports = Rover;
