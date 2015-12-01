#!/bin/bash

source ./env.sh

echo "****************************"
echo "Copying hadoop configuration";
echo "****************************"
#for i in `cat gateway hadoop/namenode hadoop/snamenode hadoop/jobtracker hadoop/slaves`;  do·
#  echo $i;·
#  scp $SSH_ARGS -r hadoop/* root@$i:/etc/hadoop/conf/ ;·
#done

echo "****************************"
echo "Copying hbase configuration";
echo "****************************"
for i in `cat /etc/hbase/conf/masters /etc/hbase/conf/regionservers /etc/hbase/conf/clients`; do
  echo $i;
  # we cannot copy everying under conf since jaas conf is per regionserver
  scp $SSH_ARGS -r /etc/hbase/conf/hbase-site.xml root@$i:/etc/hbase/conf/ ;
  scp $SSH_ARGS -r /etc/hbase/conf/hbase-env.sh root@$i:/etc/hbase/conf/ ;
  scp $SSH_ARGS -r /etc/hbase/conf/masters root@$i:/etc/hbase/conf/ ;
  scp $SSH_ARGS -r /etc/hbase/conf/regionservers root@$i:/etc/hbase/conf/ ;
  scp $SSH_ARGS -r /etc/hbase/conf/log4j.properties root@$i:/etc/hbase/conf/ ;
done
