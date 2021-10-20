#!/usr/bin/env bash

# decrypts input 
# outputs decrypted lines
# could be better, but you get the idea.
#
# secrets can be encrypted with shush directly
# eg: `shush encrypt <keyname> <secret>`


while IFS= read -r line; do
    # find one encrypted value in the line
    encrypted=$(echo "$line" | xargs -n 1 | grep SHUSH_ | sed 's/SHUSH_//g' )
    
    if [ "$encrypted" ] ; then
        decrypted=$(echo $encrypted | shush decrypt)

        replaced=$(echo $line | sed "s|SHUSH_.*$|$decrypted|g" )

        echo $replaced
    else
        echo $line
    fi
done
