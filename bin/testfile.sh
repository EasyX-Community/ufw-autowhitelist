#! /bin/bash
field=()
while read -r input ; do
    field+=("$input")
done
echo Num items: ${#field[@]}
echo Data: ${field[@]}
