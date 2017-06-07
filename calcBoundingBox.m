function [rect] = calcBoundingBox(logicalImg)

s = size(logicalImg);
width = s(2);
height = s(1);

valW = zeros(1, width);
valH = zeros(1, height);

for i = 1:width
    for j = 1:height
        valW(i) = valW(i) + logicalImg(j, i);
        valH(j) = valH(j) + logicalImg(j, i);
    end
end

x = 0;
y = 0;
w = 0;
h = 0;
for i = 2:width
    if (valW(i-1) == 0) && (valW(i) ~= 0)
        if x == 0
            x = i;
        end
    end 
    if (valW(i-1) ~= 0) && (valW(i) == 0)
        w = i-x;
    end 
end

for i = 2:height
    if (valH(i-1) == 0) && (valH(i) ~= 0)
        if y == 0
            y = i;
        end
    end 
    if (valH(i-1) ~= 0) && (valH(i) == 0)
        h = i-y;
    end 
end

% figure;
% subplot(1, 2, 1), plot(valW);
% subplot(1, 2, 2), plot(valH);

rect = [x, y, w, h];