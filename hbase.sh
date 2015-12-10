#!/bin/bash

source ./env.sh
source ./service.sh

echo "****************************"
echo "$cmd hbase";
echo "****************************"

pdsh -R exec -w ^/etc/hbase/conf/masters ssh $SSH_ARGS -l %u %h "su - hbase -c '/usr/hdp/current/hbase-master/bin/hbase-daemon.sh --config /etc/hbase/conf $cmd master'";

pdsh -R exec -w ^/etc/hbase/conf/regionservers ssh $SSH_ARGS -l %u %h "su - hbase -c '/usr/hdp/current/hbase-master/bin/hbase-daemon.sh --config /etc/hbase/conf $cmd regionserver'";
