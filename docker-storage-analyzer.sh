#!/bin/bash


for container in $(sudo docker ps | tail -n +2 | cut -d " " -f 1)
do
  containername=$(sudo docker inspect $container | grep "Name" | head -n 1 | cut -d ":" -f 2  | sed 's/,/ /g' | sed 's/"//g')
  pre=$(cut -d "_" -f 1 <<< $containername)
  #echo $prefix
  workload=$(cut -d "_" -f 2 <<< $containername)
  #echo $workload
  name=$(cut -d "_" -f 3 <<< $containername)
  #echo $name
  namespace=$(cut -d "_" -f 4 <<< $containername)
  #echo $namespace
  suffix=$(cut -d "_" -f 5 <<< $containername)
  #echo $suffix
  #echo "---$containername --"
  #echo "$prefix,$workload,$namespace,$name,$suffix"
  upper=$(sudo docker inspect $container | grep "UpperDir" | cut -d ":" -f 2  | sed 's/,/ /g' | sed 's/"//g' | sed 's/ //g')
  #echo "upper path$upper"
  #containername=$(sudo docker inspect $container | grep "Name" | cut -d ":" -f 2  | sed 's/,/ /g' | sed 's/"//g')
  #echo "upper path$upper"
  #echo "Sizes"
  sizeX=$(sudo du -sh $upper)
  size=$(cut -d " " -f 1 <<< $sizeX)
  #echo "$prefix,$workload,$namespace,$name,$suffix,$size"
  #echo "Folders/Files"
  dir_contents=$(sudo ls -R "$upper")

  prefix=$(sed 's/\//#/g' <<< $upper )
  filenames=""
  #echo $prefix
  for line in $dir_contents
  do
	  strlength=${#upper}
	  #awk '{print substr($1,strlength)}' <<< $line
	  mline=$(sed 's/\//#/g' <<< $line | sed 's/"$prefix"//g')
	  m2line=$(sed "s/$prefix//g" <<< $mline | sed 's/#/\//g')
	  #echo $m2line
	  filenames="$filenames,$m2line"
  done

  echo "$pre,$workload,$namespace,$name,$suffix,$size,$filenames"
  #echo $filenames
  #list_directory_contents $upper
  #dir_contents=$?
  #echo $dir_contents
done
