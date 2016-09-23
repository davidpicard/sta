
% recompute codebook switch
global dico;
dico = 1;

if dico == 1
    clear all;
    close all;
    dico = 1;
end

% display waitbars
global xdisplay;
xdisplay = 1;

% directories with images
global train_dir;
global test_dir;
train_dir = '/home/picard/Bases/holidays/512jpg';
test_dir = '/home/picard/Bases/holidays/512jpg';

% cnn model file
global netfile;
netfile = '/home/picard/Bases/bnf_bench/imagenet-caffe-alex.mat';

% max number of train.test file
global num_train;
num_train = 1500;
global num_test;
num_test = 1500;

% output dimension of rotation whitening
global rn_dim;
rn_dim = 256;
