function T = calculateScore(Ttest, Tactual)
% %% EXAMPLE
% %% d1 - Levenstein distance, d2 - Levenstein and editor distances
% d1=strdist('statistics','mathematics')
% d2=strdist('statistics','mathematics',2)
% %%
% %% |How to count substitutions:|
% disp('Quantity of substitutions:')
% disp(d2(2)-d2(1))
% %%
% %% |Case sensitive:|
% strdist('Havelock North High School','Worcester Polytechnic Institute',2)
% %%
% %% |Case non-sensitive:|
% strdist('Worcester Polytechnic Institute','Worcester Polytechnic Institute1',2,1)

% act = {'Indian Institute of Technology Roorkee'};
% tst = {'IIT Roorkee'};
% 
% 
% for i = 1:length(act)
%     for j = 1:length(tst)
%         dd = strdist(act{i}, tst{j}, 2, 1);
%         dd
%     end
% end

%% Choose sample test
[sample,idx] = datasample(Ttest(:,1),50);
%Ttest(1:5,:)
%z = Tactual(1:5,:);
row = 1;
%% pre-allocate to the size of cartesian product
rows = (length(sample)*height(Tactual));
C = cell(rows,5);
for i = 1:length(sample)
    for j = 1:height(Tactual) %Tactual
        actName = sample(i,1);
        univName = Tactual(j,2); %Tactual
        univName = table2cell(univName);
        score = strdist(actName{1}, univName{1}, 2, 1);
        
        C(row,:) = {actName{1},univName{1}, score(1), score(2), (score(2)-score(1))};
        row = row+1;     
    end
end

T = cell2table(C,'VariableNames', {'AccountName', 'UniversityName', 'LScore', 'EScore', 'Substitutions'});



