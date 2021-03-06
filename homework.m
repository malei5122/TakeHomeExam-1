clear;

load('./ema1996.mat');

% Ex a)
% Declare the necessary variables
Duration=ema1996(:,'spell');
UI=ema1996(:,'ui');
Tenure=ema1996(:,'tenure');
LogWage=ema1996(:,'logwage');
Married=ema1996(:,'married');
Female=ema1996(:,'female');
Child=ema1996(:,'child');
NonWhite=ema1996(:,'nonwhite');
Age=ema1996(:,'age');
Schlt12=ema1996(:,'schlt12');
Schgt12=ema1996(:,'schgt12');

% Statistic (mean,standard deviation, median, minimum and maximum)
report_a=[statistics(Duration); statistics(UI); statistics(Tenure); statistics(LogWage); 
    statistics(Married); statistics(Female); statistics(Child); statistics(NonWhite);
    statistics(Age); statistics(Schlt12); statistics(Schgt12)];
report_a.Properties.RowNames={'Duration', 'UI', 'Tenure','LogWage', 'Married', ...
    'Female', 'Child', 'nonWhite', 'Age', 'schlt12', 'schge12'};
disp(report_a);
writetable(report_a, 'statistics.csv','WriteRowNames',true)

% Ex b)
%Linear Model
X=[table2array(LogWage) table2array(Age)/10 (table2array(Age).^2)/10 table2array(Tenure) table2array(Child) table2array(NonWhite) table2array(Married) table2array(Schgt12) table2array(Female)];
report_b=regress(X, table2array(Duration));
report_b.Properties.RowNames={'Constant' 'Log Wage', 'Age/10', 'Age^2/10', ... 
    'Tenure', 'Has Child or Not', 'Is White or Not', 'Is Married or Not', ...
    'Education Greated than 12', 'Gender'};

writetable(report_b, 'report_b.csv','WriteRowNames',true)
disp(report_b);

% Ex c)
%Histogram of Duration
fig=figure;
histogram(table2array(Duration))
title('Histogram of Duration')
saveas(fig, 'histogram_duration.pdf')

% Ex d)
% Dependent variable
Y = table2array(Duration);

X = [ones(size(Y,1),1) X];

% Starting values
beta0 = zeros(size(X,2), 1); 

% Estimate model with standard options
options = optimoptions(@fminunc, 'Algorithm', 'quasi-newton');
[beta, fval, exitflag, output] = fminunc(@ll_poisson, beta0, options, Y, X, true);
coefficients=beta;
report_d=table(coefficients);
report_d.Properties.RowNames={'Constant' 'Log Wage', 'Age/10', 'Age^2/10', ... 
    'Tenure', 'Has Child or Not', 'Is White or Not', 'Is Married or Not', ...
    'Education Greated than 12', 'Gender'};
disp(report_d);
writetable(report_d, 'report_d.csv','WriteRowNames',true)

% Excises e)
% Gradient and Hessian
g = Gradp(@ll_poisson, beta, Y, X, false);
H = HessMp(@ll_poisson, beta, Y, X, true);

% Excises f)
cv_1 = inv(H);                   % Inverse of the Hessian 
cv_2 = inv(g'*g);                % Inverse of the OPG
cv_3 = inv(H) *  g'*g * inv(H);  % Sandwich estimator

se_1 = diag(cv_1).^0.5;
se_2 = diag(cv_2).^0.5;
se_3 = diag(cv_3).^0.5;

t_1 = beta ./ se_1;
t_2 = beta ./ se_2;
t_3 = beta ./ se_3;

disp('Covariance Matrix (Hessian)');
disp(cv_1);
disp('Covariance Matrix (Gradient)');
disp(cv_2);
disp('Covariance Matrix (Sandwitch)');
disp(cv_3);

disp('T Values (Hessian)')
disp(t_1');
disp('T Values (Gradient)')
disp(t_2');
disp('T Values (Sandwitch)')
disp(t_3');

% Exercise i)

% APE
APE = mean(exp(X*beta)*beta(3,:));
disp('APE');
disp(APE)
% PEA
PEA = exp(mean(X) * beta) *beta(3,:);
disp('PEA');
disp(PEA)
