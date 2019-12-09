tic;
for i = 1:10
    [a,b,c] = checkCondsDet(state,input);
end
toc;

tic;
for i = 1:10
    d = checkFullCond(state,input);
end
toc;