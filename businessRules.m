classdef businessRules
    %businessRules Implements the business rules for data pre-processing
    %before running the approximate string matching algorithm
    
    properties
    end
    
    methods
        function correctInvalidAcctNames(schools)
                [nrows, ~] = size(schools);
                for i = 1:nrows
                    univName = schools{i,3};    
                    %% Regex that matches invalide accountname_formatted
                    %% .na, 123, A, -, ..
                    expression = '((^(\.na)([^a-zA-Z]+)?$)|(^[^a-zA-Z]+$)|(^[A-Za-z]$))';
                    startIndex = regexp(univName,expression, 'once'); 
                    if ~isempty(startIndex)
                        univName
                    end
                end
        end
        
        
    end
    
end

