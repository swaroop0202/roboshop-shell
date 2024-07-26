#! /bin/bash

instances=("mongodb" "redis" "mysql" "rabbitmq" "catalogue"  "users" "cart" "shipping" "payments" "web")

for name in {$instances[@]};do
 echo "creating instances:$name"
done