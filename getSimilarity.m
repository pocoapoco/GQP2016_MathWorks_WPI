function T = getSimilarity(Ttest, Tactual)

%% Choose sample test
%% Change sample size here
%%[sample,idx] = datasample(Ttest(:,1),100);
load('sample.mat');
%%sample = {'punjabi University'};

%% pre-allocate to the size of cartesian product
rows = (length(sample)*height(Tactual));
scoreC = cell(rows,5);
row = 1;
for i = 1:length(sample)
    %% pre-allocate to the size of the actual set 
    %% remove all those that does not fulfill the approx. match criteria
    %subC = cell(height(Tactual),5); 
    actName = sample(i,1);
    
    %% run sample only across the record that starts with the same alphabet 
    Talphabet = Tactual(strncmpi(table2cell(Tactual(:,2)),actName{1}(1),1),:);
    for j = 1:height(Talphabet) 
        
        univName = Talphabet(j,2); 
        univName = table2cell(univName);
        score1 = jaccard_similarity(actName{1}, univName{1},1); 
        score2 = jaccard_similarity(actName{1}, univName{1},2);
        score3 = jaccard_similarity(actName{1}, univName{1},3);
              
        
        scoreC(row,:) = {actName{1},univName{1}, score1, score2, score3};
        row = row+1;
     end
end

T = cell2table(scoreC,'VariableNames', {'AccountName', 'UniversityName', 'J1', 'J2', 'J3'});

filename = 'scorelist.xlsx';
writetable(T,filename,'Sheet',1)




