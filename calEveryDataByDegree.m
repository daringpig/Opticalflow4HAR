function Z = calEveryDataByDegree(flow, bbox, centerpoint, degree)

Z = [];
num =0;

threshold = 0.02;

i = centerpoint(1, 1);
j = centerpoint(1, 2);
dx = 1;
dy = tan(degree/180*pi);

while inBBox(bbox, i, j)
    if (flow.Vx(j, i)^2 + flow.Vy(j, i)^2) >= threshold && num < 3
        dis = sqrt(double((i - centerpoint(1, 1))^2 + (j - centerpoint(1, 2))^2));
        Z = [Z flow.Vx(j, i) flow.Vy(j, i) dis];
        num = num + 1;
    end
    i = i + dx;
    j = j + dy;
end

if num < 3
    for k = 1:3-num
        Z = [Z 0 0 0];  
    end
end

% ---------------------------
% ---------------------------
function flag = inBBox(bbox, i, j)

x = bbox(1, 1);
y = bbox(1, 2);
w = bbox(1, 3);
h = bbox(1, 4);
if i < x + w && i >= x && j >= y && j < y + h
    flag = 1;
else 
    flag = 0;
end