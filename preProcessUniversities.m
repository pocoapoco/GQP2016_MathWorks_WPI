function [ TSchools ] = preProcessUniversities( pathSchoollist, country )
%preProcessUniversities offline computation of the actual dataset before
%running the algorithm
%   Generate unigrams, bigrams and trigrams

%% Load actual Universities dataset
sl = load(pathSchoollist);
isSchoollist = strfind(pathSchoollist, 'schoollist');

% Apply filter to only schoolist dataset
% IPED is already filtered by Country US
% TODO: ELIMINATE THIS WHEN YOU GET A UNIFIED DATASET

if ~isempty(isSchoollist)
    TSchools = sl.schoollist;
    %% Get UniversityLocalName filtered by Country for which you are matching
    TSchools = TSchools(strcmpi(table2cell(TSchools(:,'Country')), country),:);
    
    %% convert UniversityLocalName to lowercase to perform case-insensitive match
    t1 = lower(TSchools.UniversityLocalName);
    TSchools = [TSchools t1];
    TSchools.Properties.VariableNames{end} = 'LUniversityLocalName';
    
elseif (isempty(isSchoollist) && strcmpi(country,'United States'))
    
    % Rename few attributes to match the schoollist dataset
    TSchools = sl.hd2014;
    TSchools.Properties.VariableNames{2} = 'UniversityLocalName';
    TSchools.Properties.VariableNames{15} = 'URL';
    
    %% convert UniversityLocalName to lowercase to perform case-insensitive match
    t1 = lower(TSchools.UniversityLocalName);
    TSchools = [TSchools t1];
    TSchools.Properties.VariableNames{end} = 'LUniversityLocalName';
    
    % Generate unigram for universitylocalname
    rule4 = @preProcessingRules.generateUnigram;
    t2 = varfun(rule4,TSchools,'InputVariables','LUniversityLocalName');
    TSchools = [TSchools t2];
    TSchools.Properties.VariableNames{end} = 'Unigrams';
    
    % Generate bigram for universitylocalname
    rule5 = @preProcessingRules.generateBigram;
    t3 = varfun(rule5,TSchools,'InputVariables','LUniversityLocalName');
    TSchools = [TSchools t3];
    TSchools.Properties.VariableNames{end} = 'Bigrams';
    
    % Generate trigram for universitylocalname
    rule6 = @preProcessingRules.generateTrigram;
    t4 = varfun(rule6,TSchools,'InputVariables','LUniversityLocalName');
    TSchools = [TSchools t4];
    TSchools.Properties.VariableNames{end} = 'Trigrams';
    
end

%% Get unique schools
%TSchools = TSchools(unique(TSchools.LUniversityLocalName),:);

end

