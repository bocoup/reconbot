const { Board, Fn, Servos } = require("johnny-five");
const priv = new WeakMap();

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
      this.pan.to(0, ms);
    }

    if (direction === "right") {
      this.pan.to(180, ms);
    }

    if (direction === "up") {
      this.tilt.to(10, ms);
    }

    if (direction === "down") {
      this.tilt.to(100, ms);
    }

    if (direction === "center") {
      this.stop();
      this.tilt.to(60);
      this.pan.to(98);
    }

    return this;
  }

  stop() {
    priv.get(this).stop();
  }
}

module.exports = Camera;
