%% EXAMPLE
% d1 - Levenstein distance, d2 - Levenstein and editor distances
%d1=strdist('statistics','mathematics')
%d2=strdist('statistics','mathematics',2)
%%
% |How to count substitutions:|
%disp('Quantity of substitutions:')
%disp(d2(2)-d2(1))
%%
% |Case sensitive:|
%strdist('Havelock North High School','Worcester Polytechnic Institute',2)
%%%
% |Case non-sensitive:|
%strdist('Worcester Polytechnic Institute','Worcester Polytechnic Institute1',2,1)


% Export data to excel
s = load('C:\Users\chitra\Documents\MATLAB\data\schoollist.mat');
theTable = s.schoollist;
% Display first 5 rows of the table
theTable(1:5,:)
filename = 'schoollist.xlsx';
writetable(theTable,filename,'Sheet',1)