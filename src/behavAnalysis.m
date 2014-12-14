close all
clear all

driveLetter='Z:'; 
maindir = [driveLetter '\Students\slagter students\ABRFL\Data\Behav\ABTask\'];
readdir = [driveLetter '\Students\slagter students\ABRFL\Data\Behav\ABTask\'];            
writdir = [driveLetter '\Students\slagter students\ABRFL\Data\Behav\ABTask\Results\'];


cd(readdir)
sublist=dir('*.txt');
sublist={sublist.name};

for subno=1:length(sublist)
    %data=dlmread(sublist{subno});
        ABall=importdata(sublist{subno});
        ABtext=ABall.textdata;
        ABdata=ABall.data;

 %labels={'lag4_noprime';'lag10_noprime';'lag4_prime';'lag10_prime';'lag2_ctrl'};
 %   a   = bla(conditions==21);
 %   b   = bla(conditions==22);
 %   c   = bla(conditions==31);
 %   d   = bla(conditions==32);
 %   e   = bla(conditions==40);
 
 T1_lag4_noprime=0;
 T1_lag10_noprime=0;
 T1_lag4_prime=0;
 T1_lag10_prime=0;
 T1_lag2_noprime=0;
 NB_lag4_noprime=0;
 NB_lag10_noprime=0;
 NB_lag4_prime=0;
 NB_lag10_prime=0;
 NB_lag2_noprime=0;
 Swap_lag4_noprime=0;
 Swap_lag10_noprime=0;
 Swap_lag4_prime=0;
 Swap_lag10_prime=0;
 Swap_lag2_noprime=0;
 
 for j=1:length(ABdata)
 
 	if (strcmp(ABtext(j,4),ABtext(j,5))) % T1accurate
 		if strcmp(ABtext(j,2),'21')
 			T1_lag4_noprime=T1_lag4_noprime+1;
 		end
 		if strcmp(ABtext(j,2),'22')
 			T1_lag10_noprime=T1_lag10_noprime+1;
 		end
 		if strcmp(ABtext(j,2),'31')
 			T1_lag4_prime=T1_lag4_prime+1;
 		end
 		if strcmp(ABtext(j,2),'32')
 			T1_lag10_prime=T1_lag10_prime+1;
 		end
 		if strcmp(ABtext(j,2),'40')
 			T1_lag2_noprime=T1_lag2_noprime+1;
 		end
 		
 		if (strcmp(ABtext(j,6),ABtext(j,7))) % NoBlink
  			if strcmp(ABtext(j,2),'21')
  				NB_lag4_noprime=NB_lag4_noprime+1;
  			end
  			if strcmp(ABtext(j,2),'22')
  				NB_lag10_noprime=NB_lag10_noprime+1;
  			end
  			if strcmp(ABtext(j,2),'31')
  				NB_lag4_prime=NB_lag4_prime+1;
  			end
  			if strcmp(ABtext(j,2),'32')
  				NB_lag10_prime=NB_lag10_prime+1;
  			end
  			if strcmp(ABtext(j,2),'40')
  				NB_lag2_noprime=NB_lag2_noprime+1;
  			end

 		end
 	end
 
 	if (strcmp(ABtext(j,4),ABtext(j,7)) && strcmp(ABtext(j,5),ABtext(j,6))) % SWAP
  		if strcmp(ABtext(j,2),'21')
  			Swap_lag4_noprime=Swap_lag4_noprime+1;
  		end
  		if strcmp(ABtext(j,2),'22')
  			Swap_lag10_noprime=Swap_lag10_noprime+1;
  		end
  		if strcmp(ABtext(j,2),'31')
  			Swap_lag4_prime=Swap_lag4_prime+1;
  		end
  		if strcmp(ABtext(j,2),'32')
  			Swap_lag10_prime=Swap_lag10_prime+1;
  		end
  		if strcmp(ABtext(j,2),'40')
  			Swap_lag2_noprime=Swap_lag2_noprime+1;
  		end

 	end
 end

    output(subno,:)=[subno T1_lag4_noprime T1_lag10_noprime T1_lag4_prime T1_lag10_prime T1_lag2_noprime NB_lag4_noprime NB_lag10_noprime NB_lag4_prime NB_lag10_prime NB_lag2_noprime Swap_lag4_noprime Swap_lag10_noprime Swap_lag4_prime Swap_lag10_prime Swap_lag2_noprime]
    outfiledirandname=[ writdir sublist{subno}(1:3) '_results.txt' ];
    dlmwrite(outfiledirandname, [T1_lag4_noprime T1_lag10_noprime T1_lag4_prime T1_lag10_prime T1_lag2_noprime NB_lag4_noprime NB_lag10_noprime NB_lag4_prime NB_lag10_prime NB_lag2_noprime Swap_lag4_noprime Swap_lag10_noprime Swap_lag4_prime Swap_lag10_prime Swap_lag2_noprime],'\t');
end

    outfiledirandname_all=[ writdir 'ABgroup_results.txt' ];
    dlmwrite(outfiledirandname_all, output,'\t');
 