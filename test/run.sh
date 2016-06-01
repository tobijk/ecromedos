#!/bin/sh

FAILED_MODULES=0

for subdir in ut
do
    echo "Running tests in '$subdir' directory:"

    (cd "$subdir" && python3 -m unittest)

    if [ "$?" -eq "1" ]
    then
        FAILED_MODULES=$(($FAILED_MODULES+1))
    fi
done

exit $FAILED_MODULES
