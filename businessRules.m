classdef businessRules
    %businessRules Implements the business rules for data pre-processing
    %before running the approximate string matching algorithm
    
    properties
    end
    
    methods(Static)
        function [ p ] = markInvalidAccts( univName )
            %% Regex that matches invalid accountname_formatted
            %% .na, 123, A, -, ..
            expression = '((^(\.na)([^a-zA-Z]+)?$)|(^[^a-zA-Z]+$)|(^[A-Za-z]$))';
            startIndex = regexp(univName,expression, 'once');
            p = cellfun(@isempty,startIndex);
        end
        
        
        
        
    end
    
end

