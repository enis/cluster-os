#!/bin/bash

source ./env.sh

copy_hadoop_conf() {
  HOSTS_FILE=$1
  pdsh -R exec -w ^$HOSTS_FILE scp $SSH_ARGS -r /etc/hadoop/conf/* root@%h:/etc/hadoop/conf/
}

copy_hbase_conf() {
  HOSTS_FILE=$1
  # we cannot copy everying under conf since jaas conf is per regionserver
  pdsh -R exec -w ^$HOSTS_FILE scp $SSH_ARGS -r /etc/hbase/conf/hbase-site.xml root@%h:/etc/hbase/conf/
  pdsh -R exec -w ^$HOSTS_FILE scp $SSH_ARGS -r /etc/hbase/conf/hbase-env.sh root@%h:/etc/hbase/conf/
  pdsh -R exec -w ^$HOSTS_FILE scp $SSH_ARGS -r /etc/hbase/conf/masters root@%h:/etc/hbase/conf/
  pdsh -R exec -w ^$HOSTS_FILE scp $SSH_ARGS -r /etc/hbase/conf/regionservers root@%h:/etc/hbase/conf/
  pdsh -R exec -w ^$HOSTS_FILE scp $SSH_ARGS -r /etc/hbase/conf/log4j.properties root@%h:/etc/hbase/conf/
}

#echo "****************************"
#echo "Copying hadoop configuration";
#echo "****************************"
#copy_hadoop_conf gateway
#copy_hadoop_conf hadoop/namenode
#copy_hadoop_conf hadoop/snamenode
#copy_hadoop_conf hadoop/jobtracker
#copy_hadoop_conf hadoop/slaves

echo "****************************"
echo "Copying hbase configuration";
echo "****************************"
copy_hbase_conf /etc/hbase/conf/masters
copy_hbase_conf /etc/hbase/conf/regionservers
copy_hbase_conf /etc/hbase/conf/clients

