#! /bin/bash

instances=("mongodb" "redis" "mysql" "rabbitmq" "catalogue"  "users" "cart" "shipping" "payments" "web")

for name in ${instances[@]};do
 echo "creating instances:$name"

   if [ $name == "shipping" ]  || [ $name == "mysql" ] 
   then
        echo "instance shoul be t3.small"
   else
        echo "instance should be t3.micro"
   fi   
done

aws ec2 run-instances --image-id ami-041e2ea9402c46c32 --count 1 --instance-type t2.micro  --security-group-ids sg-0cb50d0db2f7c8084 --subnet-id subnet-0d28f9a915b78dd57