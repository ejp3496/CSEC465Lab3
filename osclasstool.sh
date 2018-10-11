#!/bin/bash

getos() {

	echo $1": "
	ttl=$(ping -c1 $1)

	for word in $ttl
	do
		if [[ $word == "ttl="* ]];then
			ttl=${word:4}
		fi
	done

	case $ttl in
		"64")
			echo "linux,red hat,MacOS X(10.5.6)";;
		"128")
			echo "windows 10,server 2008,7,vista,XP";;
		"255")	
			echo "OpenBSD,Solaris,Startus";;
	

	esac
	#echo $ttl
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

