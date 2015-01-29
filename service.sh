  if [ "$#" -eq "0" ] ; then
    echo "usage: $0 start | stop | restart  "
    exit
  fi

export cmd=$1
