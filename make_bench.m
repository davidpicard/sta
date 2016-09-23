function mAP = make_bench(signatures, test_list)

% make_path;
    requests = [];
    num_test = length(test_list);
    for i = 1:num_test
        if(~isempty(strfind(test_list(i).name, '00.')))
            requests = [requests i];
        end
    end;

    groundtruth = false(length(requests),num_test);

    for i = 1:length(requests)
        j = requests(i);
        str = test_list(j).name;
        pos = strfind(str, '/');
        str = str(pos(length(pos))+1:end);
        name = test_list(j).name;
        pos = strfind(name, '/');
        name = name(pos(length(pos))+1:end);
        while(j <= num_test && strncmp(str, name, 4))
            groundtruth(i, j) = true;
            j = j+1;
            if j < num_test
                name = test_list(j).name;
                pos = strfind(name, '/');
                name = name(pos(length(pos))+1:end);
            end
        end
    end

    [mAP APs] = compMAP( signatures'*signatures , requests , groundtruth  );
%     disp(sprintf('mAP : %g',mAP));
end