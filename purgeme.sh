#!/usr/bin/env bash
#files=$(git diff --name-status | grep -v ^D | cut -c3-)

# the below three steps will produce those git files that are new or modified, only.
# - get a list of git files that have been added, deleted, or modified.
# - only show those lines that do not begin with a 'D'.
# - cut or remove the first three characters of the line.
files=$(git diff --name-status | grep -v ^D | cut -c3-)

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
            echo "please make sure the function signature begins with 'void VERSION_'"
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
#          echo ""
#          echo "file to modify is $f"
           sed -i.bak 's/void VERSION_.*/void VERSION_bob_was_here(void) {}/g' $f
        fi
    fi
done
#echo ""
exit 0