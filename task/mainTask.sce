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
$stimTime = 87; #duration of one stimulus in the stream. LCR: should be 91.66 ms, not sure why it's set to 87. Minus half a frame?
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
  picture { text { caption = "You can take a short break now!


Press Enter whenever you are ready to continue."; font_size = 22;};
	x = 0; y = 0;};
	code = "99";
   }breakStim;
 } breakTrial;


 trial {
  trial_duration = 15995; #LCR: Not sure why this is set to this particular number (15 seconds and 995 ms)
  picture { text { caption = "All done!

Please wait for the experimenter."; font_size = 22;};
  x = 0; y = 0;};
  code = "99";
} expEnd;


###############################################################

# letters: I, L, O, Q, U and V are not included.
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

# Experiment parameters
int nBlocks = 5;
int nTrials = 40;

# allTrials --> conditions
# 2 = lag 2
# 8 = lag 8

array <int> allTrials[nTrials];
allTrials.fill(1,nTrials/2,2,0);
allTrials.fill((nTrials/2)+1),nTrials,8,0);

array <int> alleletters[17]={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17}; #LCR: never used; remove

int t;
int b;
int t1hit = 0; #LCR: never used; remove
int t2hit = 0; #LCR: never used; remove
int T1acc = 0;
int T2acc = 0;
int T1T2acc = 0;


### data are also put in a separate logfile
string outFile = logfile.subject()+ "_AB_output.txt";
output_file out = new output_file;

out.open(outFile);

loop b = 1 until b > nBlocks begin

allTrials.shuffle();

	loop t = 1 until t > nTrials begin

		# sets all letters back to gray

		stimLetters[5].set_font_color(128,128,128); # T1
		stimLetters[5].redraw();
		stimLetters[7].set_font_color(128,128,128); # lag 2
		stimLetters[7].redraw();
		stimLetters[13].set_font_color(128,128,128); # lag 8
		stimLetters[13].redraw();

		# randomization
		stimLetters.shuffle();

		# sets T1 to red
		stimLetters[5].set_font_color(255,0,0);
		stimLetters[5].redraw();
		string T1letter = stimLetters[5].caption();

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


		string T2letter;

		# Lag 2
		if  allTrials[t] == 2 then
			stimLetters[7].set_font_color(0,255,0);
			stimLetters[7].redraw();
			T2_letter = stimLetters[7].caption();
			D7.set_part(1, stimLetters[7]);

		# Lag 8
		elseif allTrials[t] == 8 then
			stimLetters[13].set_font_color(0,255,0);
			stimLetters[13].redraw();
			T2_letter = stimLetters[13].caption();
			D13.set_part(1, stimLetters[13]);
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


		int preStimNr = stimulus_manager.stimulus_count();

		ABtrial.present();

		#LCR: decide whether to keep all these outputs to terminal
		term.print(preStimNr);
		term.print("# ");


###### output: timing

		stimulus_data t1 = stimulus_manager.get_stimulus_data(preStimNr+6);
		stimulus_data d1 = stimulus_manager.get_stimulus_data(preStimNr+7);
		stimulus_data stim2 = stimulus_manager.get_stimulus_data(preStimNr+8);
		stimulus_data fix = stimulus_manager.get_stimulus_data(preStimNr+1);
		stimulus_data stim1 = stimulus_manager.get_stimulus_data(preStimNr+2);
		int timeT1 = t1.time();
		int timeD1 = d1.time();
		int timeStim2 = stim2.time();
		int timeFix = fix.time();
		int timeStim1 = stim1.time();

		#term.print(timeT1);
		#term.print(" ");
		#term.print(timeD1);
		#term.print(" | ");
		term.print(timeD1 - timeT1);
		term.print(" | ");
		term.print(timeStim2 - timeD1);
		term.print(" | ");
		term.print(timeStim1 - timeFix);
		term.print(" \n ");

###### output: letters # LCR: not sure how these letters are mapped to numbers 1-20

		array <string> button2key[20]={"W","E","R","T","Y","P","A","S","D","F","G","H","J","K","Z","X","C","B","N","M"};

		reportT1.present();
		stimulus_data T1resp = stimulus_manager.last_stimulus_data();
		int T1button = T1resp.button();
		string T1key = button2key[T1button];

		reportT2.present();
		stimulus_data T2resp  = stimulus_manager.last_stimulus_data();
		int T2button = T2resp.button();
		string T2key = button2key[T2button];


		if T1letter == T1key then
			T1acc = 1;
		else
			T1acc = 0;
		end;
		if T2letter == T2key then
			T2acc = 1;
		else
			T2acc = 0;
		end;


		if T1letter == T1key && T2letter == T2key then			### 3 = both correct
			T1T2acc = 3;
		elseif T1letter != T1key && T2letter != T2key then		### 0 = both incorrect
			T1T2acc = 0;
		elseif T1letter == T1key && T2letter != T2key then		### 1 = only T1 correct (blink trial)
			T1T2acc = 1;
		elseif T1letter != T1key && T2letter == T2key then		### 2 = only T2 correct
			T1T2acc = 2;
		elseif T1letter == T2key && T2letter == T1key then		### 13 = T1/T2 swapped (both correct)
			T1T2acc = 13;
		elseif T1letter == T2key && T2letter != T1key then		### 11 = only T1 correct, but given as T2 answer
			T1T2acc = 11;
		elseif T1letter != T2key && T2letter == T1key then		### 12 = only T2 correct, but given as T1 answer
			T1T2acc = 12;
		end;


		out.print(t);
		out.print("\t");
		out.print(allTrials[t]);
		out.print("\t");
		out.print(timeD1 - timeT1);
		out.print("\t");
		out.print(T1letter);
		out.print("\t");
		out.print(T1key);
		out.print("\t");
		out.print(T2letter);
		out.print("\t");
		out.print(T2key);
		out.print("\t");
		out.print(T1acc);
		out.print("\t");
		out.print(T2acc);
		out.print("\t");
		out.print(T1T2acc);
		out.print("\n");
		 /* # LCR: does this mean all of this is commented out?
		term.print(allTrials[t]);
		term.print("# ");
		term.print(timeT1);
		term.print(" ");
		term.print(time_t2);
		term.print(" | ");
		int timeT1_t2 = time_t2 - timeT1; #LCR: time_t2 does not appear to exist...
		term.print(timeT1_t2);
		term.print(" // ");


		term.print(t);
		term.print(" ");
		term.print(allTrials[t]);
		term.print(" ");
		term.print(T1letter);
		term.print(" ");
		term.print(T1key);
		term.print("=t1 | ");
		term.print(T2letter);
		term.print(" ");
		term.print(T2key);
		term.print("=t2 // ");
		*/

t = t + 1;

end;

if b < 5 then
breakTrial.present();
elseif b == 5 then
expEnd.present();
end;

b = b +1;

end;

out.close();



/* #LCR: again I take it this is all non-functioning

	out.print(T2acc);
	out.print("\t");
   if givenresponseT1 == responseT1 && givenresponseT2 == responseT2 then			### 3 = both correct
		T1T2acc = 3;
	elseif givenresponseT1 != responseT1 && givenresponseT2 != responseT2 && givenresponseT1 != responseT2 && givenresponseT2 != responseT1 then		### 0 = both incorrect
		T1T2acc = 0;
	elseif givenresponseT1 == responseT1 && givenresponseT2 != responseT2 then		### 1 = T1 correct
		T1T2acc = 1;
	elseif givenresponseT1 != responseT1 && givenresponseT2 == responseT2 then		### 2 = T2 corrrect
		T1T2acc = 2;
	elseif givenresponseT1 == responseT2 && givenresponseT2 == responseT1 then		### 10 = T1/T2 switched (wrong order)
		T1T2acc = 10;
		swapped_code.present();

	#elseif givenresponseT1 != responseT2 && givenresponseT2 == responseT1 then	### are we interested in this??
	#	T2acc = 4;

	end;
	out.print(T1T2acc);
	out.print("\n");

	t = t + 1;

	end;

#Insert breaks
if i == 1 || i==2 || i==3 || i == 5|| i==6 || i==7 || i == 9 || i==10 then
 KortePauze.present();
elseif i == 4 || i == 8 then
 LangePauze.present();
end;

i = i + 1;


end;

out.close();
#report_scores();
expEnd.present();
