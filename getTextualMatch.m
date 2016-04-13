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

TMatch = processAccountList(pathAccountList, pathSchoollist, country);

