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
temp = alTable(strcmpi(table2cell(alTable(:,5)), 'India'),:);
rule1 = @businessRules.markInvalidAccts;

%% Records that have invalid Account Names
t1 = varfun(rule1,temp,'InputVariables','AccountName_Formatted');
temp = [temp t1];
temp.Properties.VariableNames{end} = 'Process';

%% Get the subset by country and valid account name to process further
TtoProcess = temp(temp.Process == true,:);








