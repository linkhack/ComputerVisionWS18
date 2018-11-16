%image number & read images
imgNum = './res/00149';
R = imread(strcat(imgNum, 'v_R.jpg'));
G = imread(strcat(imgNum, 'v_G.jpg'));
B = imread(strcat(imgNum, 'v_B.jpg'));

OFFSET = 15;

%CORR2 results for each shift
GCorr2Vals = zeros (OFFSET * 2 + 1, OFFSET * 2 + 1);
BCorr2Vals = zeros (OFFSET * 2 + 1, OFFSET * 2 + 1);

% best shift amount found in above matrices
bestGShift = zeros (1, 2);
bestBShift = zeros (1, 2);

%find all possible corr2 values for
%comparing R against different B & G shifts
for i = -OFFSET:1:OFFSET
    for j = -OFFSET:1:OFFSET
        G2 = circshift(G, [i, j]);
        B2 = circshift(B, [i, j]);
        GCorr2Vals(i + OFFSET + 1, j + OFFSET + 1) = corr2(R, G2);
        BCorr2Vals(i + OFFSET + 1, j + OFFSET + 1) = corr2(R, B2);
    end
end

%pick the best shifts
bestG = 0;
bestB = 0;
for i = 1:1:31
    for j = 1:1:31
        if (GCorr2Vals(i,j) > bestG)
            bestGShift = [i - (OFFSET + 1), j - (OFFSET + 1)];
            bestG = GCorr2Vals(i,j);
        end
        
        if (BCorr2Vals(i,j) > bestB)
            bestBShift = [i - (OFFSET + 1), j - (OFFSET + 1)];
            bestB = BCorr2Vals(i,j);
        end
    end
end

%apply best shift
G2 = circshift(G, bestGShift);
B2 = circshift(B, bestBShift);

%fprintf("G: (" + num2str(bestGShift(1, 1)) + ", " + num2str(bestGShift(1, 2)) + ")\n");
%fprintf("B: (" + num2str(bestBShift(1, 1)) + ", " + num2str(bestBShift(1, 2)) + ")\n");

%output image
IMAGE = cat(3, R, G2, B2);
imshow(IMAGE);