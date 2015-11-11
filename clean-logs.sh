#!/bin/bash

source ./env.sh 

echo "****************************"
echo "clean hbase logs";
echo "****************************"

for i in `cat $HBASE_CONF_DIR/masters $HBASE_CONF_DIR/regionservers`; do
  echo $i;
  ssh $SSH_ARGS $i "rm -rf /grid/0/var/log/hbase/*; rm -rf /var/log/hbase/*; rm -rf /grid/0/log/hbase/*;" ;
done
