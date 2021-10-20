# Binaries for terraform implementation

1. decrypt.sh

You'll need to install Shush [https://github.com/realestate-com-au/shush] to get this to work.

This decrypts values in a file, using shush, if the encrypted value is pre-pended with `SHUSH_`.

Example usage:
./decrypt.sh < backend.tfvars.shush > backend.tfvars 

This usage would decrypt the `.shush` file and write a decrypted `.tfvars` file.


