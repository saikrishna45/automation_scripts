#!/bin/sh
#####
##  Author: Anand Kumar Varma Potturi
## 
## This script will automatically create a passwordless login from your local
## machine to all the hosts listed in a text file with the name hosts.
## It takes the remote user name as first positional parameter for the script.
## example: sh passlesslogin.sh user
## This would need sshpass to be installed on your machine. If you are using mac then use brew to take care of it. 
## This script is only for unix kernel based machines.
####
user=${1}
for ip in `cat hosts`
do
sshpass -p 'pass' ssh ${user}@${ip} "chmod 777 ~/.ssh/authorized_keys"
sshpass -p 'pass' ssh ${user}@${ip} "/bin/cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub 
sshpass -p 'pass' ssh ${user}@${ip} "chmod 600 ~/.ssh/authorized_keys"
done
