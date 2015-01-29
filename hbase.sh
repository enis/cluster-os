#!/bin/bash

source ./env.sh
source ./service.sh

echo "****************************"
echo "$cmd hbase";
echo "****************************"

for i in `cat /etc/hbase/conf/masters`; do
  echo $i;
  ssh $SSH_ARGS $i "su - hbase -c '/usr/hdp/current/hbase-master/bin/hbase-daemon.sh --config /etc/hbase/conf $cmd master'";
done

for i in `cat /etc/hbase/conf/regionservers`; do
  echo $i
  ssh $SSH_ARGS $i "su - hbase -c '/usr/hdp/current/hbase-regionserver/bin/hbase-daemon.sh --config /etc/hbase/conf $cmd regionserver'";
done
