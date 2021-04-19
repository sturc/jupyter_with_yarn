# Jupyter Notebook with Yarn / Hadoop

Combines a Jupyter Notebook with an Hadoop / Yarn Container.

The Hadoop image is based on `https://hub.docker.com/r/harisekhon/hadoop`.

As Jupyter Notebook the pyspark notebook is used `https://github.com/jupyter/docker-stacks/tree/master/pyspark-notebook`.

Both containers are connected via a bridge network.

## Start, Stop, Delete

Start the Jupyter Notebook and the Hadoop Cluster by executing:
`docker-compose up`

Stop the Jupter Notebook with:
`docker-compose stop`

Delete the Containers with:
`docker-compose down`

## Login to Jupyter

Execute `docker exec -it notebook jupyter notebook list` to display the required login token.

The notebook is reachable with `http://localhost:8888`.
