function data = behavAnalysis(files)

for subno=1:length(files)
        ABall=importdata(files{subno});
        ABtext=ABall.textdata;
        ABnum=ABall.data;
 
 for j=1:length(ABnum)
 
 	if (strcmp(ABtext(j,4),ABtext(j,5))) % T1accurate
 		if strcmp(ABtext(j,2),'21')
 			data.T1_lag4_noprime(subno)=data.T1_lag4_noprime(subno)+1;
 		end
 		if strcmp(ABtext(j,2),'22')
 			data.T1_lag10_noprime(subno)=data.T1_lag10_noprime(subno)+1;
 		end
 		if strcmp(ABtext(j,2),'31')
 			data.T1_lag4_prime(subno)=data.T1_lag4_prime(subno)+1;
 		end
 		if strcmp(ABtext(j,2),'32')
 			data.T1_lag10_prime(subno)=data.T1_lag10_prime(subno)+1;
 		end
 		if strcmp(ABtext(j,2),'40')
 			data.T1_lag2_noprime(subno)=data.T1_lag2_noprime(subno)+1;
 		end
 		
 		if (strcmp(ABtext(j,6),ABtext(j,7))) % NoBlink
  			if strcmp(ABtext(j,2),'21')
  				data.NB_lag4_noprime(subno)=data.NB_lag4_noprime(subno)+1;
  			end
  			if strcmp(ABtext(j,2),'22')
  				data.NB_lag10_noprime(subno)=data.NB_lag10_noprime(subno)+1;
  			end
  			if strcmp(ABtext(j,2),'31')
  				data.NB_lag4_prime(subno)=data.NB_lag4_prime(subno)+1;
  			end
  			if strcmp(ABtext(j,2),'32')
  				data.NB_lag10_prime(subno)=data.NB_lag10_prime(subno)+1;
  			end
  			if strcmp(ABtext(j,2),'40')
  				data.NB_lag2_noprime(subno)=data.NB_lag2_noprime(subno)+1;
  			end

 		end
 	end
 
 	if (strcmp(ABtext(j,4),ABtext(j,7)) && strcmp(ABtext(j,5),ABtext(j,6))) % SWAP
  		if strcmp(ABtext(j,2),'21')
  			data.Swap_lag4_noprime(subno)=data.Swap_lag4_noprime(subno)+1;
  		end
  		if strcmp(ABtext(j,2),'22')
  			data.Swap_lag10_noprime(subno)=data.Swap_lag10_noprime(subno)+1;
  		end
  		if strcmp(ABtext(j,2),'31')
  			data.Swap_lag4_prime(subno)=data.Swap_lag4_prime(subno)+1;
  		end
  		if strcmp(ABtext(j,2),'32')
  			data.Swap_lag10_prime(subno)=data.Swap_lag10_prime(subno)+1;
  		end
  		if strcmp(ABtext(j,2),'40')
  			data.Swap_lag2_noprime(subno)=data.Swap_lag2_noprime(subno)+1;
  		end

 	end
 end

end
