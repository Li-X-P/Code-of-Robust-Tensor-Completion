function [N,Omega_Clear,scale] = Max_D_Find_N(R_Omega,ip,scale)
t_m_n = R_Omega(R_Omega~=0);
M_t = median(t_m_n);
scale = min([scale ip*1.4815*median(abs(t_m_n - M_t))]);
ONE_1=ones(size(R_Omega));
ONE_1(abs(R_Omega)-scale<0)=0;
N = R_Omega.*ONE_1;
Omega_Clear = ones(size(R_Omega)) - ONE_1;
end