#!/usr/bin/env bash

# davedean, 2021
# decrypt.sh - uses shush to decrypt input and print to output
# useful for decrypting tfvar files for example.

# https://github.com/realestate-com-au/shush

# Usage ideas: 
# ./decrypt.sh < input_file 
# echo SHUSH_secret | ./decrypt.sh 

# Usage example:
# ../bin/decrypt.sh < backend.tfvars.shush > backend.tfvars
# ^ will read the .shush file, decrypt, and write a tfvars file
# ready for use by terraform.

# secrets can be encrypted with shush directly
# eg: `shush encrypt <keyname> <secret>`

# Output is quoted because thats what I need, ymmv.

while IFS= read -r line; do
    # find one encrypted value in the line
    encrypted=$(echo "$line" | xargs -n 1 | grep SHUSH_ | sed 's/SHUSH_//g' )
    
    # if we find a SHUSH_ value .. 
    if [ "$encrypted" ] ; then
        # decrypt it with shush
        decrypted=$(echo $encrypted | shush decrypt)

        # rebuild the line, but with SHUSH_ removed and the decrypted value quoted
        replaced=$(echo $line | sed "s|SHUSH_.*$|\"$decrypted\"|g" )

        # output the rebuilt line
        echo $replaced
    else
        # if we didn't find a SHUSH_ value, output the original line
        echo $line
    fi
done
