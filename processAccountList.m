function Tscore =  processAccountList(pathAccountList, pathSchoollist, country)
%% don't focus on words that don't have information in them
al = load(pathAccountList);
alTable = al.data;

%% Mark invalid rows after filtering by Country
temp = alTable(strcmpi(table2cell(alTable(:,'Country')), country),:);
rule1 = @businessRules.markInvalidAccts;

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
% Ttest.AccountName = lower(Ttest.AccountName);
Ttest.AccountName_Formatted = lower(Ttest.AccountName_Formatted);

%% Get unique account names
Tunique = unique(Ttest.AccountName_Formatted);

%% Load actual Universities dataset
sl = load(pathSchoollist);
isSchoollist = strfind(pathSchoollist, 'schoollist');

% Apply filter to only schoolist dataset
% IPED is already filtered by Country US
% TODO: ELIMINATE THIS WHEN YOU GET A UNIFIED DATASET
if ~isempty(isSchoollist)
    tSchools = sl.schoollist;
    %% Get UniversityLocalName filtered by Country for which you are matching
    Tactual = tSchools(strcmpi(table2cell(tSchools(:,'Country')), country),:);
elseif (isempty(isSchoollist) && strcmpi(country,'United States'))
    % Rename few attributes to match the schoollist dataset
    tSchools = sl.hd2014;
    tSchools.Properties.VariableNames{2} = 'UniversityLocalName';
    tSchools.Properties.VariableNames{15} = 'URL';
    Tactual = tSchools;
end

%% convert UniversityLocalName to lowercase to perform case-insensitive match
Tactual.UniversityLocalName = lower(Tactual.UniversityLocalName);

Tscore = calculateScore(Tunique, Tactual);

%% Copy Tscore to excel sheet for more analysis
filename = 'scorelist.xlsx';
writetable(Tscore,filename,'Sheet',1)