%image number & read images
imgNum = './res/00125';
R = imread(strcat(imgNum, 'v_R.jpg'));
G = imread(strcat(imgNum, 'v_G.jpg'));
B = imread(strcat(imgNum, 'v_B.jpg'));

GCorr2Vals = zeros (31, 31);
BCorr2Vals = zeros (31, 31);
bestG = 0;
bestB = 0;
bestGShift = zeros (1, 2);
bestBShift = zeros (1, 2);

%find all possible corr2 values for
%comparing R against different B & G shifts
for i = -15:1:15
    for j = -15:1:15        
        G2 = circshift(G, [i, j]);
        B2 = circshift(B, [i, j]);
        GCorr2Vals(i + 16, j + 16) = corr2(R, G2);
        BCorr2Vals(i + 16, j + 16) = corr2(R, B2);
    end
end

%pick the best shifts
for i = 1:1:31
    for j = 1:1:31
        if (GCorr2Vals(i,j) > bestG)
            bestGShift = [i - 16, j - 16];
            bestG = GCorr2Vals(i,j);
        end
        
        if (BCorr2Vals(i,j) > bestB)
            bestBShift = [i - 16, j - 16];
            bestB = BCorr2Vals(i,j);
        end
    end
end

%apply best shift
G2 = circshift(G, bestGShift);
B2 = circshift(B, bestBShift);

fprintf("G: (" + num2str(bestGShift(1, 1)) + ", " + num2str(bestGShift(1, 2)) + ")\n");
fprintf("B: (" + num2str(bestBShift(1, 1)) + ", " + num2str(bestBShift(1, 2)) + ")\n");

%output image
IMAGE = cat(3, R, G2, B2);
imshow(IMAGE);