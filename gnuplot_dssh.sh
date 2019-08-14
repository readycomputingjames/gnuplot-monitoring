#!/bin/bash

HOST_FILE=$1
INPUT_COMMAND=$2

DATE=`date +"%m/%d/%Y"`
TIME=`date +"%H:%M"`

DATFILE="/home/jhipp/gnuplot/sbox_mem.dat"
ARCHFILE="/home/jhipp/gnuplot/sbox_mem_$DATE.dat"

CPUFILE="/home/jhipp/gnuplot/sbox_cpu.dat"
CPUARCH="/home/jhipp/gnuplot/sbox_cpu_$DATE.dat"

gnuplot_dssh ()
{

   ### Roll over Dat File if it is a new Day
   if [ "$TIME" = "00:00" ]
   then
      /usr/bin/mv $DATFILE $ARCHFILE
      /usr/bin/head -n 1 $ARCHFILE > $DATFILE
      /usr/bin/mv $CPUFILE $CPUARCH
      /usr/bin/head -n 1 $CPUARCH > $CPUFILE
   fi

   echo -ne "$DATE $TIME " >> $DATFILE
   echo -ne "$DATE $TIME " >> $CPUFILE

   for HOST in `cat $HOST_FILE`
   do

   echo -ne "`/bin/ssh -i /home/jhipp/jhipp-ssh.pem -t -o ConnectTimeout=5 $HOST "/usr/bin/free -m |grep Mem" |awk '{print $3/$2 * 100.0}'` " >> $DATFILE

   echo -ne "`/bin/ssh -i /home/jhipp/jhipp-ssh.pem -t -o ConnectTimeout=5 $HOST "/usr/bin/top -bn1 |grep Cpu" |awk '{print $2}'` " >> $CPUFILE

   done

   echo "" >> $DATFILE
   echo "" >> $CPUFILE

}

gnuplot_dssh


