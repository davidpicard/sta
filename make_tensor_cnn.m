
% global configuration variables
glob

% load datasets
[train_list, test_list] = load_set(train_dir, test_dir);

for layer=[10 12]

    % reload cnn model
    net = load(netfile);
    net.layers = net.layers(1:layer);

    [F, S] = compute_cnn(load_image(train_list(1).name), net);
    dim = size(S, 1);

    if dico==1
    le = length(train_list);
    X = zeros(dim,100*le);
    if xdisplay == 1
        h = waitbar(0, 'computing cnn');
    end
    for i=1:le
        I = load_image(train_list(i).name);
        [F, S] = compute_cnn(I, net);
        n = randperm(length(F));
        n = n(1:100);
        id = [(i-1)*100+1:(i*100)];
        X(:, id) = S(:,n);
        if xdisplay == 1
            waitbar(i/length(train_list), h, sprintf('compute cnn %d/%d', i, length(train_list)));
        end
    end
    if xdisplay == 1
        close(h);
    end
    X = single(X);

    % pca
    p = 56;
    n = size(X, 2);
    mu = mean(X, 2);
    X = (X - mu*ones(1,n));
    co = X*X';
    [P V] = eigs(double(co), p);
    P = single(P);
    X = P'*X;
    X = normc(X);

    % kmeans
    dim = size(X, 1);
    k = 8;
    D = vl_kmeans(X, k);

    end

    for dec=0:1:10
        tic;
        % compute sta for RN projection
        if xdisplay == 1
            h = waitbar(0, 'computing tensors');
        end
        le = length(train_list);
        X = zeros(k*k*dim*dim, le, 'single');
        for i=1:le
            I = load_image(train_list(i).name);
            [F, S] = compute_cnn(I, net);
            S = single(S);
            n = size(S, 2);
            S = P'*(S - mu*ones(1,n));
            S = normc(S);

            T = zeros(k*k*dim*dim, 1);
            sizes = unique(F(3, :));
            for sc=sizes
                id = F(3,:)==sc;
                Fsc = F(:,id);
                Xsc = S(:,id);
                nb = [0:floor(dec*sc/sizes(1))];
                T = T + tsa(Xsc, Fsc, D, nb, 1);
            end
            X(:,i) = T;
            if xdisplay == 1
                waitbar(i/le, h, sprintf('compute tensors %d/%d', i, le));
            end
        end
        if xdisplay == 1
            close(h);
        end
        Xn = normc(X);
        G = Xn'*Xn;
        [V, L] = eigs(double(G), rn_dim);
        RN = single(diag(1./diag(L.^1.5))*V'*Xn');
%         [U, L, V] = svds(double(Xn), rn_dim);
%         L = 1./L;
%         RN = single(U');
        
        
        % compute test sta
        if xdisplay == 1
            h = waitbar(0, 'computing tensors');
        end
        le = length(test_list);
        X = zeros(k*k*dim*dim, le, 'single');
        for i=1:le
            I = load_image(test_list(i).name);
            [F, S] = compute_cnn(I, net);
            S = single(S);
            n = size(S, 2);
            S = P'*(S - mu*ones(1,n));
            S = normc(S);

            T = zeros(k*k*dim*dim, 1);
            sizes = unique(F(3, :));
            for sc=sizes
                id = F(3,:)==sc;
                Fsc = F(:,id);
                Xsc = S(:,id);
                nb = [0:floor(dec*sc/sizes(1))];
                T = T + tsa(Xsc, Fsc, D, nb, 1);
            end
            X(:,i) = T;
            if xdisplay == 1
                waitbar(i/le, h, sprintf('compute tensors %d/%d', i, le));
            end
        end
        if xdisplay == 1
            close(h);
        end

        Xn = normc(X);
        Xn = Xn;

        map = make_bench(Xn, test_list);
        to = toc;
        fprintf(1,'CNN TSA: layer = %d, dec = %d , map = %f in %fs\n', layer, dec, map, to);
    end

end
