%% performance test
tic
for i = 1:2400
    strcat('aksjdlkasd', i, 'jkasdjk');
end
toc

tic
for i = 1:2400
    ['aksjdlkasd' i 'jkasdjk'];
end
toc

tic
prealloc = zeros(2600,128);
for i = 1:2600
    prealloc(i,:) = 1:128;
end
toc

tic
noalloc = [];
for i=1:2600
    noalloc = [noalloc,1:128];
end
toc