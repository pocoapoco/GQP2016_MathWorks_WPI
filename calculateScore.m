function calculateScore(Ttest, Tactual)
%% EXAMPLE
%% d1 - Levenstein distance, d2 - Levenstein and editor distances
d1=strdist('statistics','mathematics')
d2=strdist('statistics','mathematics',2)
%%
%% |How to count substitutions:|
disp('Quantity of substitutions:')
disp(d2(2)-d2(1))
%%
%% |Case sensitive:|
strdist('Havelock North High School','Worcester Polytechnic Institute',2)
%%
%% |Case non-sensitive:|
strdist('Worcester Polytechnic Institute','Worcester Polytechnic Institute1',2,1)

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

Ttest(1:5,:)
z = Tactual(1:5,:)
row = 1;
%% Choose sample test
[sample,idx] = datasample(Ttest(:,2),10);
%% pre-allocate to the size of cartesian product
C = cell(height(sample) * height(z),5);
for i = 1:height(sample)
    for j = 1:height(z) %Tactual
        actName = sample(i,1);
        univName = z(j,2); %Tactual
        score = strdist(actName,univName, 2, 1);
       
        C(row) = {actName, univName, score(1), score(2), score(2)-score(1) };
              
    end
end

Toutput = cell2table(C,'VariableNames', 'AccountName', 'UniversityName', 'L-Score', 'E-Score', 'Substitutions'});



