%% When using the code, please cite the following paper:
% Q. Liu, X.P. Li, H. Cao and Y-T. Wu, "From simulated to visual data: A robust low-rank tensor completion approach 
% using lp-regression for outlier resistance", IEEE Transactions on Circuits and Systems for Video Technology, 2021.

% Copyright @ Xiao Peng Li, 2021
%%
clear all;clc; close all; warning off;
addpath Data_Source
addpath TensorTrain
addpath tensorlab

%% Original Data
Data = imread('windows.jpg');
Data = double(Data);

%% Randomsampling Missing Entries
ObserveRatio = 0.7;
Data_Size = size(Data);
Omega = zeros(Data_Size);
Omega(randsample(prod(Data_Size), fix(ObserveRatio*prod(Data_Size)))) = 1;
Data_Missing = reshape(T2V(Data).* T2V(Omega), Data_Size);

noisy_image = imnoise(Data_Missing./255,'salt & pepper', 0.2);
figure()
imshow(uint8(noisy_image.*255));

%% Complete Missing Data By TT

para_TT.Data_Size = Data_Size;
para_TT.max_tot = 10^-4;   
para_TT.max_iter= 10;     
para_TT.disp = 1;
para_TT.r = [10 2]; 
para_TT.p = 1;

% TT Completion
Utr = Completion_TT(reshape(noisy_image, Data_Size), reshape(Omega, Data_Size), para_TT, Data);
Data_Recover_TT = reshape(Ui2U(Utr), Data_Size);

% Plot recovered images
figure()
imshow(uint8(Data_Recover_TT.*255));
psnr(Data_Recover_TT, Data./255)
ssim(Data_Recover_TT, Data./255)
