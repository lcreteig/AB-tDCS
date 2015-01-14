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
active_buttons = 22;
button_codes = 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22; #1 through 20 are keyboard letters; 21 is "return" (for subject, to go to next screen); 22 is "home" (for experimenter, to exit)
write_codes = false; # write event codes to parallel port
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
  trial_duration = 29995;
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


 trial {
	trial_duration = stimuli_length;
	trial_type = fixed;

	stimulus_event {  picture fixPic; time = 0; duration = $fixTime; code="prefix"; } fixEventPre;
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
	stimulus_event {  picture fixPic; deltat = $stimTime; duration = $postFixTime; code="postfix"; } fixEventPost;

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


###################################################################################
#	PCL																									 #
###################################################################################

begin_pcl;

# Experiment parameters
int nTrials = 20;

# Stimulus properties
rgb_color defColor = rgb_color(128,128,128);
rgb_color T1color = rgb_color(255,0,0);
rgb_color T2color = rgb_color(0,255,0);
int T1posMin = 5;
int T1posMax = 5;

# Experiment conditions
array<int> lags[3] = {3,3,8}; # all desired lag positions for T2.
#If you add the same lag more than once, there will be proportionally more of these trials (e.g. {3,3,8} means 2 times as many lag 3 trials as lag 8 trials).
#Note that the array size indicator x ("lags[x]") must always match the number of elements (so in the above example x should be 3)!

array <int> allTrials[nTrials];
loop int i = 1 until i > lags.count() begin # for each lag
allTrials.fill(1+(i-1)*nTrials/lags.count(),i*nTrials/lags.count(),lags[i],0); # fill condition matrix with equal amount of trials
i= i + 1;
end;;

allTrials.shuffle();

int t;
int T1acc = 0;
int T2acc = 0;
int T1T2acc = 0;
int T1pos;

instruction1.present();
instruction2.present();
instruction3.present();
response_manager.set_button_active(21,false); # stop listening for 'return/enter' button presses

	loop t = 1 until t > nTrials begin

		# randomization
		stimLetters.shuffle();
		T1pos = random(T1posMin,T1posMax); #determine T1 position in stream

		# set T1 color
		stimLetters[T1pos].set_font_color(T1color);
		stimLetters[T1pos].redraw();
		string T1_letter = stimLetters[5].caption();

		# set T2 color
		stimLetters[T1pos+allTrials[t]].set_font_color(T2color);
		stimLetters[T1pos+allTrials[t]].redraw();
		string T2letter = stimLetters[T1pos+allTrials[t]].caption();

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


ABtrial.present();

reportT1.present();
reportT2.present();

# set all targets back to gray

stimLetters[T1pos].set_font_color(defColor); # T1
stimLetters[T1pos].redraw();
stimLetters[T1pos+allTrials[t]].set_font_color(defColor); # T2
stimLetters[T1pos+allTrials[t]].redraw();


t = t + 1;

end;


practEnd.present();
