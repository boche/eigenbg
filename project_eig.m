function mat_proj = project_eig(m, mean, eig)
    mat_proj = (m - mean) * eig * eig' + mean;
end