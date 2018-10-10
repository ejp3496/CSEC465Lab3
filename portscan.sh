#!/bin/bash

ipadd=
ports=

expandipadd() {
  cidr=$1
  
  # range is bounded by network (-n) & broadcast (-b) addresses
  lo=$(ipcalc -n $cidr |cut -f2 -d=)
  hi=$(ipcalc -b $cidr |cut -f2 -d=)
  
  read a b c d < $(echo $lo |tr . ' ')
  read e f g h < $(echo $hi |tr . ' ')
  
  eval "echo {$a..$e}.{$b..$f}.{$c..$g}.{$d..$h}"
}

getipaddresses() {
  ipadd=$1
  if [[ $ipadd = *-* ]]; then
    ipadd=`(ipcalc $ipadd | sed '2!d')`
  fi
}

getportnum() {
  ports=$1
  if [[ $ports = *,* ]]; then
    ports=`echo $ports | tr ',' ' '`
  fi
}

addresses=$1
if [ "$addresses" = "" ]; then
  echo "no addresses specified"
  exit 1
fi
portrange=$2
if [ "$portrange" = "" ]; then
  echo "no ports specified"
  exit 1
fi

getipaddresses $addresses
getportnum $portrange

for iprange in $ipadd; do
  addres=`expandipadd $iprange`
  for ip in $addres; do
    nc -zv $ip $ports
  done
done
