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
report_a.Properties.RowNames={'Duration', 'UI', 'Tenure','LogWage', 'Married', 'Female', 'Child', 'nonWhite', 'Age', 'schlt12', 'schge12'};
report_a
writetable(report_a, 'statistics.csv','WriteRowNames',true)

% Ex b)
%Linear Model
report_b=[regress(table2array(LogWage), table2array(Duration));
    regress(table2array(Age)/10, table2array(Duration));
    regress((table2array(Age).^2)/10, table2array(Duration));
    regress(table2array(Tenure), table2array(Duration));
    regress(table2array(Child), table2array(Duration));
    regress(table2array(NonWhite), table2array(Duration));
    regress(table2array(Married), table2array(Duration));
    regress(table2array(Schgt12), table2array(Duration));
    regress(table2array(Female), table2array(Duration));
    ];
report_b.Properties.RowNames={'Log Wage', 'Age/10', 'Age^2/10', 'Tenure', 'Has Child or Not', 'Is White or Not', 'Is Married or Not', 'Education Greated than 12', 'Gender'};
writetable(report_b, 'report_b.csv','WriteRowNames',true)
report_b

% Ex c)
%Histogram of Duration
fig=figure;
histogram(table2array(Duration))
title('Histogram of Duration')
saveas(fig, 'histogram_duration.pdf')


