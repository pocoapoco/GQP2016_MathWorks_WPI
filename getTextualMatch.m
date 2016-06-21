clear,clc

% Edit accountlist dataset path here
pathAccountList = 'C:\Users\chitra\Documents\MATLAB\data\accountlist.mat';

% Edit universities dataset path here
% It can be either schoollist or ipeds dataset or one unified dataset
pathSchoollist = 'C:\Users\chitra\Documents\MATLAB\data\ipeds.mat'; %schoollist

% set the country filter here
% the country set here will be used as the filter for both accountlist and
% universities dataset.
country = char(Countries.United_States);

% remove special characters if any from the enumeration
country = regexprep(country,'[_]',' ','ignorecase');

% Schoollist is pre-processed and saved - ONLY ONE TIME RUN
%TSchools = preProcessUniversities(pathSchoollist, country);
load('TSchools.mat');

% Accountlist is processed every time you look for a match from a different
% country
%TAccounts = processAccountList(pathAccountList, country);
load('TAccounts.mat');

% Jaccard/Levenshtein for similarity computation
% Jaccard Index
%Tscore = calculateJScore(TAccounts, TSchools);

% Levenshtein distance
Tscore = calculateEScore(TAccounts, TSchools);

%% Copy Tscore to excel sheet for more analysis
filename = 'scorelist.xlsx';
writetable(Tscore,filename,'Sheet',1)

