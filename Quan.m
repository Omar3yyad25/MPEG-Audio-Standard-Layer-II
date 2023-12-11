function [maxi,mini,sampled_quan] = Quan(sampled, n_bits)

  %%send the number of level -1 
    maxi = max(sampled);
    mini = min(sampled);
    L = 2^n_bits;
    
    %sampled_quan = [];
    sampled_quan = zeros(1,length(sampled));
    level_sep =(maxi - mini)/L; 
    
    level_1 = [0:level_sep: maxi];
    
    level_2 = [0-level_sep: -level_sep : mini];
    
    levels = [flip(level_2) level_1 ];

    transitions = levels + level_sep/2;
    
    
    for i = 1:length(sampled)
        if sampled(i)> transitions(L)
            sampled_quan(i) = (L - 1);
            %sampled_quan(i) = transitions(L);
        else
            for j=1:L
                if sampled(i)<transitions(j)
                   sampled_quan(i) = (j - 1);
                    % sampled_quan(i) = transitions(j);
                    break
                end
            end
        end
    end
end
