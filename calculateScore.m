function T = calculateScore(Ttest, Tactual)

%% Choose sample test
[sample,idx] = datasample(Ttest(:,1),50);

%%sample = {'Gujarat Technological University'};

%% pre-allocate to the size of cartesian product
rows = (length(sample)*height(Tactual));
scoreC = cell(rows,5);

for i = 1:length(sample)
    %% pre-allocate to the size of the actual set 
    %% remove all those that does not fulfill the approx. match criteria
    subC = cell(height(Tactual),5); 
    counter = 1;
    actName = sample(i,1);
    
    %% run sample only across the record that starts with the same alphabet 
    Talphabet = Tactual(strncmpi(table2cell(Tactual(:,2)),actName{1}(1),1),:);
    for j = 1:height(Talphabet) 
        
        univName = Talphabet(j,2); 
        univName = table2cell(univName);
        score = strdist(actName{1}, univName{1}, 2, 1);
        substitutions = (score(2)-score(1));
       
        %% set threshold limit here
        %% TODO - yet to determine a good threshold
        if (score(1)<=10) %% COME UP WITH GOOD CONDITION
            subC(counter,:) = {actName{1},univName{1}, score(1), score(2), substitutions};
            counter = counter+1;
        end
                
        %% Approx. Match criteria
        %% substitution cost = 0 and L-Score less than equal 2 are mostly exact matches
        %% once a record hits an exact match, do not run the same record against others
        if (score(1)<=2 && substitutions == 0)
            if counter>2
                subC(1:counter-1,:) = [];   
            end
            break
        end        
    end
    
    %% if no match is found within the threshold defined,
    %% enter the record in the score table with all scores = 100
    %% filtering by 100 score can be used for evaluating accuracy and precision later
    if (isempty(find(~cellfun(@isempty,subC(1,1)), 1)))
        subC(1,:) = {actName{1},' ', 100, 100, 100};
    end
    
    to = find(~cellfun(@isempty,subC(:,1)));
    from = find(cellfun(@isempty,scoreC(:,1)));    
    scoreC(from(1):to(end)+from(1)-1,:) = subC(1:to(end),:);  
    
end

T = cell2table(scoreC,'VariableNames', {'AccountName', 'UniversityName', 'LScore', 'EScore', 'Substitutions'});

%% delete empty rows to save space
from = find(cellfun(@isempty,table2cell(T(:,1))), 1);
T(from:end,:)=[];



