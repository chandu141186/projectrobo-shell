#!/bin/bash

AMI=ami-0b4f379183e5706b9 
SG_ID=sg-04e8a790706df00aa
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web" )
ZONE_ID=Z06286322TWN251SZBYW9
DOMAIN_NAME=chandulearn.online

for i in "${INSTANCES[@]}"
do
  if [ $i == "mongdb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
  then 
     INSTANCE_TYPE="t3.small"
  else 
     INSTANCE_TYPE="t2.micro"
  fi
    IP_ADDRESS=$(aws ec2 run-instances --image-id  ami-0b4f379183e5706b9 --count 1 --instance-type $INSTANCE_TYPE --security-group-ids sg-04e8a790706df00aa --tag-specifications "ResourceType=instance,Tags=[{Key= Name,Value= $i}]" --query 'Instances[0].PrivateIpAddress' --output text)
      echo "$i: $IP_ADDRESS"
     
   aws route53 change-resource-record-sets \
   --hosted-zone-id $ZONE_ID \
   --change-batch '
  {
    "Comment": "Creating a record set for cognito endpoint"
    ,"Changes": [{
      "Action"              : "UPSERT"
      ,"ResourceRecordSet"  : {
        "Name"              : "'$i'.'$DOMAIN_NAME'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$IP_ADDRESS'"
        }]
      }
    }]
  }
    '
 done
