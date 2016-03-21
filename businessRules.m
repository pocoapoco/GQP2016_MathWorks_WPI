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
        
        function [ w ] = correctMisspellings ( univName )
            expression = {                                 ...
            '\<Univ\.?\>(?!\w)' ; ...
            '\<Univercity\>(?!\w)'   ; ...
            '\<Inst\.?\>(?!\w)'      ; ...
            '\<Pvt\.?\>(?!\w)'      ; ...
            '\<Ltd\.?\>(?!\w)'      ; ...
            '\<Engg\.?\>(?!\w)'      ; ...
            '\<Govt\.?\>(?!\w)'      ; ...
            '\<Info\.?\>(?!\w)'      ; ...
            '\<Mgmt\.?\>(?!\w)'      ; ...
            '\<Tech\>(?!\w)'};
            
            replace = {                                 ...
            'University' ; ...
            'University'   ; ...
            'Institute'      ; ...
            'Private'   ; ...
            'Limited'      ; ...
            'Engineering' ; ...
            'Government' ; ...
            'Information' ; ...
            'Management' ; ...
            'Technology'};
        
            w = regexprep(univName,expression,replace,'ignorecase');
        end
        
        function [ p ] = markCompanyAccts( univName )
            %% Regex that matches invalid accountname_formatted 
            %% Looks for limited keyword to remove the company name
            expression = '\<Limited\>(?!\w)'; % include corporation
            startIndex = regexpi(univName,expression, 'once');
            p = cellfun(@isempty,startIndex);
        end
    end
    
end

