# -*- coding: utf-8 -*-
# Forked from the `jupyter-notebook` entry_point.
import os
import re
import sys

from notebook.notebookapp import main

if __name__ == "__main__":
    # Move to the working dir if present
    cd_to = os.getenv("BUILD_WORKING_DIRECTORY")
    if cd_to is None:
        cd_to = os.getenv("BUILD_WORKSPACE_DIRECTORY")
    if cd_to is not None:
        os.chdir(cd_to)
    sys.argv[0] = re.sub(r"(-script\.pyw?|\.exe)?$", "", sys.argv[0])
    sys.exit(main())
