#!/bin/bash
echo "Content-type: text/html"
echo ""

if [ "$REQUEST_METHOD" == 'GET' ]; then
    cat <<  EOT
        <!DOCTYPE html>
        <html>

        <head>
                <title>File, KP-93, Baklan</title>
                <script async>
                function setContext(context) {
                    console.log("Hello World")
                    let context_element = document.getElementById("context")
                    context_element.value = context
                    this.form.submit()
                }

                </script>
        </head>
        <body>
                <form name="form" action="files.sh" method="post">
                        <label>Enter name of the file</label> <br>
                        <input type="text" name="filename"> <br>
                        <button type="button"  value="Load" onclick="setContext('LOAD')" formmethod="post">Load</button> <br>
                        <label>Edit file here</label> <br>
                        <input type="text" name="change_file"> <br>
                        <button type="button"  value="Save" onclick="setContext('SAVE')" formmethod="post">Save</button>
                        <input id="context" type="hidden" name="context"/>
                </form>
        </body>
        </html>
EOT
fi
if [ "$REQUEST_METHOD" == 'POST' ]; then
    read POST_STRING
    # read -r -a array <<< $POST_STRING

    saveIFS="$IFS"
    IFS='=&'
    parm=($POST_STRING)
    IFS=$saveIFS

    declare -A array
    for ((i=0; i<${#parm[@]}; i+=2))
    do
        array[${parm[i]}]=${parm[i+1]}
    done

    if [ "${array[context]}" == 'LOAD' ]; then
        FILE_CONTENTS=$(cat ./current_files/${array[filename]})
        if [ "${PIPESTATUS[0]}" != "0" ]; then
            FILE_CONTENTS="Error while reading file. Check spelling of the file"
        fi
        cat <<EOT
            <!DOCTYPE html>
            <html>
            <head>
                    <title>Files, KP-93, Baklan</title>

                    <script async>
                    function setContext(context) {
                        console.log("Hello World")
                        let context_element = document.getElementById("context")
                        context_element.value = context
                        this.form.submit()
                    }
                    </script>
            </head>
            <body>
                    Context: ${array[context]} <br>
                    Filename: ${array[filename]} <br>
                    Change File: ${array[change_file]} <br>
                    <form name="form" action="files.sh" method="post">
                            <label>Enter name of the file</label> <br>
                            <input type="text" name="filename"> <br>
                            <button type="button"  value="Load" onclick="setContext('LOAD')" formmethod="post">Load</button> <br>
                            <label>Edit file here</label> <br>
                            <input type="text" name="change_file" value="$FILE_CONTENTS"> <br>
                            <button type="button"  value="Save" onclick="setContext('SAVE')" formmethod="post">Save</button>
                            <input id="context" type="hidden" name="context"/>
                    </form>
            </body>
                
            </body>
            </html>
EOT
        
    fi
if [ "${array[context]}" == 'SAVE' ]; then
   cp "./current_files/${array[filename]}" "./saved_files/${array[filename]}"
   echo "${array[change_file]}" > "./current_files/${array[filename]}"
   cat <<EOT
        <!DOCTYPE html>
        <html>
        <head>
                <title>Files, KP-93, Baklan</title>

                <script async>
                function setContext(context) {
                    console.log("Hello World")
                    let context_element = document.getElementById("context")
                    context_element.value = context
                    this.form.submit()
                }
                </script>
        </head>
        <body>

                Context: ${array[context]} <br>
                Filename: ${array[filename]} <br>
                Change File: ${array[change_file]} <br>
                <form name="form" action="files.sh" method="post">
                        <label>Enter name of the file</label> <br>
                        <input type="text" name="filename"> <br>
                        <button type="button"  value="Load" onclick="setContext('LOAD')" formmethod="post">Load</button> <br>
                        <label>Edit file here</label> <br>
                        <input type="text" name="change_file" value=${array[change_file]} > <br>
                        <button type="button"  value="Save" onclick="setContext('SAVE')" formmethod="post">Save</button>
                        <input id="context" type="hidden" name="context"/>
                </form>
        </body>
               
        </body>
        </html>
EOT
    fi
fi



