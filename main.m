clear; close all; clc;
%% parameter setting
src_fmt = 'src-c%d-f%d.png';
bg_fmt = 'bg-c%d-f%d.png';
data_folder = 'data/';
train_folder = [data_folder, 'train/src/'];
src_folder = [data_folder, 'src/'];
bg_folder = [data_folder, 'bg/'];
model_fmt = [data_folder, 'train/eigen_model_c%d.mat']; 

ftrain = 1:1:100; % training image range
fsrc = 0:300; % soruce iamge range
crange = 0:2; % camera_range
block_size = 100; %don't change this
dim = 1; %eigenvector dimension
thre = 0.15; %threshold: range [0, 1]

for c = crange
    src_name = sprintf(src_fmt, c, fsrc(1));
    im = imread([src_folder, src_name]);
    [h, w, ~] = size(im);
    yset = 1:block_size:h;
    xset = 1:block_size:w;
    if(yset(end) ~= h)
        yset = [yset, h];
    end
    if(xset(end) ~= w)
        xset = [xset, w];
    end
    ny = length(yset);
    nx = length(xset);

    %% model train
    model_name = sprintf(model_fmt, c);
    clear model;
    if(exist(model_name, 'file'))
        load(model_name);
    else
        ntrain = length(ftrain);
        train_im = cell(1, ntrain);
        for i = 1:ntrain
            f = ftrain(i);
            src_name = sprintf(src_fmt, c, f);
            im = im2double(rgb2gray(imread([train_folder, src_name])));
            train_im{i} = im;
        end
        model = repmat(struct('mean', zeros(0,0), 'eig', zeros(0, 0)), ny-1, nx-1);
        for iy = 1:ny-1
            for ix = 1:nx-1
                fprintf('train block y: %d/%d, x: %d/%d\n', iy, ny-1, ix, nx-1);
                ymin = yset(iy); ymax = yset(iy+1);
                xmin = xset(ix); xmax = xset(ix+1);
                train_set = zeros(length(ftrain), (ymax-ymin)*(xmax-xmin));
                for i = 1:ntrain
                    tmp = train_im{i}(ymin:ymax-1, xmin:xmax-1);
                    train_set(i, :) = tmp(:);
                end
                [model(iy, ix).mean, model(iy, ix).eig] = eigen_train(train_set, dim);
            end
        end
        save(model_name, 'model');
    end

    %% background subtract
    for f = fsrc
        fprintf('processing camera: %d, frame: %d\n', c, f);
        src_name = sprintf(src_fmt, c, f);
        im = im2double(rgb2gray(imread([src_folder, src_name])));
        im_project = zeros(size(im));
        for iy = 1:length(yset)-1
            for ix = 1:length(xset)-1
                ymin = yset(iy); ymax = yset(iy+1);
                xmin = xset(ix); xmax = xset(ix+1);
                pix = im(ymin:ymax-1, xmin:xmax-1);
                pix = pix(:)';
                im_proj = project_eig(pix, model(iy,ix).mean, model(iy, ix).eig);
                im_proj = abs(pix-im_proj) > thre;
                im_project(ymin:ymax-1, xmin:xmax-1) = reshape(im_proj, ymax-ymin, xmax-xmin);
            end
        end
        bg_name = sprintf(bg_fmt, c, f);
        imwrite(im_project, [bg_folder, bg_name]);
    end
end