// Built-in Dependencies
const os = require("os");
const Server = require("http").Server;

// Third Party Dependencies
const Express = require("express");
const Socket = require("socket.io");

// Internal/Application Dependencies
const { Board, Fn } = require("johnny-five");
const Edison = require("edison-io");
const Camera = require("./lib/camera");
const Rover = require("./lib/rover");


// Application, Server and Socket
const app = Express();
const server = new Server(app);
const socket = new Socket(server);

// Configure express application server:
app.use(Express.static("app"));
app.get("/video", (request, response) => {
  response.redirect(`http://${request.hostname}:8080/?action=stream`);
});

const port = process.env.PORT || (process.env.USER === "root" ? 80 : 3000);
const listen = new Promise(resolve => {
  server.listen(port, () => {
    resolve();
  });
});

const board = new Board({
  sigint: false,
  repl: false,
  io: new Edison()
});

board.on("ready", () => {

  const rover = new Rover([
    { dir: 12, pwm: 6 },
    { dir: 8, pwm: 9 },
  ]);
  console.log("Rover: Initialized");

  const camera = new Camera({
    pan: 3, tilt: 5
  });
  console.log("Camera: Initialized");

  socket.on("connection", socket => {
    console.log("Reconbot: Connected");

    socket.on("remote-control", data => {
      if (data.component === "rover") {
        rover.update(data.axis);
      }

      if (data.component === "camera") {
        camera.update(data.axis);
      }
    });
  });

  listen.then(() => {
    console.log(`http://${os.hostname()}:${port}`);
    console.log(`http://${os.networkInterfaces().wlan0[0].address}:${port}`);
  });
});
