#!/usr/bin/with-contenv sh

#Network check
# Ping uses both exit codes 1 and 2. Exit code 2 cannot be used for docker health checks,
# therefore we use this script to catch error code 2
HOST=${HEALTH_CHECK_HOST}

if [[ -z "$HOST" ]]
then
    echo "Host  not set! Set env 'HEALTH_CHECK_HOST'. For now, using default google.com"
    HOST="google.com"
fi

# Check DNS resolution works
nslookup $HOST > /dev/null
STATUS=$?
if [[ ${STATUS} -ne 0 ]]
then
    echo "DNS resolution failed"
    exit 1
fi

ping -c 2 -w 10 $HOST # Get at least 2 responses and timeout after 10 seconds
#curl --fail http://ifconfig.io/
STATUS=$?
if [[ ${STATUS} -ne 0 ]]
then
    echo "Network is down"
    exit 1
fi

echo "Network is up"

echo "jdwonloader is running"
exit 0