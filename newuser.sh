#!/bin/bash

username="$2"
password="$3"
creds="$username-creds.txt"

addUser()
{
if [ -z "$3" ]; then
	password=$(date +%s | sha256sum | base64 | head -c 12 ; echo)
fi

echo "Hello $username, Here are your credentials to log in" > "$creds"
echo "" >> "$creds"
echo "username: $username" >> "$creds" 
echo "password: $password" >> "$creds"



sudo useradd -m -s /bin/bash "$username"
echo "$username:$password" | sudo chpasswd

mail -A "$creds" -s "credentials for $username" kuzniarski.michal@gmail.com < /dev/null
rm "$creds"

sudo cp rules.txt /home/$username || exit 1
echo "user $username successfully added"
}

delUser()
{
sudo userdel -r $username
}

if [ "$1" == "add" ]; then
    addUser
elif [ "$1" == "remove" ]; then
    delUser	
else
    echo "You need to specify either [add] or [remove]"; exit 1
fi
