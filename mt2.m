% Matlab Problemset 1
% Winter 2015 / 2016

clc

%% Problem 1
clear;

% Settings
n = 2000;
b0 = 1;
b1 = 1;
b = [b0 b1]';

% Simulate data
X = [ones(n,1) rand(n,1)];
lambda = exp(X*b);
Y = poissrnd(lambda);

% Moments
m1 = (exp(b0+b1) - exp(b0)) / b1;
m2 = (exp(2*(b0+b1)) - exp(2*b0)) / (2*b1);

% Unconditional mean
m1
mean(Y)

% Unconditional variance
m2 + m1 - m1^2
var(Y)

% Display commands
disp(['Theoretical mean:     ',num2str(m1)])
disp(['Empirical mean:       ',num2str(mean(Y))])

disp(['Theoretical variance: ',num2str(m2 + m1 - m1^2)])
disp(['Empirical variance:   ',num2str(var(Y))])


% Plot the likelihood surface
b0 = linspace(-1, 2, 20);
b1 = linspace(-1, 2, 20);
ll = zeros(size(b0, 2), size(b1, 2));

for i = 1:size(b0, 2)
    for j = 1:size(b1, 2)
        ll(i, j) = ll_poisson([b0(i); b1(j)], Y, X, true);
    end
end

surf(b0, b1, ll)



% Initial parameter vector
beta0 = zeros(2, 1);

% Optmizer settings
options = optimoptions(@fminunc, 'Algorithm', 'quasi-newton');

% Estimate model
[beta, fval, exitflag, output] = fminunc(@ll_poisson, beta0, options, Y, X, true);

% beta = parameter estimate
% fval = value of the objective function at the minimum
% exitflag = exit message which states whether the algorithm terminated,
% in general, exitflg > 0 means it converged
% output: further information concerning the algorithm....

% Gradient and Hessian
g = Gradp(@ll_poisson, beta, Y, X, false);
H = HessMp(@ll_poisson, beta, Y, X, true);

% Three differenct variance-covariance matrix estimators
cv1 = inv(H);                  % Inverse of the Hessian 
cv2 = inv(g'*g);               % Inverse of the OPG
cv3 = inv(H) * g'*g * inv(H);  % Sandwich estimator


% Standard errors
se = diag(cv3).^0.5;

% t-statistic
t = (beta-1) ./ se;

% p-value
p = 2*(1-normcdf(abs(t)));





%% Problem 2
clc
clear

% Load data
load('ss5')

% Dependent variable
Y = BP7102;

X = [ones(size(Y,1),1) BP85, BP87,ALT, ALTQ, BH39, BP70, BP6204, ...
    SCHOOL, KOERP1, STRES1, ABWEC1, SGEST1, KONTR1, BGGK5, BGGK20, ...
    BGGK100, AZD, AL84, KHT7, AUT15, EMIN20];

% Starting values
beta0 = zeros(size(X,2), 1); 

% Estimate model with standard options
options = optimoptions(@fminunc, 'Algorithm', 'quasi-newton');
[beta, fval, exitflag, output] = fminunc(@ll_poisson, beta0, options, Y, X, true);


% Estimate model
options = optimoptions( ...
    @fminunc, ...
    'Algorithm', 'quasi-newton', ...
    'HessUpdate', 'bfgs', ...           % bfgs (default), dfp, steepdesc
    'MaxIter', 10000, ...
    'MaxFunEvals', 10000, ...
    'TolX', 10^-8, ...
    'TolFun', 10^-8);

[beta, fval, exitflag, output] = fminunc(@ll_poisson, beta0, options, Y, X, true);

% Gradient and Hessian
g = Gradp(@ll_poisson, beta, Y, X, false);
H = HessMp(@ll_poisson, beta, Y, X, true);

cv_1 = inv(H);                   % Inverse of the Hessian 
cv_2 = inv(g'*g);                % Inverse of the OPG
cv_3 = inv(H) *  g'*g * inv(H);  % Sandwich estimator

se_1 = diag(cv_1).^0.5;
se_2 = diag(cv_2).^0.5;
se_3 = diag(cv_3).^0.5;

t_1 = beta ./ se_1;
t_2 = beta ./ se_2;
t_3 = beta ./ se_3;

p_1 = 2*(1-normcdf(abs(t_1)));
p_2 = 2*(1-normcdf(abs(t_2)));
p_3 = 2*(1-normcdf(abs(t_3)));