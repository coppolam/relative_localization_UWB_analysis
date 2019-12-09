function symbolic_mat_print(filename,inputmat)
cellarr = cell(size(inputmat));
[rows,cols] = size(inputmat);

for i=1:numel(inputmat)
    cellarr{i} = char(inputmat(i));
end

file = fopen(filename,'w');
for i = 1:rows
    fprintf(file,'%s \x25A0',cellarr{i,1:cols});
    fprintf(file,'\n');
end

fclose(file);
end