FROM mapbox/robosat:latest-gpu

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git vim

RUN pip3 install jupyter

# Install E84's fork of robosat repo
RUN cd /tmp && \
	git clone https://github.com/Element84/robosat && \
	rsync -av /tmp/robosat/ /app

# Create the directory used to store checkpoints during learning
RUN mkdir -p /app/container_mount/checkpoints/
RUN mkdir /app/robosat_container_files/

# Copy our notebook and area of interest into docker
COPY *.ipynb /app
COPY osm/*.pbf /app/container_mount
COPY images/* /app/images

# Substitute required ENV variables 'DESIRED_ZOOM_LEVEL' and 'PUBLIC_IP'
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
