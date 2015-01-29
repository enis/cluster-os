#!/bin/bash

export SSH_ARGS="-o StrictHostKeyChecking=no -i /tmp/hw-dev-keypair.pem"
export HBASE_CONF_DIR=/etc/hbase/conf/
export HDP=/usr/hdp/current/
