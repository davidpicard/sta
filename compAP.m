function [ ap ] = compAP( gi , idRequest , groundtruthi )
%COMPAP Summary of this function goes here
%   Detailed explanation goes here

    [~ , idx] = sort(gi,'descend');
    idx = idx(idx ~= idRequest);
    ranks = 0:(length(idx)-1);
    
    ranks = ranks(groundtruthi(idx));
    
    r_step = 0.5 / length(ranks);
    
    ap = 0;
    
    for i = 0:(length(ranks)-1)
        rank = ranks(i+1);
        if (rank == 0)
            ap0 = 1;
        else
            ap0 = i / rank;
        end
        ap1 = (i+1) / (rank+1);
        ap = ap + (ap0+ap1) * r_step;
        
    end

end
