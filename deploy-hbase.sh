#!/bin/bash

echo "****************************"
echo "deploy hbase";
echo "****************************"

source ./env.sh

for i in `cat $HBASE_CONF_DIR/clients`; do
  echo $i;
  ssh $SSH_ARGS  $i "rm -rf /usr/hdp/current/hbase-client/lib/hbase*.jar " ;
  scp $SSH_ARGS -r hbase-*.jar disruptor*.jar htrace*.jar netty*.jar ruby $i:/usr/hdp/current/hbase-client/lib/
done

for i in `cat $HBASE_CONF_DIR/masters`; do
  echo $i;
  ssh $SSH_ARGS  $i "rm -rf /usr/hdp/current/hbase-master/lib/hbase*.jar " ;
  scp $SSH_ARGS -r hbase-*.jar disruptor*.jar htrace*.jar netty*.jar ruby $i:/usr/hdp/current/hbase-master/lib/
done

for i in `cat $HBASE_CONF_DIR/regionservers`; do
  echo $i;
  ssh $SSH_ARGS $i "rm -rf /usr/hdp/current/hbase-regionserver/lib/hbase*.jar " ;
  scp $SSH_ARGS -r hbase-*.jar disruptor*.jar htrace*.jar netty*.jar ruby $i:/usr/hdp/current/hbase-regionserver/lib/
done
