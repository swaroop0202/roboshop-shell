#! /bin/bash

instances=("mongodb" "redis" "mysql" "rabbitmq" "catalogue"  "users" "cart" "shipping" "payments" "web")

for name in ${instances[@]};do
 echo "creating instances:$name"

   if [ $name == "shipping" ]  || [ $name== "mysql" ] 
   then
        echo "instance shoul be t3.small"
   else
        echo "instance should be t3.micro"
   fi   
done