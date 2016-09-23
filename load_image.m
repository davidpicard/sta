function im = load_image(name)

    I = imread(name);
    [h, w, c] = size(I);
    if c == 1
        I = repmat(I, [1, 1, 3]); 
        size(I)
    end
    dim = 256;
    if h < w
        I = imresize(I, [dim, w/h*dim]);
    else
        I = imresize(I, [h/w*dim, dim]);
    end
%     I = imresize(I, [dim, dim]);
    im = single(I);
end