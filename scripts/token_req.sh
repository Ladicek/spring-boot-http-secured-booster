#!/usr/bin/env bash

SSO_HOST=${1:-https://secure-sso-sso.e8ca.engint.openshiftapps.com}
APP=${2:-http://secured-springboot-rest-sso.e8ca.engint.openshiftapps.com}

REALM=master
USER=admin
PASSWORD=admin
CLIENT_ID=demoapp
SECRET=cb7a8528-ad53-4b2e-afb8-72e9795c27c8

#echo ">>> HTTP Token query"
#echo "curl -sk -X POST $SSO_HOST/auth/realms/$REALM/protocol/openid-connect/token -d grant_type=password -d username=$USER -d client_secret=$SECRET -d password=$PASSWORD -d client_id=$CLIENT_ID"

auth_result=$(curl -sk -X POST $SSO_HOST/auth/realms/$REALM/protocol/openid-connect/token -d grant_type=password -d username=$USER -d client_secret=$SECRET -d password=$PASSWORD -d client_id=$CLIENT_ID)
access_token=$(echo -e "$auth_result" | awk -F"," '{print $1}' | awk -F":" '{print $2}' | sed s/\"//g | tr -d ' ')

#echo ">>> TOKEN Received"
#echo $access_token

echo ">>> Greeting"
# echo "curl -k $APP/greeting -H \"Authorization:Bearer $access_token\""
curl -k $APP/greeting -H "Authorization:Bearer $access_token"

echo ">>> Greeting Customized Message"
curl -k $APP/greeting?name=Spring -H "Authorization:Bearer $access_token"