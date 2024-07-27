#! /bin/bash

instances=("mongodb" "redis" "mysql" "rabbitmq" "catalogue"  "users" "cart" "shipping" "payments" "web")
domain_name=masterdevops.store
for name in ${instances[@]};do
 echo "creating instances:$name"

   if [ $name == "shipping" ]  || [ $name == "mysql" ] 
   then
        instance_type="t2.medium"
   else
        instance_type="t2.micro"    
   fi  
   echo "creating instance for $name : instance type is $instance_type " 
   instance_id=$(aws ec2 run-instances --image-id ami-041e2ea9402c46c32 --instance-type $instance_type  --security-group-ids sg-0cb50d0db2f7c8084 --subnet-id subnet-0d28f9a915b78dd57 --query 'Instances[0].InstanceId' --output text)

   aws ec2 create-tags --resources $instance_id --tags Key=project,Value=$name 

   if [ $name == web ]
   then  
          aws ec2 wait instance-running --instance-ids $instance_id
          public_ip=$(aws ec2 describe-instances \
          --filters \
          "Name=instance-id,Values=$instance_id" \
          --query 'Reservations[0].Instances[0].[PublicIpAddress]' \
          --output text)
          ip_to_use=$public_ip
     else
          private_ip=$(aws ec2 describe-instances --filters "Name=instance-id,Values=$instance_id" --query 'Reservations[0].Instances[0].[PrivateIpAddress]' --output text)
          ip_to_use=$private_ip
     fi     

   zoneid=Z02403941EG93JKQ2ZLKQ
   recordname=$name

  aws route53 change-resource-record-sets \
  --hosted-zone-id $zoneid \
  --change-batch '
           {
    "Comment": "Creating a record set for cognito endpoint"
    ,"Changes": [{
      "Action"              : "UPSERT"
      ,"ResourceRecordSet"  : {
        "Name"              : "'$name'.'$domain_name'"
        ,"Type"             : "CNAME"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$ip_to_use'"
        }]
      }
    }]
  }'
done