#!/bin/bash
echo "Content-type: text/html"
echo ""

if [ "$REQUEST_METHOD" == 'GET' ]; then
    echo "Get method worked"
    DATE="$(date)"
    UPTIME="$(uptime -p)"
    OS_NAME="$(uname)"
    USER_NAME="$(whoami)"
    USER_INFO="$(id)"
    HOST_NAME="$(hostname -I)"
    cat <<EOT
        <!DOCTYPE html>
        <html>
        <head>
                <title>Index, KP-93, Baklan</title>
        </head>
        <body>
                Today is $DATE <br>
                Uptime: $UPTIME <br>
                Operational system: $OS_NAME <br>
                Information about user: Name: $USER_NAME; Groups: $USER_INFO <br>
                Information about host: $HOST_NAME <br>
                Your browser is: $HTTP_USER_AGENT



                <p>Hello! Please enter BASH command</p>
                <form action="index.sh" method="get">
                        <label>Enter something here</label>
                        <input type="text" name="name">
                        <br>
                        <button type="submit" formmethod="post">Submit</button>
                </form>
        </body>
        </html>
EOT
fi
if [ "$REQUEST_METHOD" == 'POST' ]; then
    read POST_STRING

    saveIFS="$IFS"
    IFS='=&'
    parm=($POST_STRING)
    IFS=$saveIFS

    REQUESTED_COMMAND="${parm[1]}"

    RESULT="$(eval $REQUESTED_COMMAND)"
    DATE="$(date)"
    UPTIME="$(uptime -p)"
    OS_NAME="$(uname)"
    USER_NAME="$(whoami)"
    USER_INFO="$(id)"
    HOST_NAME="$(hostname -I)"
   cat <<EOT
        <!DOCTYPE html>
        <html>
        <head>
                <title>Index, KP-93, Baklan</title>
        </head>
        <body>
                Your request: $REQUESTED_COMMAND <br>
                Result of your request: $RESULT <br>
                Today is $DATE <br>
                Uptime: $UPTIME <br>
                Operational system: $OS_NAME <br>
                Information about user: Name: $USER_NAME; Groups: $USER_INFO <br>
                Information about host: $HOST_NAME <br>
                Your browser is: $HTTP_USER_AGENT



                <p>Hello! Please enter BASH command</p>
                <form action="index.sh" method="post">
                        <label>Enter something here</label>
                        <input type="text" name="command_name">
                        <br>
                        <button type="submit" formmethod="post">Submit</button>
                </form>
        </body>
        </html>
EOT
fi

