function masked_range=masking_threshold(spl,masker_freq)

if spl>0 && spl <=10
    masked_range=masker_freq+ 100;
elseif spl>10 && spl <=20
    masked_range=masker_freq+ 250;
elseif spl>20 && spl <=30
    masked_range=masker_freq+ 350;
elseif spl>30 && spl <=40
    masked_range=masker_freq+ 550;
elseif spl>40 && spl <=50
    masked_range=masker_freq+ 850;
elseif spl>50 && spl <=60
    masked_range=masker_freq+ 1200;
elseif spl>60 && spl <=70
    masked_range=masker_freq+ 2000;
elseif spl>70 && spl <=80
    masked_range=masker_freq+ 7000;
elseif spl>80 && spl <=90
    masked_range=masker_freq+ 13000;
else
   % do nothing  
   masked_range=masker_freq+ 13000;
end
end
