function [train_list, test_list] = load_set(train_dir, test_dir)

    global num_train;
    global num_test;
    
    clear train_list;
    list = dir(strcat(train_dir,'/*.jpg'));
    for i=1:min(length(list), num_train)
        t.name = strcat(train_dir, '/', list(i).name);
        train_list(i) = t;
    end

    clear test_list;
    list = dir(strcat(test_dir,'/*.jpg'));
    for i=1:min(length(list), num_test)
        t.name = strcat(test_dir, '/', list(i).name);
        test_list(i) = t;
    end

end
