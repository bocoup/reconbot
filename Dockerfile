# one of these https://hub.docker.com/r/resin/edison-node/tags/
FROM resin/edison-node:6.2-20160602

# bump this for a full rebuild
ENV version=2

WORKDIR /usr/src/app

# setup streamer
COPY install-mjpg-streamer.sh ./
RUN ./install-mjpg-streamer.sh
ENV LD_LIBRARY_PATH /usr/local/lib/

# Copies the package.json first for better cache on later pushes
COPY package.json package.json

# This install npm dependencies on the resin.io build server,
# making sure to clean up the artifacts it creates in order to reduce the image size.
# We install mraa manually as the edison-io package doesn't detect that it's safe to install to install it on the resin.io build servers
RUN JOBS=MAX npm install --production --unsafe-perm && \
  npm install mraa@0.9.4 && \
  npm cache clean && \
  rm -rf /tmp/*

# This will copy all files in our root to the working directory in the container
COPY . ./

# server.js will run when container starts up on the device
CMD ["./start.sh"]
