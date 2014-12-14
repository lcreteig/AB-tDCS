Because of a bug fixed in commit *ed082f4*, the experiment crashed once for S05 and 4 times for S06.
After a crash, the task was restarted until enough whole blocks of data had been collected to together make up one whole experiment.
That's why in the raw folder, these participants have multiple output files, with an alphabetical suffix (e.g. S04**a**, S06**d**).

In this folder, data from these blocks has been combined into a single file, like for all the other participants that did not have any issues.
