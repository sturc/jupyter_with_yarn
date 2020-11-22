# Jupyter Notebook with Yarn / Hadoop

Combines a Jupyter Notebook with an Hadoop / Yarn Container.

The Hadoop image is based on `https://hub.docker.com/r/harisekhon/hadoop`.

As Jupyter Notebook the pyspark notebook is used `https://github.com/jupyter/docker-stacks/tree/master/pyspark-notebook`.

Both containers are connected via a bridge network. 

## Start them with:

`docker-compose up`

## Login to Jupyter

Execute `docker exec -it notebook jupyter notebook list` to display the required login token.

The notebook is reachable with `http://localhost:8888`.