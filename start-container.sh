#!/bin/bash

# the default node number is 3
N=${1:-3}


# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -d -P -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                -p 8085:8085 \
                --name hadoop-master \
                --hostname hadoop-master \
		-v /data/docker_hadoop:/root/hdfs/ \
                oelesin/hadoop-spark-cluster:latest &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -d -P -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
			-v /data/docker_hadoop:/root/hdfs/ \
	                oelesin/hadoop-spark-cluster:latest &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master bash
