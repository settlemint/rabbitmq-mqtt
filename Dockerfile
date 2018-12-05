FROM rabbitmq:3-management-alpine

COPY enabled_plugins /etc/rabbitmq/enabled_plugins
COPY start.sh start.sh

EXPOSE 1883

ENTRYPOINT [ "./start.sh" ]