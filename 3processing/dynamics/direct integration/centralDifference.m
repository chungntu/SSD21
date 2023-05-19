%--------------------------------------------------------------------------
% Hàm số giải phương trình vi phân bậc 2 của hệ dao động cưỡng bức
% sử dụng phương pháp sai phân hữu hạn (CENTRAL DIFFERENCE METHOD)
%--------------------------------------------------------------------------
function x = centralDifference(M,C,K,F,t,x0,xd0)
deltaT = t(2) - t(1);
xdd0 = inv(M)*(F(:,1)-C*xd0-K*x0);
% chuyển vị tại thời điểm t = -deltaT
x(:,1) = x0(:) - deltaT*xd0(:) + deltaT^2/2*xdd0(:);
% chuyển vị tại thời điểm t = 0
x(:,2) = x0(:);
% chuyển vị tại các thời điểm tiếp theo
Keff = M/(deltaT^2) + C/(2*deltaT);
a = M/(deltaT^2)-C/(2*deltaT);
b = K-2*M/(deltaT^2);
for j=3:length(t)
    x(:,j) = Keff\(F(:,j)-a*x(:,j-2)-b*x(:,j-1));
end
%--------------------------------------------------------------------------
