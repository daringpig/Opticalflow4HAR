close all
clear 
clc

img = imread('pictures/test1.jpg');
imgthr = 1-im2bw(img, 0.8);

bbox = calcBoundingBox(frameLogical);

boxdis = insertShape(frameGray, 'Rectangle', bbox, 'Color', 'green');

figure;
subplot(1, 2, 1), imshow(frameLogical, []);
subplot(1, 2, 2), imshow(boxdis, []);
