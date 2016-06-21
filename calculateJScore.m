function T = calculateJScore(TAccounts, TSchools)

%% Change sample test & size here
[sample,idx] = datasample(TAccounts(:,1),100);
%%load('sample.mat');
%%sample = {'university of miami/mt sinai hospital'};
sample = table2cell(sample);

%% pre-allocate to the size of cartesian product
rows = (length(sample)*height(TSchools));
scoreC = cell(rows,4);

for i = 1:length(sample)
    %% pre-allocate to the size of the actual set 
    %% remove all those that does not fulfill the approx. match criteria - explained below
    subC = cell(height(TSchools),4); 
    counter = 1;
    actName = sample(i,1); %'LAccountName'
    
    %% run sample only across the candidate matches
    TCandidates = getCandidateMatches( actName{1}, TSchools);
    
    for j = 1:height(TCandidates)         
        univName = TCandidates(j,'LUniversityLocalName'); 
        univName = table2cell(univName);
        UNIVName = TCandidates(j,'UniversityLocalName');
        UNIVName = table2cell(UNIVName);
        url = TCandidates(j,'URL');
        url = table2cell(url);
        
        if isMultipleWords(actName{1})
            score = getHighestScore(actName{1}, univName{1}, 2, true);
        else
            score = jaccard_similarity(actName{1}, univName{1}, 2, true);
        end
        
                      
        %% set threshold limit here
        %% Approx. Match criteria
        %% Jaccard Index for Bigram, Unigram or Trigram greater than 0.7 yields accurate results
        if (score>=0.7) 
            subC(counter,:) = {actName{1}, UNIVName{1}, url{1}, score};
            counter = counter+1;
        end
                
        %% If the record hits an exact match, delete the other nearest matches
        %% once a record hits an exact match, do not run the same record against others
        if (score==1)
            last = find(~cellfun(@isempty,subC(:,1)));
            if last(end)>1
                subC(1:last(end)-1,:) = [];   
            end
            break
        end        
    end
    
    %% if no match is found within the threshold defined,
    %% enter the record in the score table with all scores = 0
    %% filtering by 0 score can be used for evaluating accuracy and precision later
    if (isempty(find(~cellfun(@isempty,subC(1,1)), 1)))
        subC(1,:) = {actName{1},' ', ' ', 0};
    end
    
    to = find(~cellfun(@isempty,subC(:,1)));
    from = find(cellfun(@isempty,scoreC(:,1)));    
    scoreC(from(1):to(end)+from(1)-1,:) = subC(1:to(end),:);  
    
end

T = cell2table(scoreC,'VariableNames', {'AccountName', 'UniversityName', 'URL', 'Jaccard'});

%% delete empty rows to save space
from = find(cellfun(@isempty,table2cell(T(:,1))), 1);
T(from:end,:)=[];

function jScore = getHighestScore(actName, univName, n_grams, remove_stop)
w = strsplit(actName,'/');
scores = zeros(1,length(w));
for k=1:length(w)
    scores(1,k) = jaccard_similarity(w{k}, univName, n_grams, remove_stop);
end
jScore = max(scores);
end

% Split by / and get the word that can give a better score
function flag = isMultipleWords(actName)
startIndex = regexpi(actName,'/', 'once');
if ~isempty(startIndex)
    flag = true;
else   
    flag = false;
end
end
end

