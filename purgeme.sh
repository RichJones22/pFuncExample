#!/usr/bin/env bash
# the below three steps will produce those git files that are new or modified, only.
# - get a list of git files that have been added, deleted, or modified with respect to the HEAD
# - only show those lines that do not begin with a 'D'.
# - cut or remove the first three characters of the line.
files=$(git diff HEAD --name-status | grep -v ^D | cut -c3-)

# check for version string in each file
for f in $files
do
    if ! grep -q "^(void VERSION_).*$" $f
    then
        echo $f | grep -qE '\.(c|cpp)$'
        if [ $? -eq 0 ]
        then
            echo ""
            echo "{void VERSION_(){}} function not found in $f"
            echo "terminating check in..."
            echo "please make sure this function exists in your C source file: 'void VERSION_(){}'"
            echo ""
            exit 1  # will cause 'git commit' to fail.
        fi
    fi
done

# if version string found, replace it with new version string
for f in $files
do
    if grep -q "^(void VERSION_).*$" $f
    then
        echo $f | grep -qE '\.(c|cpp)$'
        if [ $? -eq 0 ]
        then
            # derive date time string as '03FEB2018_111631' format
            current_date_time="`date '+%d%h%Y_%H%M%S' | tr [:lower:] [:upper:]`";

            # derive file name with .c extension removed.
            file=${f%.c}

            # rewrite version string as 'void VERSION_main_03FEB2018_111631_5603(void) {}' format
            sed -i.bak "s/void VERSION_.*/void VERSION_$(echo "${file##*/}")_$(echo "$current_date_time")_$(echo "$RANDOM")(void) {}/g" $f

            # since we just updated the file with the previous sed command, we need to 'git add' it again.
            git add $f

            # remove temporary .bak file
            rm $f.bak
        fi
    fi
done
exit 0 # all files are successfully committed with 'git commit'
