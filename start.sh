#!/bin/bash -x

set -e

(
count=0;
# Execute list_users until service is up and running
until timeout 5 rabbitmqctl list_users >/dev/null 2>/dev/null || (( count++ >= 60 )); do sleep 1; done;
   if rabbitmqctl list_users | grep guest > /dev/null
   then
      # Delete default user and create new users
      rabbitmqctl delete_user guest
      # Specific commands for Application
      rabbitmqctl add_user $RABBITMQ_USER $RABBITMQ_PASSWORD 2>/dev/null ; \
      rabbitmqctl set_user_tags $RABBITMQ_USER administrator ; \
      rabbitmqctl set_permissions -p / $RABBITMQ_USER  ".*" ".*" ".*" ; \

      # add virtualhost and create new uesrs 
      rabbitmqctl add_vhost $RABBITMQ_MQTT_VHOST; \
      rabbitmqctl add_user $RABBITMQ_MQTT_USER $RABBITMQ_MQTT_PASSWORD; \
      rabbitmqctl set_user_tags $RABBITMQ_MQTT_USER management; \
      rabbitmqctl set_permissions -p $RABBITMQ_MQTT_VHOST $RABBITMQ_MQTT_USER ".*" ".*" ".*" ;  \

      echo "setup completed"
   else
      echo "already setup"
   fi
) &

# Call original entrypoint
exec docker-entrypoint.sh rabbitmq-server $@
