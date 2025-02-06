#!/bin/bash

API_KEY="ptr_nmh6yIE7Egpr6XiID4/ASVDlqmo0l4ihljHhlB8erJw="
URL="localhost:9000"
# define offset (-5 mins) or (-1 hour)
RANGE='-5 mins'

START_TIMESTAMP=$(date --utc "+%s" -d "${RANGE}") # in seconds ! not nano or milli !

curl -H "X-API-KEY: ${API_KEY}" "${URL}/api/useractivity/authlogs?sortBy=Timestamp&sortDesc=true&after=${START_TIMESTAMP}"

# This equals to making a GET request with X-API-KEY header

# The request will return a JSON similar to

# {
#   "logs": [
#     {
#       "id": 3,
#       "timestamp": 1700828768,
#       "username": "admin",
#       "type": 1,
#       "origin": "172.17.0.1",
#       "context": 1
#     },
#     {
#       "id": 2,
#       "timestamp": 1700828749,
#       "username": "admin",
#       "type": 3,
#       "origin": "172.17.0.1",
#       "context": 1
#     }
#   ],
#   "totalCount": 2
# }

# type values
# 1 = Success
# 2 = Failure
# 3 = Logout

# context values
# 1 = Internal // represents the internal authentication method (authentication against Portainer API)
# 2 = LDAP // represents the LDAP authentication method (authentication against a LDAP server)
# 3 = OAuth // represents the OAuth authentication method (authentication against a authorization server)