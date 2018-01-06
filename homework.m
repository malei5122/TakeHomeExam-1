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
nonWhite=ema1996(:,'nonwhite');
Age=ema1996(:,'age');
schlt12=ema1996(:,'schlt12');
schgt12=ema1996(:,'schgt12');

% Statistic (mean,standard deviation, median, minimum and maximum)
summary=[statistics(Duration); statistics(UI); statistics(Tenure); statistics(LogWage); 
    statistics(Married); statistics(Female); statistics(Child); statistics(nonWhite);
    statistics(Age); statistics(schlt12); statistics(schgt12)];
summary.Properties.RowNames={'Duration', 'UI', 'Tenure','LogWage', 'Married', 'Female', 'Child', 'nonWhite', 'Age', 'schlt12', 'schge12'}
writetable(summary, 'statistics.csv','WriteRowNames',true)

% Ex b)
%Linear Model
mdl=LinearModel.fit(table2array(LogWage), table2array(Duration));

% Ex c)
%Histogram of Duration
fig=figure;
histogram(table2array(Duration))
title('Histogram of Duration')
saveas(fig, 'histogram_duration.pdf')


