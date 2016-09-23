function [ mAP , APs ] = compMAP( G , idRequests , groundtruth )
%COMPMAP2 Summary of this function goes here
%   Detailed explanation goes here
    APs = zeros(size(idRequests));
    for i = 1:size(idRequests,2)        
        APs(i) = compAP(G(idRequests(i),:),idRequests(i),groundtruth(i,:));
%         fprintf(1, '%d: %f Ap\n', i, APs(i));
    end
    mAP = mean(APs);

end

