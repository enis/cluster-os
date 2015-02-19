#!/bin/bash

source ./env.sh

if [ "$#" -eq "0" ] ; then
  echo "usage: $0 <tarball_path> "
  exit
fi

TARBALL=$1

echo "***********************************"
echo "deploy hbase from tarball $TARBALL";
echo "***********************************"

deploy() {
  local TARGET_DIR=$1 
  echo $i;
  ssh $SSH_ARGS $i "rm -rf $TARGET_DIR/lib/*";
  scp $SSH_ARGS -r $TARBALL/lib/* $i:$TARGET_DIR/lib/
  ssh $SSH_ARGS $i "cp $TARGET_DIR/bin/hbase $TARGET_DIR/bin/hbase.hdp" #backup bin/hbase script specific to hdp
  scp $SSH_ARGS -r $TARBALL/bin/* $i:$TARGET_DIR/bin/
  ssh $SSH_ARGS $i "cp $TARGET_DIR/bin/hbase $TARGET_DIR/bin/hbase.distro" #copy bin/hbase script to bin/hbase.dist
  ssh $SSH_ARGS $i "cp $TARGET_DIR/bin/hbase.hdp $TARGET_DIR/bin/hbase" #restore bin/hbase script specific to hdp
  scp $SSH_ARGS -r $TARBALL/hbase-webapps/* $i:$TARGET_DIR/hbase-webapps/
  ssh $SSH_ARGS $i "rm -rf $TARGET_DIR/lib/hadoop-*.jar";
}

for i in `cat $HBASE_CONF_DIR/clients`; do
  deploy $HDP/hbase-client/
done

for i in `cat $HBASE_CONF_DIR/masters`; do
  deploy $HDP/hbase-master/
done

for i in `cat $HBASE_CONF_DIR/regionservers`; do
  deploy $HDP/hbase-regionserver/
done
