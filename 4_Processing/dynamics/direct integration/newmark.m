%--------------------------------------------------------------------------
% Hàm số giải phương trình vi phân bậc 2 của hệ dao động
% sử dụng phương pháp Newmark
%--------------------------------------------------------------------------
function x = newmark(M,C,K,F,t,x0,xd0,algorithm)
deltaT = t(2) - t(1);
x(:,1) = x0; xd(:,1) = xd0; xdd(:,1) = inv(M)*(F(:,1)-C*xd(:,1)-K*x(:,1));
switch algorithm
    case 'average'
        gamma = 1/2; beta = 1/4;  % phương pháp gia tốc trung bình
    case 'linear'
        gamma = 1/2; beta = 1/6;  % phương pháp gia tốc tuyến tính
end
a1 = 1/(beta*deltaT^2)*M + (gamma/(beta*deltaT))*C;
a2 = 1/(beta*deltaT)*M + (gamma/beta-1)*C;
a3 = (1/(2*beta)- 1)*M + deltaT*(gamma/(2*beta)-1)*C;
Keff = K + a1;
for i = 1:length(t)-1
    p = F(:,i+1)+ a1*x(:,i) + a2*xd(:,i) + a3*xdd(:,i);
    x(:,i+1) = Keff\p;
    xdd(:,i+1) = (1/(beta*deltaT^2))*(x(:,i+1)-x(:,i))...
        -(1/(beta*deltaT))*xd(:,i)-((1/(2*beta))-1)*xdd(:,i);
    xd(:,i+1) = xd(:,i)+(1-gamma)*deltaT*xdd(:,i)+gamma*deltaT*xdd(:,i+1);
end
%--------------------------------------------------------------------------
