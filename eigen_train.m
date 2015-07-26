function [mean_vec, eig_vec] = eigen_train(train_set, dim)
mean_vec = mean(train_set);
train_set = bsxfun(@minus, train_set, mean_vec);
[~, ~, eig_vec] = svds(train_set, dim);  
end