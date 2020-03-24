# Laboratory Work on Real Time Programming

## Tasks
```
The running server will send a stream of SSE with JSON messages containing readings from 10 sensors (light, wind speed, humidity, atmospheric pressure and temperature, and the timestamp when the event was sent). Your task is to create a system that will convert these readings into a weather forecast that will be updated every 5 seconds. The rule on how to compute the forecast can be found on `/help` route of the running server.
The basic requirements are:
- Process events as soon as they come
- Have a group of workers computing the weather forecast and a supervisor
- Dynamically change the number of actors (up and down) depending on the load
- In case of a special `panic` message, kill the worker actor and then restart it
- Have the results (weather forecast and average values for the metrics) pretty-printed to the console
- The code must be published on Github, otherwise, the lab will not be accepted + please do put it into a container, so I or anyone else can run it locally without much hassle
- Remember the single responsibility principle, in this case - one actor/group of actors per task -> use a different actor for collecting data, creating the forecast, aggregating results, pretty-printing  to console, anything else
- Make it possible to select the update interval, for example, 1 second, 1 minute, 2 minutes, 5 minutes, and so on
```

## Pretty Printing

## Start the project
```
docker pull alexburlacu/rtp-server
docker pull vadimdoga/elix-lab
docker run -p 4000:4000 rtp-server_img
docker run --network host -e RATE=5000 -t elix-lab
```
