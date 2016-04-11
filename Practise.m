% clc
% distances={'osa','levenshtein'};%,'weighted'};
% 
% sentence_a = 'smith';
% sentence_b = 'smtih';
% 
% %keylist_a = {'indian', 'institute', 'of', 'information', 'technology', 'and', 'management'};
% %keylist_b = {'indian', 'institute', 'of', 'information', 'technology', 'and', 'management', 'gwalior'};
% 
% keylist_a = {'iit'};
% keylist_b = {'iim'};
% 
% %% demo
% fprintf('Testing sentences:\n');
% for i = 1:numel(distances)
%   s = sprintf('edit_distance_%s',distances{i});
%   f = str2func(s);
%   d = f(sentence_a,sentence_b);
%   fprintf('\t%15s distance = %d\n',distances{i},d);
% end
% 
% fprintf('Testing keylists:\n');
% for i = 1:numel(distances)
%   s = sprintf('edit_distance_%s_keylist',distances{i});
%   f = str2func(s);
%   d = f(keylist_a,keylist_b);
%   fprintf('\t%15s distance = %d\n',distances{i},d);
% end

% 
% ss = 'M.G. Un-iversit''y /Oregan,'
% expression = '[\.-,\'']';
% replace = '';
% w = regexprep(ss,expression,replace,'ignorecase');
% 
% w
% 

% x = 'coursera';
% 
% out=any(cell2mat(regexpi(x,'coursera')));
% out

univName = '(ed: dkd)';
 expression = '(\(ID:)';
     p=    regexpi(univName,expression);

p




