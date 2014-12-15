## .xls files

These three xls files contain data of pre-pilots run on the experimenters:
* *BlankPilot_LeonHeleen* examines the attentional blink under conditions of no blanks between the letters in the stream vs. a 60 ms blank.
* *T1LumPilot_Leon* examines the attentional blink under different intensities of T1 RGB values ([255 0 0] vs. [210 40 40] vs. [170 80 80]).
* *T1posPilot_Leon* examines the attentional blink under a fixed T1 position (nr. 5 in the stream) vs. a variable position (5-8).

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
