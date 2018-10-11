#!/bin/bash

os=

getos() {
  ipaddress=$1
  ping -c 2 $ipaddress > /dev/null
  if [ $? != 0 ]; then
    return 1
  fi
  os=`arp-fingerprint $ipaddress`
  os=${os:25}
  return 0
}

file=$1
cat $file | while read line; do
  line=`echo $line | tr -d '\n'`
  getos $line
  if [ $? = 0 ]; then
    if [ "$os" != "" ]; then
      echo $line $os
    fi
  fi
done