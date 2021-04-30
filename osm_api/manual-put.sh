#!/bin/sh
URL="https://master.apis.dev.openstreetmap.org/oauth/access_token"
PARAMS="oauth_consumer_key=jy5jNxcCPnmXBxl4rhC1L6bHFi3SOchfSF3jrdFo&oauth_nonce=hvxmcyptwt&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1619700344&oauth_token=VudW2X2aCFReKDXFx65QK8asqgIE1ugb6EHObo7&oauth_signature=LRkFlO4hJErR6fyOa2JU%2B386W%2B4%3D"
curl -X POST -d "$PARAMS" "$URL"
