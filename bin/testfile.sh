#! /bin/bash
field=()
field+=("myhostexample1")
field+=("myhostexample2")
field+=("myhostexample3")
field+=("myhostexample4")

echo Num items: ${#field[@]}
echo Data: ${field[@]}
