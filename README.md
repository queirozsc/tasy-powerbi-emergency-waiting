# tasy-powerbi-emergency-waiting
 Waiting time for Emergency's patients.
 Script that query an Oracle database at every minute and send data to dashboard monitoring.

 >This code was inspired by Marco Russo's article [Implementing real-time updates in Power BI using push datasets instead of DirectQuery](https://www.sqlbi.com/articles/implementing-real-time-updates-in-power-bi-using-push-datasets-instead-of-directquery/)

## Code Versions
### Power BI
To understand several ways to show real time data on Power BI, read [Real-time streaming in Power BI](https://learn.microsoft.com/en-us/power-bi/connect-data/service-real-time-streaming)
- Streaming dataset  
For a Power BI streaming dataset, run:
`emergency-waiting-powerbi-streaming.ps1`
- Push dataset  
For a Power BI push dataset, run:
`emergency-waiting-powerbi-push.ps1`

>In Feb 27, 2023 Microsoft anounced the [retirement of streaming dataflows](https://powerbi.microsoft.com/en-us/blog/announcing-the-retirement-of-streaming-dataflows/)

### Databox
[Databox](https://databox.com/) is a fancy mobile-first solution to easily create dashboards and datawalls integrated with popular tools.  
Run:  
`emergency-waiting-databox.ps1`

### Elastic Stack
[Elastic Stack](https://www.elastic.co/es/what-is/elk-stack) refers to a stack with a JSON-based search (Elastic) and a user interface to data (Kibana).  
Run:  
`emergency-waiting-elasticsearch.ps1`

## Setting up Oracle Client
This code requires Oracle Instant Client for Windows 64-bit.  
Download and install at https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html

> On Oracle Setup wizard, select **Run time** setup option

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