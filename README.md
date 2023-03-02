# tasy-powerbi-emergency-waiting
 Waiting time for Emergency's patients. Script that query an Oracle database at every 5 minutes and send data to Service Real Time Streaming of Power BI' service

## Setting up ELK Stack on Docker for Windows
### Install Docker Desktop
1. Visit https://docs.docker.com/desktop/install/windows-install/, download and install.

### Pull images
1. In Docker Desktop, search for **elasticsearch** and **kibana** Docker official images.

### Running Elastic Search
1. In Docker Desktop, go to **Images**, select **elasticsearch** and Run.
2. At window *Run a new container*, set the environment variable
`discovery.type : single-node`

### Running Kibana for first time
1. Visit http://localhost:5601/
2. At ElasticSearch's terminal run:

   `bin\elasticsearch-create-enrollment-token -s kibana`
1. Copy the generated token and paste on Kibana home screen
2. At Kibana's log copy the verification code and paste on Kibana home screen
3. At ElasticSearch's terminal run:

   `bin\elasticsearch-reset-password -u elasticsearch`
4. Save this password for further accesses

### Issues with network
At dev environments, turn on network connections from localhost:

`docker network create elastic`

Then run from command line:

`docker run -it --name:elasticsearch-tasy --net elastic -p 9200:9200 -p 9300:9300 --env=discovery.type=single-node elasticsearch:8.6.2`
`docker run -it --name:kibana-tasy --net elastic -p 5601:5601 kibana:8.6.2`

`docker run -it --net elastic -p 9200:9200 -p 9300:9300 --env=discovery.type=single-node elasticsearch:8.6.2`
`docker run -it --net elastic -p 5601:5601 kibana:8.6.2`