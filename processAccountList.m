function [TAccounts] =  processAccountList(pathAccountList, country)
%% don't focus on words that don't have information in them
al = load(pathAccountList);
alTable = al.data;

%% Mark invalid rows after filtering by Country
temp = alTable(strcmpi(table2cell(alTable(:,'Country')), country),:);
rule1 = @preProcessingRules.markInvalidAccts;

%% Records that have invalid Account Names
t1 = varfun(rule1,temp,'InputVariables','AccountName_Formatted');
temp = [temp t1];
temp.Properties.VariableNames{end} = 'Process';

%% Get the subset by country and valid account name to process further
Ttest = temp(temp.Process == true,:);

%% Correct misspellings
rule2 = @preProcessingRules.correctMisspellings;
t2 = varfun(rule2,Ttest,'InputVariables','AccountName_Formatted');
Ttest.AccountName_Formatted = t2.Fun_AccountName_Formatted;

%% Remove Accts corresponding to Non-University
rule3 = @preProcessingRules.markCompanyAccts;
t3 = varfun(rule3,Ttest,'InputVariables','AccountName_Formatted');
Ttest.Process = t3.Fun_AccountName_Formatted;

Ttest = Ttest(Ttest.Process == true,:);

%% convert accountname to lowercase to get only unique values
% Ttest.AccountName = lower(Ttest.AccountName);
Ttest.AccountName_Formatted = lower(Ttest.AccountName_Formatted);

%% Get unique account names
TAccounts = unique(Ttest.AccountName_Formatted);
TAccounts = cell2table(TAccounts,'VariableNames',{'LAccountName'});
