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
#           cat "$f" | wc -c
#           wc -c "$f" | awk '{print $1}'
#           printf main.c | git hash-object --stdin

#            $(git hash-object $f)

            current_date_time="`date +%Y%m%d%H%M%S`";


            y=${f%.c}
#            echo ${y##*/}

#           sed -i.bak "s/void VERSION_.*/void VERSION_$(git hash-object "$f")(void) {}/g" $f
           sed -i.bak "s/void VERSION_.*/void VERSION_$(echo "${y##*/}")_$(echo "$current_date_time")_$(echo "$RANDOM")(void) {}/g" $f

#           echo $(git hash-object $f)

#           cat "$f" | wc -c
#           stat -f%z "$f"
#           printf "$f" | git hash-object --stdin
#           printf "blob $(cat "$f" | wc -c)\0$f" | shasum
#           (printf "commit %s\0" $(git cat-file commit HEAD | wc -c); git cat-file commit HEAD) | shasum
#           printf "blob 1022\0$f" | shasum
        fi
    fi
done
#echo ""
exit 0