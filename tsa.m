function V = tsa(X, F, D, nb, step, alpha)

    if exist('alpha', 'var') == 0
        alpha = 0.1;
    end

    [unused, m] = size(X);
    [d, k] = size(D);

    [unused, ids] = min(ones(k, 1)*sum(X.*X, 1) + sum(D.*D, 1)'*ones(1, m) - 2*D'*X);
    for c=1:k
        sel = ids==c;
        mc = sum(sel);
        % centering
        X(:,sel) = X(:,sel) - D(:,c)*ones(1,mc);
    end
    X = normc(X);
    
    T = zeros(k,k,d*d, 'single');
    for n=nb
        sel = F(2,:)+step*n == circshift(F(2,:), [0, -n]);
        for i=1:k
            idi = ids==i & sel;
            for j=1:k
                idj = ids==j;
                idi1 = idi & circshift(idj, [0, -n]);
                idj1 = idj & circshift(idi, [0, n]);
                Xi = X(:,idi1);
                Xj = X(:,idj1);
                Tij = Xi*Xj';
                T(i,j,:) = reshape(T(i,j,:), d*d,1) + reshape(Tij, d*d, 1);
            end
        end
    end
    
    c = 1;
    Xi = zeros(k,d*d);
    Xij = zeros(k*(k+1)/2, d*d);
    for i=1:k
        Xi(i,:) = T(i,i,:);
        for j=1:k
            if i~=j
                Xij(c,:) = T(i,j,:);
                c = c+1;
            end
        end
    end
    
    Xi = sign(Xi).*(abs(Xi).^alpha);
    Xi = normc(Xi);
    Xij = sign(Xij).*(abs(Xij).^alpha);
    Xij = normc(Xij);
    V = [reshape(Xi, prod(size(Xi)), 1) ; reshape(Xij, prod(size(Xij)), 1)];
end
