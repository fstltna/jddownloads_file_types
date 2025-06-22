# jddownloads_file_types (1.2.1)
Checks the file type icon for listings in the jdownloads file manager component

***

1. If you don't know what your table prefix is you can use the following commands to see what it is. The prefix MUST end with a "_".

        grep dbprefix /var/www/html/configuration.php

2. Run this script to install the dependencies:

	./installdeps

3. Run this script and the first time it will ask you to configure the tool.

	./scan_file_types.pl

	If you need to change the settings run:

	./scan_file_types.pl prefs

4. That should be enough, it should be workable now.

Be sure and make a backup before running this tool!

