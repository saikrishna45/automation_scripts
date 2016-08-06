#!/bin/sh

#### Use your stash url for the 
url=localhost:7990

if [ "${year_num}" == "" ] ; then
year=`date +%y`
else
year=${year_num}
fi 

if [ "${month_num}" == "" ] ; then
month=`date +%m`
else
month=${month_num}
fi 



STASH_API="curl -u ${user_1}:${password_2} ${url}/rest/api/1.0/projects/"
${STASH_API} | python -mjson.tool > log.txt
PROJ_COUNT=`grep -c key log.txt`
#File which has all the details of the STASH stats
touch stats.txt
echo "Name of the repository and details" > time_stamp.txt
echo "Total count of Projects = ${PROJ_COUNT}" > stats.txt
PROJ_NAME=`cat log.txt | grep -i key | awk '{print $2}' | cut -f2 | sed "s/\"//g" | sed "s/\,//g"`
echo "Project KEYS in stash are: "
for i in ${PROJ_NAME[@]}; do echo $i >> stats.txt; done
echo "\n"
#Now going in for each project in detail
REPO_COUNT=0
for i in ${PROJ_NAME[@]};
do
REPO_API="curl -u ${user_1}:${password_2} ${url}/rest/api/1.0/projects/$i/repos/"
${REPO_API} | python -mjson.tool > ${i}.txt
REPO_NAME=`cat ${i}.txt | grep -i slug | awk '{print $2}' | cut -f2 | sed "s/\"//g" | sed "s/\,//g"`

#EACH PROJECT DETAILS WITH REPOSITORY NAMES AND TOTAL COUNT
for j in ${REPO_NAME[@]};
do 
REPO_DETAILS="curl -u ${user_1}:${password_2} ${url}/rest/audit/1.0/projects/${i}/repos/${j}/events"
${REPO_DETAILS} | python -mjson.tool > ${j}.txt
REPO_CREATION_TIME=`cat ${j}.txt | grep -i timestamp | awk '{print $2}' | cut -f2 | sed "s/\"//g" | sed "s/\,//g"`

k=0;
for n in ${REPO_CREATION_TIME}
do
   array[$k]=$n;
    k=$(($k+1));
done
array_count=${k}-1

final_element=${array[${array_count}]}
#COnverting epoch to milliseconds so unix can convert it to date
REPO_TIMESTAMP=$((${final_element}/1000))
echo $REPO_TIMESTAMP


#echo ${REPO_CREATION_TIME}
#####date -r 526276800 +%y%m  date -r 526276800 +%y%m
REPO_DATE=`date -d @${REPO_TIMESTAMP} +%y/%m`
echo "${REPO_DATE} -------> ${j}" >> time_stamp.txt


####
#echo $j >> ${j}.txt;

REPO_COUNT=`expr ${REPO_COUNT} + 1`;
 done

#echo ${REPO_NAME} >> stats.txt
#REPO_COUNT=`expr ${REPO_COUNT} + 1`
echo -en "\n"
done
echo -en "\n"
echo "Total number of repositories in all projects are: ${REPO_COUNT}" >> stats.txt
echo "Entering the year and month for the details:"
echo "${year} and ${month}"
REPO_MONTH_COUNT=`cat time_stamp.txt | grep -i ${year} | grep -c ${month}`
REPO_CREATED_IN_THAT_MONTH=`cat time_stamp.txt | grep -i ${year} | grep -i ${month}`
sleep 2
echo "Total repositories created in ${month} month of ${year} year are ${REPO_MONTH_COUNT}" >> stats.txt
echo -en "\n"
echo "Name of Repositories created in the above mentioned time frame are " >> stats.txt
echo -en "\n"
echo "${REPO_CREATED_IN_THAT_MONTH}" >> stats.txt
#######cleaning the unneeded files
rm log.txt time_stamp.txt
echo "Your stats will be displayed in a couple of secs..."
sleep 3
cat stats.txt
