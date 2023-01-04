clear 
close all
addpath TensorRing
addpath tensorlab



Ui = TR_Initialization(randn(10,10,10), [2,2,2]);
Data = Ui2U(Ui);


ObserveRatio = 0.5;
Data_Size = size(Data);
Omega = zeros(Data_Size);
Omega(randsample(prod(Data_Size), fix(ObserveRatio*prod(Data_Size)))) = 1;



Data_Missing = reshape(Data.* Omega, Data_Size);


[noise,sigma_1] = Gaussian_noise(Data(logical(Omega)),"GM",3);

Noise = zeros(size(Data_Missing));
Noise(logical(Omega)) = noise;
% Data_Missing = imnoise(Data_Missing,'gaussian',0,0.01);
%
% Data_Missing = imnoise(Data_Missing,'gaussian',0,0.002);
% Data_Missing = imnoise(Data_Missing,'salt & pepper',0.1);


%% Complete Missing Data By TR
% TR Parameter
r = 2;
para_TR.robust = 1;
para_TR.Data_Size = Data_Size;
para_TR.max_iter= 100;
para_TR.disp = 1;
para_TR.ip = 3;
para_TR.r = ones(length(Data_Size), 1) * r;   % Tensor Ring Rank

%% TR Completion

tic
[Utr,loss,F_rec,S_rec] = Completion_TR3(Data_Missing+Noise, Omega, para_TR, Data);
time = toc;
Data_Recover_TR = reshape(Ui2U(Utr), Data_Size);

figure
plot(loss,'-k','Linewidth',1.2)
xlabel('Iteration number','FontSize',15)
ylabel('Loss','FontSize',15)
grid on
figure_setting(1.5, 14, 500, 300)


iter = 100;
for i = 1 : iter
    for j = 1 : 1000
        S = S_rec{i};
        s = T2V(S);
        SS(j,i) = s(j);
    end
end

figure
for j = 1 : 1000
    plot(SS(j,:),'-k','Linewidth',1.2)
    hold on
end

xlabel('Iteration number','FontSize',13)
ylabel('$\bf s_{i,j,k}$','Interpreter','latex','FontSize',13)
grid on
figure_setting(1.5, 14, 500, 300)

for i = 1 : iter
    for j = 1 : 40
        F = F_rec{i};
        F = F{1};
        f = T2V(F);
        FF(j,i) = f(j);
        %         F = F_rec{i};
        %         F = F{1};
        %         f = T2V(F);
    end
end
figure
for j = 1 : 40
    plot(FF(j,:),'-k','Linewidth',1.2)
    hold on
end
xlabel('Iteration number','FontSize',13)
ylabel('$\bf (y_1)_{i,j,k}$','Interpreter','latex','FontSize',13)
grid on
figure_setting(1.5, 14, 500, 300)

for i = 1 : iter
    for j = 1 : 40
        F = F_rec{i};
        F = F{2};
        f = T2V(F);
        FF(j,i) = f(j);
        %         F = F_rec{i};
        %         F = F{1};
        %         f = T2V(F);
    end
end
figure
for j = 1 : 40
    plot(FF(j,:),'-k','Linewidth',1.2)
    hold on
end
xlabel('Iteration number','FontSize',13)
ylabel('$\bf (y_2)_{i,j,k}$','Interpreter','latex','FontSize',13)
grid on
figure_setting(1.5, 14, 500, 300)


for i = 1 : iter
    for j = 1 : 40
        F = F_rec{i};
        F = F{3};
        f = T2V(F);
        FF(j,i) = f(j);
        %         F = F_rec{i};
        %         F = F{1};
        %         f = T2V(F);
    end
end
figure
for j = 1 : 40
    plot(FF(j,:),'-k','Linewidth',1.2)
    hold on
end
xlabel('Iteration number','FontSize',13)
ylabel('$\bf (y_3)_{i,j,k}$','Interpreter','latex','FontSize',13)
figure_setting(1.5, 14, 500, 300)