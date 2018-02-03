#!/usr/bin/env bash
#files=$(git diff --name-status | grep -v ^D | cut -c3-)

# the below three steps will produce those git files that are new or modified, only.
# - get a list of git files that have been added, deleted, or modified.
# - only show those lines that do not begin with a 'D'.
# - cut or remove the first three characters of the line.


files=$(git diff HEAD --name-status | grep -v ^D | cut -c3-)

for f in $files
do
    if ! grep -q "^(void VERSION_).*$" $f
    then
        echo $f | grep -qE '\.(c|cpp)$'
        if [ $? -eq 0 ]
        then
            echo ""
            echo "{void VERSION_} function not found in $f"
            echo "terminating check in..."
            echo "please make sure this function exists in your C source file: 'void VERSION_(){}'"
            echo ""
            exit 1
        fi
    fi
done

for f in $files
do
    if grep -q "^(void VERSION_).*$" $f
    then
        echo $f | grep -qE '\.(c|cpp)$'
        if [ $? -eq 0 ]
        then
            current_date_time="`date '+%d%h%Y_%H%M%S' | tr [:lower:] [:upper:]`";
            file=${f%.c}

            sed -i.bak "s/void VERSION_.*/void VERSION_$(echo "${file##*/}")_$(echo "$current_date_time")_$(echo "$RANDOM")(void) {}/g" $f
            git add $f
            rm $f.bak
        fi
    fi
done
exit 0
