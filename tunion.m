function t = tunion(t1,t2,missingData)
% TUNION does the union of two tables and fills in missing data if needed
%
%   t=tunion(t1,t2,missingdata)
%
% Example:
% 
% t1 = array2table(magic(4),'VariableNames',{'a','b','c','d'});
% t2 = array2table(magic(5),'VariableNames',{'a','c','d','e','f'});
%
% t = tunion(t1,t2,'nan')


if strcmp(missingData,'cell')
    missingData = @cell;
elseif strcmp(missingData,'nan')
    missingData = @nan;
elseif isfunction(missingData)
else    
    error('Did not understand missing Data type.  Pass ''nan'', ''cell'', or functionhandle')
end
% Get missing columns from data 
t1colmissing = setdiff(t1.Properties.VariableNames, t2.Properties.VariableNames);
t2colmissing = setdiff(t2.Properties.VariableNames, t1.Properties.VariableNames);

% If there are missing columns for either dataset add these columns
if ~isempty(t1colmissing)||~isempty(t2colmissing)
    t2 = [t2 array2table(missingData(height(t2), numel(t1colmissing)), 'VariableNames', t1colmissing)];
    t1 = [t1 array2table(missingData(height(t1), numel(t2colmissing)), 'VariableNames', t2colmissing)];
end
t = [t2; t1];
