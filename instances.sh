#! /bin/bash

instances=("mongodb" "redis" "mysql" "rabbitmq" "catalogue"  "users" "cart" "shipping" "payments" "web")

for name in ${instances[@]};do
 echo "creating instances:$name"

   if [ $name == "shipping" ]  || [ $name == "mysql" ] 
   then
        instance_type = "t3.medium"
   else
        instance_type = "t3.micro"
   fi  
  echo "creating instance for $name : instance type is $instance_type" 
   instance_id=$(aws ec2 run-instances --image-id ami-041e2ea9402c46c32 --instance-type $instance_type  --security-group-ids sg-0cb50d0db2f7c8084 --subnet-id subnet-0d28f9a915b78dd57 --query 'Instances[*].InstanceId' --output text)

   echo "printing public and private ips"
   aws ec2 run-instances --image-id ami-041e2ea9402c46c32 --instance-type $instance_type  --security-group-ids sg-0cb50d0db2f7c8084 --subnet-id subnet-0d28f9a915b78dd57 --query 'Instances[*].[PrivateIpAddress, PublicIpAddress]' \
   --output text

   aws ec2 create-tags --resources $instance_id --tags Key=project,Value=$name 
done
