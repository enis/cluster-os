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
  scp $SSH_ARGS -r /etc/hbase/conf/* root@$i:/etc/hbase/conf/ ;
done
