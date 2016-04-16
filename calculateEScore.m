function T = calculateEScore(TAccounts, TSchools)

%% Choose random sample test
%% Change sample size here
[sample,idx] = datasample(TAccounts(:,1),100);
%%load('sample.mat');
%%sample = {'punjabi University'};

%% pre-allocate to the size of cartesian product
rows = (length(sample)*height(TSchools));
scoreC = cell(rows,6);

for i = 1:length(sample)
    %% pre-allocate to the size of the actual set 
    %% remove all those that does not fulfill the approx. match criteria
    subC = cell(height(TSchools),6); 
    counter = 1;
    actName = sample(i,'LAccountName');
    
    %% run sample only across the record that starts with the same alphabet 
    Talphabet = TSchools(strncmpi(table2cell(TSchools(:,'LUniversityLocalName')),actName{1}(1),1),:);
    for j = 1:height(Talphabet) 
        
        univName = Talphabet(j,'LUniversityLocalName'); 
        univName = table2cell(univName);
        url = TSchools(j,'URL');
        url = table2cell(url);
        score = strdist(actName{1}, univName{1}, 2, 1);
        substitutions = (score(2)-score(1));
       
        %% set threshold limit here
        %% TODO - yet to determine a good threshold
        if (score(1)<=10) %% COME UP WITH GOOD CONDITION
            subC(counter,:) = {actName{1},univName{1}, url, score(1), score(2), substitutions};
            counter = counter+1;
        end
                
        %% Approx. Match criteria
        %% substitution cost = 0 and L-Score less than equal 2 are mostly exact matches
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
    %% enter the record in the score table with all scores = 100
    %% filtering by 100 score can be used for evaluating accuracy and precision later
    if (isempty(find(~cellfun(@isempty,subC(1,1)), 1)))
        subC(1,:) = {actName{1},' ', 100, 100, 100};
    end
    
    to = find(~cellfun(@isempty,subC(:,1)));
    from = find(cellfun(@isempty,scoreC(:,1)));    
    scoreC(from(1):to(end)+from(1)-1,:) = subC(1:to(end),:);  
    
end

T = cell2table(scoreC,'VariableNames', {'AccountName', 'UniversityName', 'URL', 'LScore', 'EScore', 'Substitutions'});

%% delete empty rows to save space
from = find(cellfun(@isempty,table2cell(T(:,1))), 1);
T(from:end,:)=[];



