function [sampled_dequan] = DeQuan(maxi, mini, n_bits, quan)

    L = 2^n_bits;
    level_sep =(maxi - mini)/L;
    
    level_1 = [0:level_sep: maxi];
    
    level_2 = [0-level_sep: -level_sep : mini];
    
    levels = [flip(level_2) level_1 ];
    
    
    sampled_dequan = zeros(1,length(quan));
    
    for i = 1:length(quan)
        sampled_dequan(i) = levels(1+quan(i));
    end
end