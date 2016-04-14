function T = calculateJScore(Ttest, Tactual)

%% Choose sample test
%% Change sample size here
%%[sample,idx] = datasample(Ttest(:,1),100);
load('sample.mat');
%%sample = {'punjabi University'};

%% pre-allocate to the size of cartesian product
rows = (length(sample)*height(Tactual));
scoreC = cell(rows,6);
row = 1;
for i = 1:length(sample)
    %% pre-allocate to the size of the actual set 
    %% remove all those that does not fulfill the approx. match criteria
    %subC = cell(height(Tactual),5); 
    actName = sample(i,1);
    
    %% run sample only across the record that starts with the same alphabet 
    %Talphabet = Tactual(strncmpi(table2cell(Tactual(:,2)),actName{1}(1),1),:);
    for j = 1:height(Tactual) 
        
        univName = Tactual(j,'UniversityLocalName'); 
        url = Tactual(j,'URL');
        url = table2cell(url);
        univName = table2cell(univName);
        score1 = jaccard_similarity(actName{1}, univName{1},1,false); 
        %score2 = jaccard_similarity(actName{1}, univName{1},2,true);
        %score3 = jaccard_similarity(actName{1}, univName{1},3,true);
              
        
        scoreC(row,:) = {actName{1},univName{1}, url, score1, 0, 0};
        row = row+1;
     end
end

T = cell2table(scoreC,'VariableNames', {'AccountName', 'UniversityName', 'URL', 'J1', 'J2', 'J3'});





