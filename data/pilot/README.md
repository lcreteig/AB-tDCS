## Leon

File *Leon_20141201_AB_output* contains pilot data of the experimenter collected
on 04-12-2014. It was exactly the same task as the other participants. Compared
to the file in the raw folder, an empty column and 2nd row have been removed
(these may cause the analysis script to crash).

## Combining multiple files

Because of a bug fixed in commit *ed082f4*, the experiment crashed once for S05
and 4 times for S06. After a crash, the task was restarted until enough whole
blocks of data had been collected to together make up one whole experiment.
That's why in the raw folder, these participants have multiple output files,
with an alphabetical suffix (e.g. S04**a**, S06**d**).

In this folder, data from these blocks has been combined into a single file,
like for all the other participants that did not have any issues.
