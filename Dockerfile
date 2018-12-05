FROM rabbitmq:3-management-alpine

COPY enabled_plugins /etc/rabbitmq/enabled_plugins

EXPOSE 1883

ENTRYPOINT [ "./start.sh" ]