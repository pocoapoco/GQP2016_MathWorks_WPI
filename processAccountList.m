clear,clc
%% don't focus on words that don't have information in them
al = load('C:\Users\chitra\Documents\MATLAB\data\accountlist.mat');
alTable = al.data;
% summary(alTable);
height(alTable);

%% create empty column Process = Yes/No
%%temp(height(alTable),1)= true;
%temp = table(true(height(alTable),1),'VariableNames',{'Process'});
%% Union to AccountList table
%alTable = [alTable temp];

%% Mark invalid rows after filtering by Country
temp = alTable(strcmpi(table2cell(alTable(:,5)), 'United States'),:);
rule1 = @businessRules.markInvalidAccts1;

%% Records that have invalid Account Names
t1 = varfun(rule1,temp,'InputVariables','AccountName_Formatted');
temp = [temp t1];
temp.Properties.VariableNames{end} = 'Process';

%% Get the subset by country and valid account name to process further
Ttest = temp(temp.Process == true,:);

%% Correct misspellings
rule2 = @businessRules.correctMisspellings;
t2 = varfun(rule2,Ttest,'InputVariables','AccountName_Formatted');
Ttest.AccountName_Formatted = t2.Fun_AccountName_Formatted;

%% Remove Accts corresponding to Non-University
rule3 = @businessRules.markCompanyAccts;
t3 = varfun(rule3,Ttest,'InputVariables','AccountName_Formatted');
Ttest.Process = t3.Fun_AccountName_Formatted;

Ttest = Ttest(Ttest.Process == true,:);

%% convert accountname to lowercase to get only unique values
Ttest.AccountName = lower(Ttest.AccountName);
Ttest.AccountName_Formatted = lower(Ttest.AccountName_Formatted);

%% Get unique account names
Tunique = unique(Ttest.AccountName_Formatted);

%% Load actual Universities dataset
sl = load('C:\Users\chitra\Documents\MATLAB\data\schoollist.mat');
tSchools = sl.schoollist;
%% Get UniversityLocalName filtered by Country for which you are matching
Tactual = tSchools(strcmpi(table2cell(tSchools(:,13)), 'United States'),:);

Tscore = calculateScore(Tunique, Tactual);

%% Copy Tscore to excel sheet for more analysis
filename = 'scorelist.xlsx';
writetable(Tscore,filename,'Sheet',1)