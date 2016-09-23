function [F, S] = compute_cnn(I, net, step)

    if exist('step', 'var') == 0
        step = 20;
    end

    [h, w, c] =size(I);
    n = length(net.layers);
    
    im = single(I);
    
    F = [];
    S = [];
    
    % convert grey to rgb
    if c == 1
        im_ = single(zeros(h, w, 3));
        im_(:,:,1) = single(im);
        im_(:,:,2) = single(im);
        im_(:,:,3) = single(im);
        im = im_;
        clear im_;
    end

    dh = max(h-227, 1);
    dw = max(w-227, 1);

    for u = 1:step:dh
        for v=1:step:dw
            I = im(u:u+226,v:v+226,:);

%             I = I - net.meta.normalization.averageImage;
            % use this for older version of matconvnet
            I = I - net.normalization.averageImage;

            res = vl_simplenn(net, im);
            [x,y,d] = size(res(n).x);
            Ss = zeros(d, x*y);
            Fs = zeros(3, x*y);
            k = 1;
            for j=1:y
                for i=1:x
                    Ss(:, k) = reshape(res(n).x(i,j,:), [], 1);
                    Fs(:, k) = [j; i; 1];
                    k = k+1;
                end
            end

            S = [S, Ss];
            F = [F, Fs];
        end
    end


end
