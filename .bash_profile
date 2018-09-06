#! /bin/bash

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

echo "hi from the proflie"

# Load .bashrc and other files...
for file in ~/.{bashrc,aliases,exports,path}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		source "$file"
	fi
done
unset file
