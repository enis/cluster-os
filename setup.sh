#!/bin/bash
source ./env.sh

# first host is the hbase client on HDP deployments
head -n 1 /tmp/all_internal_nodes >/etc/hbase/conf/clients

# second or third host is the master on HDP deployments
head -n 3 /tmp/all_internal_nodes | tail -n 1  >/etc/hbase/conf/masters

# get rid of Ranger BS
sed -i 's/com.xasecure.authorization.hbase.XaSecureAuthorizationCoprocessor//' /etc/hbase/conf/hbase-site.xml 
sed -i 's/hbase.rpc.protection/not-set-property/' /etc/hbase/conf/hbase-site.xml 
sed -i 's/hbase.security.authorization/not-set-property/' /etc/hbase/conf/hbase-site.xml 

rm -rf /etc/hbase/conf/xasecure* 
rm -rf /etc/hbase/conf/ranger* 
rm -rf /usr/hdp/current/hbase-master/lib/ranger-* 
rm -rf /usr/hdp/current/hbase-master/lib/mysql-connector-java.jar
rm -rf /usr/hdp/current/hbase-master/lib/ojdbc6.jar

alias hbase=/usr/hdp/current/hbase-client/bin/hbase

# clean up smoke test table left 
#echo "disable 'usertable'; drop 'usertable'" | hbase shell

# install git and others
apt-get install git python-pip maven python-protobuf
yum -y install git python-pip maven python-protobuf
pip install -U pytest

# create Hadoop dirs
sudo -u hdfs hadoop fs -mkdir /user/root
sudo -u hdfs hadoop fs -chown root:root /user/root 

# remove stupid motd
pdsh -R exec -w ^/tmp/all_internal_nodes ssh $SSH_ARGS -l %u %h "rm /etc/motd; touch /etc/motd"
