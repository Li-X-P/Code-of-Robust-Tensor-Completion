
clear; close all; warning off;
addpath Data_Source
addpath TensorRing
addpath tensorlab

noiseModel = 1;
%% Original Data
Data = load('akiyo.mat');
Data = Data.akiyo;
frame = 1:1:10;
Data = Data(:,:,frame);

%% Randomsampling Missing Entries
ObserveRatio = 0.5;
Data_Size = size(Data);
Omega = zeros(Data_Size);
Omega(randsample(prod(Data_Size), fix(ObserveRatio*prod(Data_Size)))) = 1;

Data_Missing = Data.* Omega;

if noiseModel ==1
    Data_Missing = imnoise(Data_Missing,'gaussian',0,0.002);
    Data_Missing = imnoise(Data_Missing,'salt & pepper',0.2);
    r  = 18;
else
    Data_Missing = imnoise(Data_Missing,'gaussian',0,0.01);
    r  = 14;
end

%% Complete Missing Data By TR
% TR Parameter
Reshape_Dim   = [16,18,16,22,10];
para_TR.robust = 1;
para_TR.Data_Size = Data_Size;
para_TR.max_iter= 30;
para_TR.disp = 1;
para_TR.ip = 3;
para_TR.r = ones(length(Reshape_Dim), 1) * r;


%% TR Completion
tic
Utr = Completion_TR3(reshape(Data_Missing, Reshape_Dim), reshape(Omega, Reshape_Dim), para_TR, Data);
Data_Recover_TR = reshape(Ui2U(Utr), Data_Size);
toc
%%
for i =1 : size(Data_Recover_TR,3)
    figure(1)
    imshow(Data_Recover_TR(:,:,i))
    psnr(Data_Recover_TR(:,:,i),Data(:,:,i))
    %     ssim(Data_Recover_TR(:,:,i),Data(:,:,i))
    pause(0.1)
end


