#!/bin/bash

if [[ -z $DESIRED_ZOOM_LEVEL ]] || [[ -z $PUBLIC_IP ]]; then
	echo 'ERROR: Missing required docker environment variables DESIRED_ZOOM_LEVEL or PUBLIC_IP!'
	exit 1
fi

sed -i "s/DESIRED_ZOOM_LEVEL/$DESIRED_ZOOM_LEVEL/g" /app/robosat/tools/serve.py
sed -i "s/DESIRED_ZOOM_LEVEL/$DESIRED_ZOOM_LEVEL/g" /app/robosat/tools/templates/map.html
sed -i "s/PUBLIC_IP/$PUBLIC_IP/g" /app/robosat/tools/templates/map.html
exec "$@"
