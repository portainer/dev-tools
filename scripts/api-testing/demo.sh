#!/bin/sh

ADMIN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsInNjb3BlIjoiZGVmYXVsdCIsImZvcmNlQ2hhbmdlUGFzc3dvcmQiOmZhbHNlLCJleHAiOjE2OTk0ODM5MzUsImlhdCI6MTY5OTQ1NTEzNX0.FtCZw7C4V6QFKT7YQmwecFH9qbkSkJUxDrcFLZbNA_8"
EDGE_ADMIN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJlZGdlYWRtaW4iLCJyb2xlIjozLCJzY29wZSI6ImRlZmF1bHQiLCJmb3JjZUNoYW5nZVBhc3N3b3JkIjpmYWxzZSwiZXhwIjoxNjk5NDg0MTI4LCJpYXQiOjE2OTk0NTUzMjh9.0oSIjluO18bqchH094xaXhmzY89xeGwhTjm56Jc7W4Y"
STANDARD="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcm5hbWUiOiJib2IiLCJyb2xlIjoyLCJzY29wZSI6ImRlZmF1bHQiLCJmb3JjZUNoYW5nZVBhc3N3b3JkIjpmYWxzZSwiZXhwIjoxNjk5NDgzOTc4LCJpYXQiOjE2OTk0NTUxNzh9.6nWkQMu3FoQxJhrO_hLh3oYDk1bLfVILaZrDskBm_1Y"

BASE_URL="localhost:9000"
# URL="/api/registries"
URL="/api/endpoints/2/registries"

ccurl() {
  token="$1"
  curl -H "Authorization: Bearer ${token}" "${BASE_URL}${URL}"
}

ccurl "${ADMIN}"
ccurl "${EDGE_ADMIN}"
ccurl "${STANDARD}"