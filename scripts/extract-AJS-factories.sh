#! /bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: extract-APIS.sh /path/to/your/app/directory"
  exit 1
fi

dir="$1"
cd $dir

# Initialize an empty array
factories=()
declare -A factories_references

for file in $(find $dir -type f -name "*.js"); do
  content=$(cat $file)
  factory=$(echo "$content" | grep ".factory(" | awk -F factory '{print $2}' | awk -F "'" '{print $2}')
  if [ -z "$factory" ]; then
    continue
  fi
  factories+=("$factory")
done

for file in $(find $dir -type f -name "*.js"); do
  content=$(cat $file)
  for factory in "${factories[@]}";do
    refs=$(echo "$content" | grep $factory)
    echo $refs
  done

done

# for key in "${!something[@]}"; do
#     # Access the value associated with the current key
#     value="${something[$key]}"
#     echo "Key: $key, Value: $value"
# done