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

# Stimulus durations (N.B. All times are minus approx. half a frame at 120 Hz, to present at next scan)
array{
$preFixTime = 1745; #fixation period before start of stream
$postRespTime = 245; # fixation period after final response (so adjoining pre-stream fixation)
$postFixTime = 995; #fixation period after end of stream
$stimTime = 87; #duration of one stimulus in the stream.
$totalTime = 87; #inter-stimulus interval (onset relative to preceding stimulus in the stream).
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
  trial_duration = 15995;
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

	stimulus_event {  picture fixPic; time = 0; duration = $preFixTime; code="prefix"; port_code = 10;} fixEventPre;
	stimulus_event {	picture D1; deltat = $preFixTime; duration = $stimTime; code = "D1";} pic1;
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
  stimulus_event {  picture fixPic; deltat = $stimTime; duration = $postFixTime; code="postfix"; port_code = 40;} fixEventPost;

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
	 port_code = 50;
	} target1;

} reportT1;

### T2 question
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

### Post-response fixation
# to have something to attach T2 accuracy trigger to
# together with $preFixTime this makes the total ITI

trial{

	trial_duration=stimuli_length;
	trial_type=fixed;
	stimulus_event{
		picture fixPic;
		duration=$postRespTime;
	}itiEventPost;

}itiTrialPost;

###################################################################################
#	PCL																									 #
###################################################################################

begin_pcl;

# Experiment parameters
int nBlocks = 6;
int nTrials = 100;

# Stimulus properties
rgb_color defColor = rgb_color(128,128,128);
rgb_color T1color = rgb_color(255,0,0);
rgb_color T2color = rgb_color(0,255,0);
int T1posMin = 5;
int T1posMax = 5;

# Experiment conditions
array<int> lags[5] = {1, 2, 3, 4, 8}; # all desired lag positions for T2
array <int> allTrials[nTrials];
loop int i = 1 until i > lags.count() begin # for each lag
allTrials.fill(1+(i-1)*nTrials/lags.count(),i*nTrials/lags.count(),lags[i],0); # fill condition matrix with equal amount of trials
i= i + 1;
end;

int tTot=1;
int t;
int b;
int T1acc = 0;
int T2acc = 0;
int T1T2acc = 0;
int T1pos;


### data are also put in a separate logfile
string outFile = logfile.subject()+ "_AB_output.txt";
output_file out = new output_file;

out.open(outFile);

#print column headers
out.print("totalTrial\tblock\ttrial\tlag\tT1pos\tT1letter\tT1resp\tT2letter\tT2resp\tT1acc\tT2acc\tT1T2acc\n");

loop b = 1 until b > nBlocks begin

allTrials.shuffle();
response_manager.set_button_active(21,false); # stop listening for 'return/enter' button presses

	loop t = 1 until t > nTrials begin

		# randomization
		stimLetters.shuffle();
		T1pos = random(T1posMin,T1posMax); #determine T1 position in stream

		# set T1 color
		stimLetters[T1pos].set_font_color(T1color);
		stimLetters[T1pos].redraw();
		string T1letter = stimLetters[T1pos].caption(); # get T1 identity

		# set T2 color
		stimLetters[T1pos+allTrials[t]].set_font_color(T2color);
		stimLetters[T1pos+allTrials[t]].redraw();
		string T2letter = stimLetters[T1pos+allTrials[t]].caption(); # get T2 identity

		# set triggers
		ABtrial.get_stimulus_event(1).set_port_code(20+allTrials[t]); #stream onset, code is 20 + lag (e.g. "22" for lag 2)
		ABtrial.get_stimulus_event(T1pos).set_port_code(31); # T1
		ABtrial.get_stimulus_event(T1pos+allTrials[t]).set_port_code(32); # T2


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

		# set all targets back to gray

		stimLetters[T1pos].set_font_color(defColor); # T1
		stimLetters[T1pos].redraw();
		stimLetters[T1pos+allTrials[t]].set_font_color(defColor); # T2
		stimLetters[T1pos+allTrials[t]].redraw();

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

		term.print(timeD1 - timeT1);
		term.print(" | ");
		term.print(timeStim2 - timeD1);
		term.print(" | ");
		term.print(timeStim1 - timeFix);
		term.print(" \n ");

###### output: letters

		array <string> button2key[20]={"W","E","R","T","Y","P","A","S","D","F","G","H","J","K","Z","X","C","B","N","M"};

		reportT1.present();
		stimulus_data T1resp = stimulus_manager.last_stimulus_data();
		int T1button = T1resp.button();
		string T1key = button2key[T1button];

		if T1letter == T1key then
			T1acc = 1;
			target2.set_port_code(61);
		else
			T1acc = 0;
			target2.set_port_code(60);
		end;

		reportT2.present();
		stimulus_data T2resp  = stimulus_manager.last_stimulus_data();
		int T2button = T2resp.button();
		string T2key = button2key[T2button];

		if T2letter == T2key then
			T2acc = 1;
			itiEventPost.set_port_code(71);
		else
			T2acc = 0;
			itiEventPost.set_port_code(70);
		end;

		if T1letter == T1key && T2letter == T2key then			### 3 = both correct
			T1T2acc = 3;
		elseif T1letter != T1key && T2letter != T2key then		### 0 = both incorrect
			T1T2acc = 0;
		elseif T1letter == T1key && T2letter != T2key then		### 1 = only T1 correct (blink trial)
			T1T2acc = 1;
		elseif T1letter != T1key && T2letter == T2key then		### 2 = only T2 correct
			T1T2acc = 2;
		end;

		itiTrialPost.present();

		out.print(tTot);
		out.print("\t");
		out.print(b);
		out.print("\t");
		out.print(t);
		out.print("\t");
		out.print(allTrials[t]);
		out.print("\t");
		out.print(T1pos);
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

t = t + 1;
tTot = tTot + 1;

end;

response_manager.set_button_active(21,true); # resume listening for 'return/enter' button presses
if b < nBlocks then
breakTrial.present();
elseif b == nBlocks then
expEnd.present();
end;

b = b +1;

end;

out.close();
