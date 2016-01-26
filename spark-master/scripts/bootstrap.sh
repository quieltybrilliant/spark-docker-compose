#!/bin/bash

# Start the SSH daemon
service ssh restart

# Setup password less ssh
sshpass -p screencast ssh-copy-id root@localhost

export HOSTNAME=`hostname`
sed -i "s#localhost#$HOSTNAME#g" /opt/hadoop-2.6.0/etc/hadoop/core-site.xml

# Format the NameNode data directory
hdfs namenode -format -force

# Start HDFS services
start-dfs.sh

# Start spark master and worker services
start-master.sh
start-slave.sh spark://`hostname`:7077

# Wait for HDFS services to be up and running
sleep 5

# Create a tmp directory and make it accessible to everyone
hadoop fs -mkdir -p /tmp
hadoop fs -chmod -R 777 /tmp

# Run in daemon mode, don't exit
while true; do
  sleep 100;
done
