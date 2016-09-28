const mdns = require("mdns-js");
const name = process.env.RECONBOT_NAME || "unknown-reconbot";
const service = mdns.createAdvertisement(mdns.tcp("_http"), 80, {
  name: name,
  txt:{
    md: "reconbot",
    fn: name
  }
});
service.start();

module.exports = {
  mdns,
  service
};
