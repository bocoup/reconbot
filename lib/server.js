// Built-in Dependencies
const os = require("os");

// Third Party Dependencies
const express = require("express");
const app = express();
const http = require("http").Server(app);
const io = require("socket.io")(http);

// Internal/Application Dependencies
const { Board, Fn } = require("johnny-five");
const Edison = require("edison-io");
const Camera = require("./camera");
const Rover = require("./rover");

// Configure express application server:
//
//  - asset source
//  - video source
//
app.use(express.static("static"));
app.get("/video", (req, res) => {
  res.redirect(`http://${req.hostname}:8080/?action=stream`);
});

const port = process.env.PORT || (process.env.USER === "root" ? 80 : 3000);
const server = new Promise(resolve => {
  http.listen(port, () => {
    resolve();
  });
});

const board = new Board({
  sigint: false,
  io: new Edison()
});

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

  server.then(() => console.log(`http://${os.hostname()}:${port}`));
});
