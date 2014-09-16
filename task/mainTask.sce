#######################################################################################################
#																																		#
#	 TASK TRIALS																													#
#   Attentional Blink task 																									#
#	 Heleen Slagter & Katerina Georgopoulou																				#
#	 Spring 2012                               																			#
#                                 																							#
#######################################################################################################

#######################################################################################################
#	Headers																								 							#
#######################################################################################################

#screen_width = 1024;
#screen_height = 768;
#screen_bit_depth = 16;

response_matching = simple_matching;
active_buttons = 21;
button_codes = 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21;
event_code_delimiter = "\t";
write_codes = true;
response_logging = log_all;
response_port_output=false;
pulse_width = 10;

default_font_size = 40;
default_text_align = align_center;
default_background_color = 50,50,50;
default_font = "courier new";
default_text_color = 128,128,128;					

###################################################################################
#  SDL																									 #
###################################################################################

begin;

### stimulustime and totaltime (stimulus + ISI)

array{ 
$fixtime = 480; # en deze wordt 500	
$stimtime = 87; # can it be made 93.3?? --> with refresh rate = 120 Hz, 91.6667 is possible.
$totaltime =87; # bij 82 is de timing 83/84 ms, bij 83 gaat deze over naar 100 ms (als RR 60Hz is..)
} tijden;


picture{text { caption = "+"; font = "courier new"; font_size = 22;};x=0;y=0;}fix_pic;

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


trial {
  trial_duration = forever;                  # Instructie. 
  trial_type = first_response;
  stimulus_event{
  picture { text { caption = "You can take a short break now! 


Press Enter whenever you are ready to continue."; font_size = 22;}; 
	x = 0; y = 0;};
	code = "99";
   }break_stim;
 } break_trial;    
  
  
 trial {                                                                   
  trial_duration = 15995;                    # Geeft een boodschap mee aan het einde van het blok
  picture { text { caption = "Well done! 
  You will now continue with a second task.
  
Please call the experiment leader."; font_size = 22;}; 
  x = 0; y = 0;};
  code = "99";
} einde;     


###############################################################

### letters: I, L, O, Q, U and V are not included.
array {
text { caption = "A"; font = "courier new";}D;
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
} stimletters;

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
  
	stimulus_event {  picture fix_pic; time = 0; duration = $fixtime; code="prefix"; port_code = 32;} FixEventPrepS; 
	stimulus_event {	picture D1; deltat = $fixtime; duration = $stimtime; code = "D1";} pic1;	 
	stimulus_event {	picture D2; deltat = $totaltime; duration = $stimtime; code = "D2";} pic2;
	stimulus_event {	picture D3; deltat = $totaltime; duration = $stimtime; code = "D3";} pic3;
	stimulus_event {	picture D4; deltat = $totaltime; duration = $stimtime; code = "D4";} pic4;
	stimulus_event {	picture D5; deltat = $totaltime; duration = $stimtime; code = "D5";} pic5;
	stimulus_event {	picture D6; deltat = $totaltime; duration = $stimtime; code = "D6";} pic6;
	stimulus_event {	picture D7; deltat = $totaltime; duration = $stimtime; code = "D7";} pic7;
	stimulus_event {	picture D8; deltat = $totaltime; duration = $stimtime; code = "D8";} pic8;
	stimulus_event {	picture D9; deltat = $totaltime; duration = $stimtime; code = "D9";} pic9;
	stimulus_event {	picture D10; deltat = $totaltime; duration = $stimtime; code = "D10";} pic10;
	stimulus_event {	picture D11; deltat = $totaltime; duration = $stimtime; code = "D11";} pic11;
	stimulus_event {	picture D12; deltat = $totaltime; duration = $stimtime; code = "D12";} pic12;
	stimulus_event {	picture D13; deltat = $totaltime; duration = $stimtime; code = "D13";} pic13;
	stimulus_event {	picture D14; deltat = $totaltime; duration = $stimtime; code = "D14";} pic14;	
	stimulus_event {	picture D15; deltat = $totaltime; duration = $stimtime; code = "D15";} pic15;
	stimulus_event {	picture D16; deltat = $totaltime; duration = $stimtime; code = "D16";} pic16;	
	stimulus_event {	picture D17; deltat = $totaltime; duration = $stimtime; code = "D17";} pic17;	
	
 } ABRFL_trial;
 
 
### T1 questions
 
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
	
} report_t1;

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
	
} report_t2;


text{caption=" ";}responseTxt ;
picture{
	text responseTxt ;x=0;y=0;
}picture_digit_response;

###################################################################################
#	PCL																									 #
###################################################################################

begin_pcl;

array <int> alletrials[40]={
21,22,31,32,40,21,22,31,32,40,21,22,31,32,40,21,22,31,32,40,
21,22,31,32,40,21,22,31,32,40,21,22,31,32,40,21,22,31,32,40 };
 
array <int> alleletters[17]={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17};



int trialnumber;
int blocknumber;
int t1hit = 0;
int t2hit = 0;
int T1acc = 0;
int T2acc = 0;
int T1T2acc = 0;

#################################################################################
###################################PLAATJES MAKEN################################


### data are also put in a separate logfile
string presentatiefile = logfile.subject()+ "_ABRFL_output.txt";
output_file out = new output_file;

out.open(presentatiefile);

# alletrials --> conditions
# 21 = absent lag 4
# 22 = absent lag 10
# 31 = present lag 4
# 32 = present lag 10
# 40 = absent lag 2

loop blocknumber = 1 until blocknumber > 5 begin

alletrials.shuffle();

	loop trialnumber = 1 until trialnumber > 40 begin
		
		# sets all letters back to gray font
		stimletters[5].set_font_color(128,128,128);
		stimletters[5].redraw();
		stimletters[7].set_font_color(128,128,128);
		stimletters[7].redraw();
		stimletters[9].set_font_color(128,128,128);
		stimletters[9].redraw();
		stimletters[15].set_font_color(128,128,128);
		stimletters[15].redraw();
		
		# randomization
		stimletters.shuffle();
		
		# sets the 5th letter to red color
		stimletters[5].set_font_color(255,0,0);
		stimletters[5].redraw();
		string T1_letter = stimletters[5].caption();
	
		D1.set_part(1, stimletters[1]);
		D2.set_part(1, stimletters[2]);
		D3.set_part(1, stimletters[3]);
		D4.set_part(1, stimletters[4]);
		D5.set_part(1, stimletters[5]);
		D6.set_part(1, stimletters[6]);
		D7.set_part(1, stimletters[7]);
		D8.set_part(1, stimletters[8]);
		D9.set_part(1, stimletters[9]);
		D10.set_part(1, stimletters[10]);
		D11.set_part(1, stimletters[11]);
		D12.set_part(1, stimletters[12]);
		D13.set_part(1, stimletters[13]);
		D14.set_part(1, stimletters[14]);
		D15.set_part(1, stimletters[15]);
		D16.set_part(1, stimletters[16]);
		D17.set_part(1, stimletters[17]);
		
		
		string T2_letter;
	
		# for prime absent
		if alletrials[trialnumber] == 21 || alletrials[trialnumber] == 22 then

		if  alletrials[trialnumber] == 21 then # lag 4 absent
			stimletters[9].set_font_color(0,255,0);
			stimletters[9].redraw();
			T2_letter = stimletters[9].caption();
			D9.set_part(1, stimletters[9]);
			
		elseif alletrials[trialnumber] == 22 then # lag 10 absent
			stimletters[15].set_font_color(0,255,0);
			stimletters[15].redraw();
			T2_letter = stimletters[15].caption();
			D15.set_part(1, stimletters[15]);
		end;
				
				
		# for prime present
		elseif alletrials[trialnumber] == 31 || alletrials[trialnumber] == 32 then
		
		text current_T2  = new text();
		current_T2.set_caption(stimletters[7].caption());
		current_T2.set_font_color(0,255,0);
		current_T2.redraw();
		T2_letter = stimletters[7].caption();
		
						
		# 7 is the lag of the prime, the code sets T2 to the same letter as the prime, in green
		if alletrials[trialnumber] == 31 then # lag 4 present
			D9.set_part(1, current_T2);
		elseif alletrials[trialnumber] == 32 then # lag 10 present
			D15.set_part(1, current_T2);
		end;
		
		elseif alletrials[trialnumber] == 40 then
		stimletters[7].set_font_color(0,255,0);
		stimletters[7].redraw();
		D7.set_part(1, stimletters[7]);
		T2_letter = stimletters[7].caption();
			
		end; #condition loop 
		
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
		
		
		int pre_stimnr = stimulus_manager.stimulus_count();
		
		ABRFL_trial.present();
		
		term.print(pre_stimnr);
		term.print("# ");
		
		
###### output: timing 

		stimulus_data t1 = stimulus_manager.get_stimulus_data(pre_stimnr+6);
		stimulus_data d1 = stimulus_manager.get_stimulus_data(pre_stimnr+7);
		stimulus_data stim2 = stimulus_manager.get_stimulus_data(pre_stimnr+8);
		stimulus_data fix = stimulus_manager.get_stimulus_data(pre_stimnr+1);
		stimulus_data stim1 = stimulus_manager.get_stimulus_data(pre_stimnr+2);
		int time_t1 = t1.time();
		int time_d1 = d1.time();
		int time_stim2 = stim2.time();
		int time_fix = fix.time();
		int time_stim1 = stim1.time();

		#term.print(time_t1);
		#term.print(" ");
		#term.print(time_d1);
		#term.print(" | ");
		term.print(time_d1 - time_t1);
		term.print(" | ");
		term.print(time_stim2 - time_d1);
		term.print(" | ");
		term.print(time_stim1 - time_fix);
		term.print(" \n ");
					
###### output: letters
		
		array <string> button_to_key[20]={"W","E","R","T","Y","P","A","S","D","F","G","H","J","K","Z","X","C","B","N","M"};
		
		report_t1.present();
		stimulus_data t1_response = stimulus_manager.last_stimulus_data();
		int button_t1 = t1_response.button();
		string button_letter_t1 = button_to_key[button_t1];
	
		report_t2.present();
		stimulus_data t2_response  = stimulus_manager.last_stimulus_data();
		int button_t2 = t2_response.button();
		string button_letter_t2 = button_to_key[button_t2];
	
				
		if T1_letter == button_letter_t1 then
			T1acc = 1;
		else 
			T1acc = 0;
		end;
		if T2_letter == button_letter_t2 then
			T2acc = 1;
		else 
			T2acc = 0;
		end;
			

		if T1_letter == button_letter_t1 && T2_letter == button_letter_t2 then			### 3 = both correct
			T1T2acc = 3;
		elseif T1_letter != button_letter_t1 && T2_letter != button_letter_t2 then		### 0 = both incorrect
			T1T2acc = 0;
		elseif T1_letter == button_letter_t1 && T2_letter != button_letter_t2 then		### 1 = only T1 correct (blink trial)
			T1T2acc = 1;
		elseif T1_letter != button_letter_t1 && T2_letter == button_letter_t2 then		### 2 = only T2 corrrect
			T1T2acc = 2;
		elseif T1_letter == button_letter_t2 && T2_letter == button_letter_t1 then		### 13 = T1/T2 swapped (both correct)
			T1T2acc = 13;
		elseif T1_letter == button_letter_t2 && T2_letter != button_letter_t1 then		### 11 = only T1 correct, but given as T2 answer
			T1T2acc = 11;
		elseif T1_letter != button_letter_t2 && T2_letter == button_letter_t1 then		### 12 = only T2 correct, but given as T1 answer
			T1T2acc = 12;
		end;
				
				
		out.print(trialnumber);
		out.print("\t");
		out.print(alletrials[trialnumber]);
		out.print("\t");
		out.print(time_d1 - time_t1);
		out.print("\t");
		out.print(T1_letter);
		out.print("\t");
		out.print(button_letter_t1);
		out.print("\t");
		out.print(T2_letter);
		out.print("\t");
		out.print(button_letter_t2);
		out.print("\t");
		out.print(T1acc);
		out.print("\t"); 
		out.print(T2acc);
		out.print("\t");
		out.print(T1T2acc);
		out.print("\n"); 
		 /* 
		 term.print(alletrials[trialnumber]);
		term.print("# ");
		term.print(time_t1);
		term.print(" ");
		term.print(time_t2);
		term.print(" | ");
		int time_t1_t2 = time_t2 - time_t1; 
		term.print(time_t1_t2);
		term.print(" // ");
		 
		
		term.print(trialnumber);
		term.print(" ");
		term.print(alletrials[trialnumber]);
		term.print(" ");
		term.print(T1_letter);
		term.print(" ");
		term.print(button_letter_t1);
		term.print("=t1 | ");
		term.print(T2_letter);
		term.print(" ");
		term.print(button_letter_t2);
		term.print("=t2 // ");
		*/
	
trialnumber = trialnumber + 1;
	
end;   

if blocknumber < 5 then
break_trial.present();
elseif blocknumber == 5 then
einde.present();
end;

blocknumber = blocknumber +1;

end;

out.close();



/*

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
     
	trialnumber = trialnumber + 1;
	
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
einde.present();


