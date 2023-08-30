#!/bin/bash

#######
# https://github.com/livebook-dev/livebook#environment-variables
# When running Livebook Desktop, Livebook will invoke on boot a file
# named ~/.livebookdesktop.sh on macOS or %USERPROFILE%\.livebookdesktop.bat on Windows.
# This file can set environment variables used by Livebook, such as:
#
# the PATH environment variable
#
#   set LIVEBOOK_DISTRIBUTION=name to enable notebooks to
#   communicate with nodes in other machines
#
#   or to configure the Erlang VM, for instance, by setting
#   ERL_AFLAGS="-proto_dist inet6_tcp" if you need Livebook to run over IPv6
#######

export LIVEBOOK_HOME=~/code/notebooks
