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
  local HOSTS_FILE=$1
  local TARGET_DIR=$2
  pdsh -R exec -w ^$HOSTS_FILE ssh $SSH_ARGS -l %u %h "rm -rf $TARGET_DIR/lib/*";
  pdsh -R exec -w ^$HOSTS_FILE scp $SSH_ARGS -r $TARBALL/lib/* %h:$TARGET_DIR/lib/
  pdsh -R exec -w ^$HOSTS_FILE ssh $SSH_ARGS -l %u %h "cp $TARGET_DIR/bin/hbase $TARGET_DIR/bin/hbase.hdp" #backup bin/hbase script specific to hdp
  pdsh -R exec -w ^$HOSTS_FILE scp $SSH_ARGS -r $TARBALL/bin/* %h:$TARGET_DIR/bin/
  pdsh -R exec -w ^$HOSTS_FILE ssh $SSH_ARGS -l %u %h "cp $TARGET_DIR/bin/hbase $TARGET_DIR/bin/hbase.distro" #copy bin/hbase script to bin/hbase.dist
  pdsh -R exec -w ^$HOSTS_FILE ssh $SSH_ARGS -l %u %h "cp $TARGET_DIR/bin/hbase.hdp $TARGET_DIR/bin/hbase" #restore bin/hbase script specific to hdp
  pdsh -R exec -w ^$HOSTS_FILE scp $SSH_ARGS -r $TARBALL/hbase-webapps/* %h:$TARGET_DIR/hbase-webapps/
  pdsh -R exec -w ^$HOSTS_FILE ssh $SSH_ARGS -l %u %h "rm -rf $TARGET_DIR/lib/hadoop-*.jar";
  pdsh -R exec -w ^$HOSTS_FILE ssh $SSH_ARGS -l %u %h "chmod 744 $TARGET_DIR/lib/*; chmod 755 $TARGET_DIR/bin/*; chmod 755 $TARGET_DIR/hbase-webapps/*; chmod -R 755 $TARGET_DIR/lib/ruby/";

  # link Phoenix if it is there
  pdsh -R exec -w ^$HOSTS_FILE ssh $SSH_ARGS -l %u %h "cd /usr/hdp/current/hbase-regionserver/lib/ && ln -s /usr/hdp/current/phoenix-server/phoenix-server.jar phoenix-server.jar"
}

deploy $HBASE_CONF_DIR/masters $HDP/hbase-master/
deploy $HBASE_CONF_DIR/regionservers $HDP/hbase-regionserver/
