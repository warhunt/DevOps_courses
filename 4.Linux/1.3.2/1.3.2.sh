#!/bin/bash
read -p "Enter your email: " login

read -s -p "Enter your password: " passwd
echo

data="login=$login&passwd=$passwd"

`wget \
    -q \
    --html-extension \
    -O /dev/null \
    --post-data=$data \
    --save-cookies=cookies \
    --header="User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36" \
    "https://passport.yandex.by/auth?from=mail&origin=hostroot_homer_auth_by&retpath=https%3A%2F%2Fmail.yandex.by%2F&backpath=https%3A%2F%2Fmail.yandex.by%3Fnoretpath%3D1"`

is_logined=`grep "yandex_login" cookies | wc -l`

if [ $is_logined == 0 ]; then
    echo "Email or password is not correct!"
    exit 1
fi

html=`wget \
    -q \
    -O - \
    --html-extension \
    --load-cookies=cookies \
    --header="User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36" \
    "https://mail.yandex.by/lite/"`



n_message=`echo $html | grep -oP '<div class="b-messages__message(\sb-messages__message_unread|\sb-messages__message_last)*">' | wc -l`

echo "Number of emails in the Inbox folder: $n_message"
