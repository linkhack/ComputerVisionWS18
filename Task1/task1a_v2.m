% this version first compares G against R and modifies it
% then checks B against result of G2+R
% the results are pretty equal to the previous version 

%image number & read images
imgNum = '00398';
R = imread(['./res/', imgNum, 'v_R.jpg']);
G = imread(['./res/', imgNum, 'v_G.jpg']);
B = imread(['./res/', imgNum, 'v_B.jpg']);

%%output base
%imwrite(cat(3, R, G, B), join([imgNum, '_base', '.PNG']));

OFFSET = 15;

%CORR2 results for each shift
GCorr2Vals = zeros (OFFSET*2+1, OFFSET*2+1); %offset value * 2 (2 directions) + 1 (no offset)
BCorr2Vals = zeros (OFFSET*2+1, OFFSET*2+1);
% best shift amount found in above matrices
bestGShift = zeros (1, 2); 
bestBShift = zeros (1, 2);

%find all possible corr2 values for
%comparing R against different G shifts
for i = -OFFSET:1:OFFSET
    for j = -OFFSET:1:OFFSET        
        G2 = circshift(G, [i, j]);        
        GCorr2Vals(i + OFFSET + 1, j + OFFSET + 1) = corr2(R, G2);        
    end
end

%go through the created matrix and find the best shift for G
bestG = 0;
for i = 1:1:(OFFSET * 2 + 1)
    for j = 1:1:(OFFSET * 2 + 1)
        if (GCorr2Vals(i,j) > bestG)
            bestGShift = [i - (OFFSET + 1), j - (OFFSET + 1)];
            bestG = GCorr2Vals(i,j);
        end       
    end
end

%apply best shift
G2 = circshift(G, bestGShift);

%find all possible corr2 values for
%comparing R+G2 against different B shifts
for i = -OFFSET:1:OFFSET
    for j = -OFFSET:1:OFFSET                
        B2 = circshift(B, [i, j]);        
        BCorr2Vals(i + OFFSET + 1, j + OFFSET + 1) = corr2(R, B2) + corr2(G2, B2);
    end
end

%go through the created matrix and find the best shift for B
bestB = 0;
for i = 1:1:(OFFSET * 2 + 1)
    for j = 1:1:(OFFSET * 2 + 1)
        if (BCorr2Vals(i,j) > bestB)
            bestBShift = [i - (OFFSET + 1), j - (OFFSET + 1)];
            bestB = BCorr2Vals(i,j);
        end
    end
end
%apply best shift
B2 = circshift(B, bestBShift);

%fprintf("G: (" + num2str(bestGShift(1, 1)) + ", " + num2str(bestGShift(1, 2)) + ")\n");
%fprintf("B: (" + num2str(bestBShift(1, 1)) + ", " + num2str(bestBShift(1, 2)) + ")\n");

%output image
IMAGE = cat(3, R, G2, B2);
imshow(IMAGE);

%write on disk:
%imwrite(IMAGE, join([imgNum, '_v2', '.PNG']));