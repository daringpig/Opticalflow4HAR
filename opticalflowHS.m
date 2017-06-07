% Simulink ?viptrafficof

close all
clear
clc

vidReader = VideoReader('videos/test6.mp4');

opticFlow = opticalFlowHS('Smoothness', 1, 'MaxIteration', 10, 'VelocityDifference', 0);
% opticFlow = opticalFlowLK('NoiseThreshold',0.009);

% size
width = vidReader.Width;
height = vidReader.Height;

opticalBG = ones(height, width) * 255;
frameLogical = ones(height, width);

% parameters
Threshold = 0.02;
CloseSize = 8;

% Boundingbox analysis
blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
     'AreaOutputPort', false, 'CentroidOutputPort', false, ...
     'MinimumBlobArea', 800, 'MaximumCount', 1);

while hasFrame(vidReader)
    
    frameRGB = readFrame(vidReader);
	frameGray = rgb2gray(frameRGB);
    
    
	% Compute optical flow & BG 
 	flow = estimateFlow(opticFlow, frameGray); 
    subplot(2, 2, 2), imshow(opticalBG), title('frameOpticalFlow');
	hold on
	plot(flow, 'DecimationFactor', [2 2], 'ScaleFactor', 20)
	drawnow
	hold off 
    
    
    % Compute and draw the logicalFrame
    for i = 1:height
        for j = 1:width
            if(sqrt(flow.Vx(i, j)^2 + flow.Vy(i, j)^2) <= Threshold)
                frameLogical(i, j) = 0;
            else
                frameLogical(i, j) = 255;
            end
        end
    end
    se = strel('square', CloseSize);
    frameLogical = logical(frameLogical);
    % Close operation
    frameLogical = imclose(frameLogical, se);
    % subplot(2, 2, 3), imshow(frameLogical), title('logicalFrame');
    
 
    % Draw bounding boxes
    bbox = step(blobAnalysis, frameLogical);
    % bbox = calcBoundingBox(frameLogical);
    % frameRGB = insertShape(frameRGB, 'Rectangle', bbox, 'Color', 'green');
    % subplot(2, 2, 1), imshow(frameRGB), title('frameRGB');
    
    frameData = mat2gray(ones(height, width));
    if size(bbox, 1) == 1
        gravityCenter = [bbox(1, 1) + bbox(1, 3)/2, bbox(1, 2) + bbox(1, 4)/2];
        frameData(gravityCenter(1, 2), gravityCenter(1, 1)) = 0.3;
         for i = 0:5:360
             [x, y] = calEveryCandidateByDegree(flow, bbox, gravityCenter, i);
             frameData(y, x) = 0;
         end
    end
    subplot(2, 2, 4), imshow(frameData, []);
end