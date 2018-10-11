#!/bin/bash

prefix_to_bit_netmask() {
  prefix=$1
  shift=$(( 32 - prefix ))
  bitmask=""
  for (( i=0; i < 32; i++ )); do
    num=0
    if [ $i -lt $prefix ]; then
      num=1
    fi
    space=
    if [ $(( i % 8 )) -eq 0 ]; then
      space=" ";
    fi
    bitmask="${bitmask}${space}${num}"
  done
  echo $bitmask
}

bit_netmask_to_wildcard_netmask() {
  bitmask=$1;
  wildcard_mask=
  for octet in $bitmask; do
    wildcard_mask="${wildcard_mask} $(( 255 - 2#$octet ))"
  done
  echo $wildcard_mask;
}

cidr_to_ips() {
  ip=$1
  net=$(echo $ip | cut -d '/' -f 1);
  prefix=$(echo $ip | cut -d '/' -f 2);
  bit_netmask=$(prefix_to_bit_netmask $prefix);
  wildcard_mask=$(bit_netmask_to_wildcard_netmask "$bit_netmask");
  str=
  for (( i = 1; i <= 4; i++ )); do
    range=$(echo $net | cut -d '.' -f $i)
    mask_octet=$(echo $wildcard_mask | cut -d ' ' -f $i)
    if [ $mask_octet -gt 0 ]; then
      range="{$range..$(( $range | $mask_octet ))}";
    fi
    str="${str} $range"
  done
  ips=$(echo $str | sed "s, ,\\.,g"); ## replace spaces with periods, a join...
  eval echo $ips | tr ' ' '\n'
}

range_to_ips() {
  ip=$1
  lo=$(echo $ip | cut -d '-' -f 1);
  hi=$(echo $ip | cut -d '-' -f 2);
  a=$(echo $ip | cut -d '.' -f 1);
  b=$(echo $ip | cut -d '.' -f 2);
  c=$(echo $ip | cut -d '.' -f 3);
  lod=$(echo $lo | cut -d '.' -f 4);
  hid=$(echo $hi | cut -d '.' -f 4);
  seq -f "$a.$b.$c.%g" $lod $hid
}

getIPs() {
  pattern=$1
  if [[ $pattern = *-* ]]; then           # range
    range_to_ips $pattern
  elif [[ $pattern = */* ]]; then       # CIDR
    cidr_to_ips $pattern
  else
    echo $pattern                    # single IP
  fi
}

getportnum() {
  ports=$1
  if [[ $ports = *,* ]]; then
    ports=`echo $ports | tr ',' ' '`
  fi
  echo $ports
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

ip_list=$(getIPs $addresses)
port=$(getportnum $portrange)

for ip in $ip_list; do
  nc -zv $ip $port
done
