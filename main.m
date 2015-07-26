clear; close all; clc;
%% parameter setting
src_fmt = 'src-c%d-f%d.png';
bg_fmt = 'bg-c%d-f%d.png';

data_folder = 'data/';
ftrain = 0:99; % train image range
fsrc = 0:794; % source iamge range
crange = 0:4; % camera range
dim = 3; % eigenvector dimension
thre = 0.2; % threshold

train_folder = [data_folder, 'train/src/'];
src_folder = [data_folder, 'src/'];
bg_folder = [data_folder, 'bg/ext/'];
model_fmt = [data_folder, 'train/eigen_model_c%d_dim%d.mat']; 

for c = crange
    src_name = sprintf(src_fmt, c, fsrc(1));
    im = imread([src_folder, src_name]);
    [h, w, d] = size(im);

    %% model train
    model_name = sprintf(model_fmt, c, dim);
    clear model;
    if(exist(model_name, 'file'))
        load(model_name);
    else
        ntrain = length(ftrain);
        train_set = zeros(ntrain, h*w*d);
        for i = 1:ntrain
            f = ftrain(i);
            src_name = sprintf(src_fmt, c, f);
            im = im2double(imread([train_folder, src_name]));
            train_set(i, :) = im(:);
        end
        [model.mean, model.eig] = eigen_train(train_set, dim);
        save(model_name, 'model');
    end

    %% background subtract
    for f = fsrc
        fprintf('processing camera: %d, frame: %d\n', c, f);
        src_name = sprintf(src_fmt, c, f);
        im = im2double(imread([src_folder, src_name]));
        pix = im(:)';
        im_proj = project_eig(pix, model.mean, model.eig);
        im_diff = abs(pix-im_proj);
        im_diff = reshape(im_diff, h, w, d);
        im_diff = max(im_diff, [], 3);
        im_diff = im_diff > thre;
        bg_name = sprintf(bg_fmt, c, f);
        imwrite(im2uint8(im_diff), [bg_folder, bg_name]);
    end
end