clear;clc;
a=input('pls enter a lower bound on the integral of the objective function ');
b=input('pls enter a upper bound on the integral of the objective function ');
Eps=input('pls define the precision of Romberg algorithm: eps= ');
s2 = input('pls enter the integrated objective function: ', 's');
s1 = '@(x)';
S = strcat(s1,s2);
f = str2func(S);    
fprintf('The result of integrating the function of %s from %g to %g  \n',s2,a,b);
%Initialise n (n > 1 is necessary to calculate the error)
n = 2;
%Loop termination conditions
done = 0;
while done ~= 1
%Generate solution matrix
r = zeros(n,n);
%Calculate the initial matrix elements
h = b-a;
r(1,1) = (h/2)*(f(a)+f(b)); %Calculate T00 (the first step of the trapezoidal recursion formula calculates the elements of the first column and first row)
for k=2:n %k is number of rows
    h = h/2;
    for i = 1:2^(k-2)
        r(k,1) = r(k,1)+f(a+(2*i-1)*h);
    end
    r(k,1) = r(k-1,1)/2+h*r(k,1);%Step 2 of the trapezoidal recursion formula, calculating the elements of the first column
    for j=2:k  %j is number of lines
        r(k,j) = r(k,j-1)+(r(k,j-1)-r(k-1,j-1))/(4^(j-1)-1);
        %%Calculating the value of Tmk (step 3 of the trapezoidal recursion formula)
    end
end
Error = abs(r(k,j-1)-r(k,j));%cal the error
%Prevent too many trapezoidal recursions, set upper recursion limit, lower accuracy limit
if n>= 12 && Error >= 1e3*Eps
    disp('The trapezoidal recursion of the function being integrated converges slowly, check the function');
    return
end
% termination condition of loop 
if Error <= Eps
    done = 1;
else
    done = 0;
    n=n+1;
end
end
disp(r);
disp('The integration values with the accuracy requirements are');
disp(r(k,j));
disp('let us verify that the function is not a bad function');
%The definition of the bad function is obtained by Romberg's actual calculation of the convergence order of the columns of the trapezoidal recursion table, which differs from the theory
for c=1:j
m=input('Please enter the column to be validated');
rate=rate_of_convergence(r(:,m),r(k,j));
disp(['The theoretical convergence order of the column is',num2str(2*(m-1)+2)]);
end