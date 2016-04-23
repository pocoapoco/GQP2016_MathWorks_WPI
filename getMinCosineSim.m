function T = getMinCosineSim(TAccounts, TSchools)

%% Change sample test & size here
%%[sample,idx] = datasample(TAccounts(:,1),100);
load('sample.mat');
%%sample = {'university of delaware lieberman''s bookstore'};
%sample = table2cell(sample);

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

        score = cosine_similarity(actName{1}, univName{1}, 2, true);      
                      
        subC(counter,:) = {actName{1}, UNIVName{1}, url{1}, score};               
        counter = counter+1;
    end
    if (isempty(find(~cellfun(@isempty,subC(1,1)), 1)))
        subC(1,:) = {actName{1},' ', ' ', 0};
    end
    
    TSub = cell2table(subC,'VariableNames', {'AccountName', 'UniversityName', 'URL', 'Cosine'});
    from = find(cellfun(@isempty,table2cell(TSub(:,1))), 1);
    TSub(from:end,:)=[];

    TSub = sortrows(TSub,'Jaccard','ascend');
    TSub(2:end,:) = [];
    
    subC = table2cell(TSub);   
        
    to = find(~cellfun(@isempty,subC(:,1)));
    from = find(cellfun(@isempty,scoreC(:,1)));    
    scoreC(from(1):to(end)+from(1)-1,:) = subC(1:to(end),:); 
    
end

T = cell2table(scoreC,'VariableNames', {'AccountName', 'UniversityName', 'URL', 'Cosine'});

%% delete empty rows to save space
from = find(cellfun(@isempty,table2cell(T(:,1))), 1);
T(from:end,:)=[];

end

