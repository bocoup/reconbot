const app = require("express")();
const http = require("http").Server(app);
const io = require("socket.io")(http);

app.get("/", function(req, res) {
  res.sendFile(__dirname + "/index.html");
});

const { Board, Led, Servo, Motor, Fn } = require("johnny-five");
// const Edison = require("edison-io");
const Camera = require("./camera");
const Rover = require("./rover");
const board = new Board({
  // io: new Edison()
});

const DEADZONE = 5;
const { RAD_TO_DEG, constrain } = Fn;

board.on("ready", function() {
  const rover = new Rover([
    { dir: 7, pwm: 6 },
    { dir: 8, pwm: 9 },
  ]);

  const camera = new Camera({
    pan: 3, tilt: 5
  });

  let isClientConnected = false;


  io.on("connection", function(socket) {
    // if (isClientConnected) {
    //   return;
    // }
    // isClientConnected = true;

    console.log("Reconbot: Connected");

    socket.on("remote-control", function(data) {

      if (data.component === "rover") {
        rover.update(data.axis);
      }

      if (data.component === "camera") {
        if (data.active) {
          camera.update(data.command);
        } else {
          console.log("calling camera.stop()");
          camera.stop();
        }
      }
    });
  });

  http.listen(3000, function() {
    console.log("http://localhost:3000");
  });
});
