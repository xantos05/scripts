# PHP FPM MONITORING SCRIPT FOR NEW RELIC

## Script:
fpm_to_newrelic.sh

## Description:
Monitoring script for New Relic that retrieves idle, active and total number of processes from the PHP status page and sends the data to the New Relic API.

## Installation:
- Make sure PHP is running and the URL http://127.0.0.1/fpm-status?json is accessable and returning valid data.
- Edit this file and enter values for the variables: API_KEY, NEW_RELIC_API_URL and HOST_NAME. The NEW_RELIC_API_URL can also be replaced by a NON-EU version like https://metric-api.newrelic.com/metric/v1
- Create a crontab that runs every minute like: * * * * * /opt/newrelic-scripts/fpm_to_newrelic.sh > /dev/null 2>&1
- Create a widget in New Relic to display your data. Example: FROM Metric SELECT latest(`php_fpm.active`), latest(`php_fpm.idle`), latest(`php_fpm.total`) WHERE (host='YOUR_HOSTNAME') TIMESERIES AUTO
