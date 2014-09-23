#######################################################################################################
#																																		#																												#
#  Attentional blink task
#																									 																									#
#	 Based on:
#  Slagter, H.A. & Georgopoulou, K. (2013).
#	 Distractor inhibition predicts individual differences in recovery from the attentional blink.
#  PloS One, 8(5), e64681. doi:10.1371/journal.pone.0064681																				#                              																			#
#                                 																							#
#######################################################################################################

#######################################################################################################
#	Header																								 							#
#######################################################################################################

response_matching = simple_matching; # use newest Presentation features for associating responses with stimuli
active_buttons = 21;
button_codes = 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21;
event_code_delimiter = "\t";
write_codes = true; # write event codes to parallel port
response_logging = log_all;
response_port_output=false; # don't write response events to parallel port
pulse_width = 10; #standard short pulse width is 10

default_font_size = 40;
default_text_align = align_center;
default_background_color = 50,50,50;
default_font = "courier new";
default_text_color = 128,128,128;

###################################################################################
#  SDL																									 #
###################################################################################

begin;

# Stimulus durations
array{
$fixTime = 480; #fixation period before start of stream
$stimTime = 87; #duration of one stimulus in the stream. LCR: should be 91.66 ms, not sure why it's set to 87.
$totalTime = 87; #inter-stimulus interval (onset relative to preceding stimulus in the stream). LCR: as each should be presented for 91.66 ms ($stimTime) with no frames in between ($totalTime), not sure why there's 2 variables.
} eventTimes;

# Fixation cross
picture{text { caption = "+"; font = "courier new"; font_size = 22;};x=0;y=0;}fixPic;

# Response prompts
picture {
	text { caption = "Which letter was red?"; font_size = 22;};
	x = 0;
	y = 0;
} question1;

picture {
	text { caption = "Which letter was green?"; font_size = 22;};
	x = 0;
	y = 0;
} question2;

# Participant instructions

trial {
  trial_duration = forever;
  trial_type = first_response;
  stimulus_event{
  picture { text { caption = "You will now perform a task in which you will see
a fast stream of letters on the screen.

Most letters will be grey, but one letter will be red
and another one will be green.

Your task is to detect the red and green letter.
At the end of each stream you will be asked
to input these two letters using the keyboard.



  Press Enter to continue."; font_size = 22;};
	x = 0; y = 0;};
	code = "99";
   }instr1;
 } instruction1;


 trial {
  trial_duration = forever;
  trial_type = first_response;
  stimulus_event{
  picture { text { caption = "The stream of letters is quite fast, so it may be
difficult to detect both the red and the green letter.
In case you missed one or both letters, try and guess anyway.

The letters I, L, O, Q, U and V are never included in the stream;
choosing these letters is therefore not an option.



  Press Enter to continue."; font_size = 22;};
	x = 0; y = 0;};
	code = "99";
   }instr2;
 } instruction2;



 trial {
  trial_duration = forever;
  trial_type = first_response;
  stimulus_event{
  picture { text { caption = "You will now have the opportunity to first practice the task.
  Please pay attention, as the stream of letters is fast!



  Press Enter to start the practice!"; font_size = 22;};
	x = 0; y = 0;};
	code = "99";
   }instr3;
 } instruction3;




 trial {
  trial_duration = 15995; Not sure why this is set to this particular number (15 seconds and 995 ms)
  picture { text { caption = "Well done!
  You are now ready to perform the actual experiment.
  Please wait for the experimenter to start the task.

  Remember that you cannot choose the I, L, O, Q, U or V.
	In case you type in a letter and nothing happens,
	please check whether it might have been one of these letters.

If you have any questions about the task, please ask the experimenter now.

Good luck!"; font_size = 22;};
  x = 0; y = 0;};
  code = "99";
} practEnd;


###############################################################

### letters: I, L, O, Q, U and V are not included.
array {
text { caption = "A"; font = "courier new";}D; #name this one, to specify location below
text { caption = "B"; font = "courier new";};
text { caption = "C"; font = "courier new";};
text { caption = "D"; font = "courier new";};
text { caption = "E"; font = "courier new";};
text { caption = "F"; font = "courier new";};
text { caption = "G"; font = "courier new";};
text { caption = "H"; font = "courier new";};
text { caption = "J"; font = "courier new";};
text { caption = "K"; font = "courier new";};
text { caption = "M"; font = "courier new";};
text { caption = "N"; font = "courier new";};
text { caption = "P"; font = "courier new";};
text { caption = "R"; font = "courier new";};
text { caption = "T"; font = "courier new";};
text { caption = "S"; font = "courier new";};
text { caption = "W"; font = "courier new";};
text { caption = "X"; font = "courier new";};
text { caption = "Y"; font = "courier new";};
text { caption = "Z"; font = "courier new";};
} stimLetters;

picture {text D; x = 0; y = 0; } D1;
picture {text D; x = 0; y = 0; } D2;
picture {text D; x = 0; y = 0; } D3;
picture {text D; x = 0; y = 0; } D4;
picture {text D; x = 0; y = 0; } D5;
picture {text D; x = 0; y = 0; } D6;
picture {text D; x = 0; y = 0; } D7;
picture {text D; x = 0; y = 0; } D8;
picture {text D; x = 0; y = 0; } D9;
picture {text D; x = 0; y = 0; } D10;
picture {text D; x = 0; y = 0; } D11;
picture {text D; x = 0; y = 0; } D12;
picture {text D; x = 0; y = 0; } D13;
picture {text D; x = 0; y = 0; } D14;
picture {text D; x = 0; y = 0; } D15;
picture {text D; x = 0; y = 0; } D16;
picture {text D; x = 0; y = 0; } D17;


 trial {
	trial_duration = stimuli_length;
	trial_type = fixed;

	stimulus_event {  picture fixPic; time = 0; duration = $fixTime; code="prefix"; port_code = 32;} fixEventPrepS;
	stimulus_event {	picture D1; deltat = $fixTime; duration = $stimTime; code = "D1";} pic1;
	stimulus_event {	picture D2; deltat = $totalTime; duration = $stimTime; code = "D2";} pic2;
	stimulus_event {	picture D3; deltat = $totalTime; duration = $stimTime; code = "D3";} pic3;
	stimulus_event {	picture D4; deltat = $totalTime; duration = $stimTime; code = "D4";} pic4;
	stimulus_event {	picture D5; deltat = $totalTime; duration = $stimTime; code = "D5";} pic5;
	stimulus_event {	picture D6; deltat = $totalTime; duration = $stimTime; code = "D6";} pic6;
	stimulus_event {	picture D7; deltat = $totalTime; duration = $stimTime; code = "D7";} pic7;
	stimulus_event {	picture D8; deltat = $totalTime; duration = $stimTime; code = "D8";} pic8;
	stimulus_event {	picture D9; deltat = $totalTime; duration = $stimTime; code = "D9";} pic9;
	stimulus_event {	picture D10; deltat = $totalTime; duration = $stimTime; code = "D10";} pic10;
	stimulus_event {	picture D11; deltat = $totalTime; duration = $stimTime; code = "D11";} pic11;
	stimulus_event {	picture D12; deltat = $totalTime; duration = $stimTime; code = "D12";} pic12;
	stimulus_event {	picture D13; deltat = $totalTime; duration = $stimTime; code = "D13";} pic13;
	stimulus_event {	picture D14; deltat = $totalTime; duration = $stimTime; code = "D14";} pic14;
	stimulus_event {	picture D15; deltat = $totalTime; duration = $stimTime; code = "D15";} pic15;
	stimulus_event {	picture D16; deltat = $totalTime; duration = $stimTime; code = "D16";} pic16;
	stimulus_event {	picture D17; deltat = $totalTime; duration = $stimTime; code = "D17";} pic17;

 } ABtrial;


### T1 question

trial {

   trial_duration = forever;
   trial_type = first_response;


	stimulus_event {
	picture question1;
	time = 0;
	duration = 15000;
   target_button = 1;
   stimulus_time_in = 0;
   stimulus_time_out = never;
   response_active = true;
   code = "Q1";
	} target1;

} reportT1;

#T2 question
trial {

   trial_duration = forever;
   trial_type = first_response;


	stimulus_event {
	picture question2;
	time = 0;
	duration = 1500000;
   target_button = 1;
   stimulus_time_in = 0;
   stimulus_time_out = never;
   response_active = true;
   code = "Q2";
	} target2;

} reportT2;


text{caption=" ";}responseTxt ; #LCR: this doesn't appear to do anything; remove
picture{
	text responseTxt ;x=0;y=0;
}pictureDigitResponse;

###################################################################################
#	PCL																									 #
###################################################################################

begin_pcl;

# allTrials --> conditions
# 21 = absent lag 4
# 22 = absent lag 10
# 31 = present lag 4
# 32 = present lag 10
# 40 = absent lag 2

array <int> allTrials[20]={21,22,31,32,40,21,22,31,32,40,21,22,31,32,40,21,22,31,32,40,21,22,31,32,40};
array <int> alleletters[17]={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17}; #LCR: never used; remove

allTrials.shuffle();

int nTrial;
int t1hit = 0; #LCR: never used; remove
int t2hit = 0; #LCR: never used; remove
int T1acc = 0;
int T2acc = 0;
int T1T2acc = 0;

instruction1.present();
instruction2.present();
instruction3.present();

	loop nTrial = 1 until nTrial > 20 begin

		# sets all letters back to gray
		stimLetters[5].set_font_color(128,128,128); # T1
		stimLetters[5].redraw();
		stimLetters[7].set_font_color(128,128,128); # lag 2
		stimLetters[7].redraw();
		stimLetters[9].set_font_color(128,128,128); # lag 4
		stimLetters[9].redraw();
		stimLetters[15].set_font_color(128,128,128); # lag 10
		stimLetters[15].redraw();

		# randomization
		stimLetters.shuffle();

		# sets T1 to red color
		stimLetters[5].set_font_color(255,0,0);
		stimLetters[5].redraw();
		string T1_letter = stimLetters[5].caption();

		D1.set_part(1, stimLetters[1]);
		D2.set_part(1, stimLetters[2]);
		D3.set_part(1, stimLetters[3]);
		D4.set_part(1, stimLetters[4]);
		D5.set_part(1, stimLetters[5]);
		D6.set_part(1, stimLetters[6]);
		D7.set_part(1, stimLetters[7]);
		D8.set_part(1, stimLetters[8]);
		D9.set_part(1, stimLetters[9]);
		D10.set_part(1, stimLetters[10]);
		D11.set_part(1, stimLetters[11]);
		D12.set_part(1, stimLetters[12]);
		D13.set_part(1, stimLetters[13]);
		D14.set_part(1, stimLetters[14]);
		D15.set_part(1, stimLetters[15]);
		D16.set_part(1, stimLetters[16]);
		D17.set_part(1, stimLetters[17]);


		string T2_letter;

		# for prime absent
		if allTrials[nTrial] == 21 || allTrials[nTrial] == 22 then #LCR: outer if statement seems redundant; remove

		if  allTrials[nTrial] == 21 then # lag 4 absent
			stimLetters[9].set_font_color(0,255,0);
			stimLetters[9].redraw();
			T2_letter = stimLetters[9].caption();
			D9.set_part(1, stimLetters[9]);

		elseif allTrials[nTrial] == 22 then # lag 10 absent
			stimLetters[15].set_font_color(0,255,0);
			stimLetters[15].redraw();
			T2_letter = stimLetters[15].caption();
			D15.set_part(1, stimLetters[15]);
		end;


		# for prime present
		elseif allTrials[nTrial] == 31 || allTrials[nTrial] == 32 then

		text current_T2  = new text();
		current_T2.set_caption(stimLetters[7].caption());
		current_T2.set_font_color(0,255,0);
		current_T2.redraw();
		T2_letter = stimLetters[7].caption();


		# 7 is the lag of the prime, the code sets T2 to the same letter as the prime, in green
		if allTrials[nTrial] == 31 then # lag 4 present
			D9.set_part(1, current_T2);
		elseif allTrials[nTrial] == 32 then # lag 10 present
			D15.set_part(1, current_T2);
		end;

		elseif allTrials[nTrial] == 40 then
		stimLetters[7].set_font_color(0,255,0);
		stimLetters[7].redraw();
		D7.set_part(1, stimLetters[7]);
		T2_letter = stimLetters[7].caption();

		end;

		pic1.set_stimulus(D1);
		pic2.set_stimulus(D2);
		pic3.set_stimulus(D3);
		pic4.set_stimulus(D4);
		pic5.set_stimulus(D5);
		pic6.set_stimulus(D6);
		pic7.set_stimulus(D7);
		pic8.set_stimulus(D8);
		pic9.set_stimulus(D9);
		pic10.set_stimulus(D10);
		pic11.set_stimulus(D11);
		pic12.set_stimulus(D12);
		pic13.set_stimulus(D13);
		pic14.set_stimulus(D14);
		pic15.set_stimulus(D15);
		pic16.set_stimulus(D16);
		pic17.set_stimulus(D17);


ABtrial.present();

reportT1.present();
reportT2.present();


nTrial = nTrial + 1;

end;


practEnd.present();
