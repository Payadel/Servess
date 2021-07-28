#Libs
if [ ! -f /opt/shell-libs/colors.sh ]; then
    echo "Can't find libs." >&2
    echo "Operation failed." >&2
    exit 1
fi
. /opt/shell-libs/colors.sh

username="$1"
allow_ssh="$2"

if [ -z "$allow_ssh" ]; then
    printf "Allow $username to access ssh? (y/n): "
    read allow_ssh
fi

allowUsers=$(servess sshd ssh-access --list-allow-users | gawk -F ': ' '{ print $2 }')
denyUsers=$(servess sshd ssh-access --list-deny-users | gawk -F ': ' '{ print $2 }')
if [ "$allow_ssh" = "y" ] || [ "$allow_ssh" = "Y" ]; then
    if [ ! -z "$allowUsers" ]; then
        echo_info "Adding user to allow ssh access list..."
        servess sshd ssh-access --add-allow-user "$username" --list-allow-users
    fi
else
    if [ ! -z "$denyUsers" ] || [ -z "$allowUsers" ]; then
        echo_info "Adding user to deny ssh list..."
        servess sshd ssh-access --add-deny-user "$username" --list-deny-users
    fi
fi