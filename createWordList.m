%% Break data up into words
load('C:\Users\chitra\Documents\MATLAB\data\accountlist.mat')

wordList = table;
wordList.AccountId = cell(1);
wordList.word = cell(1);
wordList.location = 0;

for idx = 1:height(data)
    a=strsplit(data.AccountName{idx},' ');
    
    for idxWords = 1:length(a)
        % Grow table for each word
        x=cell2table({data.AccountId(idx),a(idxWords),idxWords},'VariableNames',{'AccountId','word','location'});
        wordList = [wordList;x];
    end
end

% Remove the first one we created as a blank line
wordList(1,:)=[];

%% Export data to excel
load('wordlist.mat');
filename = 'wordlist.xlsx';
writetable(wordList,filename,'Sheet',1)

%% Pre-Processing Cleanup
% Remove special characters that don't make sense like '.'
% Rename Univ to University 
% Rename misspellings

%% Generate Word Count
load('wordlist.mat')
freqyTbl = tabulate(wordList.word); %% contains word, count & percent
%% Look at hist to find other rules to add to pre-processing section above

%% don't focus on words that don't have information in them


%% Determine the size of a variable - AccountName_Formatted, 
%% and then pre-process each University name as per the business rules.

% for i = 1:nrows
%     strUniversity = indSchCmp{i,3};    
%     expression = '((^(\.na)([^a-zA-Z]+)?$)|(^[^a-zA-Z]+$)|(^[A-Za-z]$))';
%     startIndex = regexpi(strUniveristy,expression);    
%     if ndims(startIndex) > 0
%         strUniversity
%     end
% end




