function [rate] = rate_of_convergence(r,x)
%The function of this subfunction is to calculate the convergence order 
n=size(r,1);
rate=zeros(n-1,1);
for i=1:1:n-1
rate(i,1)=log((r(i,1)-x)/(r(i+1,1)-x))/log(2);
end
disp(rate);
end

