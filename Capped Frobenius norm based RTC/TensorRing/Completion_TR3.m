function [Utr,loss,F_rec,S_rec] = Completion_TR3(U_Omega, P_Omega, para, Data)
% U_Omega: I1 * I2 *... *In tensor with missing entries filled by 0
% P_Omega: I1 * I2 *... *In binary observation tensor
% para:    para.max_iter, para.max_tot, para.r
%
% Utr:     Decomposition term

% Initialization
Utr = TR_Initialization(U_Omega,  para.r);
d = length(para.r);
iter =0;
ip = para.ip;
Data_Size = para.Data_Size;
scale = 100;
if para.robust == 1
    [N,Omega_Clear] =  Max_D_Find_N(U_Omega,3,scale);
    for j = 1 : 2
        for i=1:d
            Utr{i} = Updata_U1(TensPermute(Omega_Clear.*P_Omega, i), Utr([i:d, 1:i-1]),TensPermute(U_Omega-N, i));
        end
    end
end
[loss,F_rec,S_rec] = deal([],[],[]);

%%
while( iter < para.max_iter)
    if para.robust == 1
        U_hat = reshape(Ui2U(Utr), size(U_Omega));
        R_Omega = (U_Omega - U_hat).*P_Omega ;
        [N,~,scale] = Max_D_Find_N(R_Omega,ip,scale);
        for i=1:d
            Utr{i} = Updata_U1(TensPermute(P_Omega, i), Utr([i:d, 1:i-1]),TensPermute(U_Omega - N, i));
        end
    else
        for i=1:d
            Utr{i} = Updata_U1(TensPermute(P_Omega, i), Utr([i:d, 1:i-1]),TensPermute(U_Omega, i));
        end
    end
    
    iter =iter+1;
    %%
    
    N_temp = N;
    N_L_index = find(abs(N_temp)>=scale);
    N_temp(N_L_index) = scale^2;
    
    loss(iter) = norm(T2V(reshape(U_Omega, Data_Size) - reshape(Ui2U(Utr).*P_Omega, Data_Size) - reshape(N.*P_Omega, Data_Size)))^2 + sum(T2V(reshape(N_temp.*P_Omega, Data_Size)));
    F_rec{iter} = Utr;
    S_rec{iter} = N;
    
    tot = norm(T2V(reshape(Ui2U(Utr), Data_Size) - Data))^2/prod(Data_Size);
    if para.disp ==1
        disp(['At iteration ', num2str(iter), ', MSE ', num2str(tot)]);
    end
    
end
end