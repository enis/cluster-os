#!/bin/bash

if [ "$#" -eq "0" ] ; then
  echo "usage: $0 <target_path> "
  exit
fi

TARGET=$1

source ./env.sh 

echo "****************************"
echo "copy hbase logs";
echo "****************************"

mkdir $TARGET
for i in `cat $HBASE_CONF_DIR/masters $HBASE_CONF_DIR/regionservers`; do
  echo $i;
  scp $SSH_ARGS -r root@$i:/var/log/hbase/* $TARGET/;
  scp $SSH_ARGS -r root@$i:/grid/0/log/hbase/* $TARGET/;
done
