function T = calculateEScore(TAccounts, TSchools)

%% Choose random sample test
%% Change sample size here
%%[sample,idx] = datasample(TAccounts(:,1),100);
load('sample.mat');
%%sample = {'west virginia university'};

%% pre-allocate to the size of cartesian product
rows = (length(sample)*height(TSchools));
scoreC = cell(rows,6);

for i = 1:length(sample)
    %% pre-allocate to the size of the actual set 
    %% remove all those that does not fulfill the approx. match criteria - explained below
    subC = cell(height(TSchools),6); 
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
        score = strdist(actName{1}, univName{1}, 2, 1);
        substitutions = (score(2)-score(1));
              
        %% set threshold limit here
        %% Approx. Match criteria
        %% Jaccard Index for Bigram, Unigram or Trigram greater than 0.7 yields accurate results
        if (score(1)<=5) 
            subC(counter,:) = {actName{1}, UNIVName{1}, url{1}, score(1), score(2), substitutions};
            counter = counter+1;
        end
                
        %% If the record hits an exact match, delete the other nearest matches
        %% once a record hits an exact match, do not run the same record against others
        if (score(1)<=2 && substitutions == 0)
            last = find(~cellfun(@isempty,subC(:,1)));
            if last(end)>1
                subC(1:last(end)-1,:) = [];   
            end
            break
        end        
    end
    
    %% if no match is found within the threshold defined,
    %% substitution cost = 0 and L-Score less than equal 2 are mostly exact matches
    %% filtering by 100-score can be used for evaluating accuracy and precision later
    if (isempty(find(~cellfun(@isempty,subC(1,1)), 1)))
        subC(1,:) = {actName{1},' ', ' ', 100, 100, 100};
    end
    
    to = find(~cellfun(@isempty,subC(:,1)));
    from = find(cellfun(@isempty,scoreC(:,1)));    
    scoreC(from(1):to(end)+from(1)-1,:) = subC(1:to(end),:);  
    
end

T = cell2table(scoreC,'VariableNames', {'AccountName', 'UniversityName', 'URL', 'LScore', 'EScore', 'Substitutions'});

%% delete empty rows to save space
from = find(cellfun(@isempty,table2cell(T(:,1))), 1);
T(from:end,:)=[];



