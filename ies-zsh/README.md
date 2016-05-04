# ZSH Helper Cookbook

ZSH does not provide an equivalent to `/etc/profiles.d/` - e.g. a directory where files can be placed to be sourced upon
bootstrap of the shell. This cookbook tries to compensate for that fact by making zsh source /etc/profile - effectively
unifying the bootstrap process of both shells, mostly.
