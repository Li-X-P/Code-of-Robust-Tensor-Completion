clear; close all; warning off;
addpath Data_Source
addpath TensorRing
addpath tensorlab

samplingModel = 1;
noiseModel = 1;
%% Original Data
Data = imread('Scenery.jpg');
Data = double(Data)./255;

%% Randomsampling Missing Entries
Data_Size = size(Data);
if samplingModel ==1
    ObserveRatio = 0.5;
    Omega = zeros(Data_Size);
    Omega(randsample(prod(Data_Size), fix(ObserveRatio*prod(Data_Size)))) = 1;
else
    Omega = mask();
end

Data_Missing = Data.* Omega;

if noiseModel ==1
    Data_Missing = imnoise(Data_Missing,'gaussian',0,0.002);
    Data_Missing = imnoise(Data_Missing,'salt & pepper',0.2);
else
    Data_Missing = imnoise(Data_Missing,'gaussian',0,0.01);
end

%% Complete Missing Data By TR
% TR Parameter
Reshape_Dim   = [16,16,16,16,3]; % building
r  = 13;
para_TR.robust = 1;
para_TR.Data_Size = Data_Size;

para_TR.disp = 1;
para_TR.ip = 3;
para_TR.r = ones(length(Reshape_Dim), 1) * r;   % Tensor Ring Rank

%% RTR Completion
para_TR.max_iter= 50;
tic
Utr = Completion_TR3(reshape(Data_Missing, Reshape_Dim), reshape(Omega, Reshape_Dim), para_TR, Data);
time = toc;
Data_Recover_TR = reshape(Ui2U(Utr), Data_Size);
fprintf('psnr is %d \n', psnr(Data_Recover_TR, Data));
fprintf('ssim is %d \n', ssim(Data_Recover_TR, Data));
%% Plot recovered images
hs = self_subplot(1, 3, [0.05, 0.05], [0.05, 0.05], [0.01, 0.01]);
axes(hs(1));
imshow(uint8(Data.*255));
title('Original','fontname','Times New Roman');
axes(hs(2));
imshow(uint8(Data_Missing.*255));
title('Original','fontname','Times New Roman');
axes(hs(3));
imshow(uint8(Data_Recover_TR.*255));
title('Recovered','fontname','Times New Roman');

