#!/bin/bash
echo "Registering Trino to Gateway"
curl -X POST http://$gatewayService:$gatewayPort/entity?entityType=GATEWAY_BACKEND \
-d "{  \"name\": \"$proxyName\", \"proxyTo\": \"$proxyTo\", \"active\": true, \"routingGroup\": \"adhoc\" }"

exec $@