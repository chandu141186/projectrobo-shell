#!/bin/bash

AMI=ami-0b4f379183e5706b9 
SG_ID=sg-04e8a790706df00aa
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catlouge" "user" "cart" "shipping" "payment" "dispatch" "web" )

for i in "${INSTANCES(@)}"
do
  echo "instance is:$i"
 if [ $i == "mongdb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
 then 
     INSTANCE_TYPE="t3.small"
 else 
     INSTANCE_TYPE="t2.micro"
 fi
aws ec2 run-instances --image-id  ami-0b4f379183e5706b9 --count 1 --instance-type $INSTANCE_TYPE --security-group-ids sg-04e8a790706df00aa
 done