Introduction
=======
This is a fully-functioning Jupyter Notebook that describes and walks through all of the steps in an excellent blog post on the Robosat feature extraction and machine learning pipeline. The original post:

https://www.openstreetmap.org/user/daniel-j-h/diary/44321

We'll be using the Robosat feature extraction pipeline:

https://github.com/mapbox/robosat

Prerequisites
=======
### Docker and EC2
This notebook requires NVIDIA graphics drivers (e.g. an EC2 P2 instance) to run every step end-to-end, although some commands may be run locally. MapBox recommends AWS P2/P3 instances and GTX 1080 TI GPUs.

Instructions for provisioning an EC2 instance:

https://docs.aws.amazon.com/efs/latest/ug/gs-step-one-create-ec2-resources.html

Once set up, you will need to build and run the docker image from the EC2. Instructions for building this docker image below, in "Building and Running the Notebook". General Docker build instructions:

https://docs.docker.com/engine/reference/builder/#usage

### Environment Variables
You are running this Jupyter notebook from inside a docker container and passed in two `docker run` environment variables: `DESIRED_ZOOM_LEVEL` and `PUBLIC_IP`.

`DESIRED_ZOOM_LEVEL` is the zoom level for your imagery.
`PUBLIC_IP` is the public IP address if you're running from an EC2 instance. 

### Prior to running the notebook

## These steps have already been completed and the result is included. You do not need to do this unless you want to use a different area of interest.

1. Install Osmium locally using brew

`brew install osmium-tool`

2. Get the GeoFrabrik extract

`http://download.geofabrik.de/africa/tanzania-latest.osm.pbf`

3. Extract the area of intrerest

`osmium extract --bbox '38.9410400390625,-7.0545565715284955,39.70458984374999,-5.711646879515092' tanzania-latest.osm.pbf --output map.osm.pbf`

Also, it may be necessary to adjust dataset-parking.toml and model-unet.toml. Specfically, `classes = ['background', 'building']` in dataset-parking.toml and the `image_size` in model-unet.toml should match your requirements .

Building and Running the Notebook
=======

These steps need to be completed inside of your EC2 instance, where this repo should live.

Build the Docker image:
=======
These steps have been performed and the resulting .pbf file is bundled with this image.

`docker build -t robosat-jupyter .`

Run the Docker image detached:

Note: this command assumes you're running on our CUDA-enabled EC2 instance.

IMPORTANT: You _must_ update the `PUBLIC_IP` and `DESIRED_ZOOM_LEVEL`. See the Environment Variables section above.

`docker run -d --runtime=nvidia -v /home/ubuntu/robosat/container_mount:/app/container_mount -v /home/ubuntu/robosat_container_files:/app/robosat_container_files -e DESIRED_ZOOM_LEVEL=19 -e PUBLIC_IP=34.56.78.90 -p 8888:8888 -p 5000:5000 -t robosat-jupyter jupyter notebook --ip=0.0.0.0 --allow-root`

If you're running this docker locally, use this instead:

`docker run -d -p 8888:8888 -e DESIRED_ZOOM_LEVEL=19 -e PUBLIC_IP=34.56.78.90 -p 5000:5000 -t robosat-jupyter jupyter notebook --ip=0.0.0.0 --allow-root`

`docker ps` to find the currently running image

`docker logs {Image ID}` To see the Jupyter notebook, open the docker logs and get the URL with token.

`docker exec -it {Image ID} bash` to get into the container

Enter the URL in your browser, replacing the local IP with the IP of the remote docker container if appropriate, supply the token, and behold the notebook!


License
=======

Copyright 2018 Element 84

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
