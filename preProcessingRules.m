classdef preProcessingRules
    %businessRules Implements the business rules for data pre-processing
    %before running the approximate string matching algorithm
    
    properties
    end
    
    methods(Static)
        function [ p ] = markInvalidAccts( univName )
            %% Regex that matches invalid accountname_formatted
            %% .na, 123, A, -, .., coursera, Mooc, (ID:, empty string/empty space
            expression = '((^(\.na)([^a-zA-Z]+)?$)|(^[^a-zA-Z]+$)|(^[A-Za-z]$)|(^\s+$|^$)|(\(ID:)|coursera|Mooc)';
            startIndex = regexpi(univName,expression);
            p = cellfun(@isempty,startIndex);
        end   
        
        function [ w ] = correctMisspellings ( univName )
            expression = {                                 ...
            '\<Univ\.?\>(?!\w)' ; ...
            '\<U\.\s\>(?!\w)' ; ...
            '\<Univer\.?\>(?!\w)' ; ...
            '\<Univercity\>(?!\w)'   ; ...
            '\<Inst\.?\>(?!\w)'      ; ...
            '\<Pvt\.?\>(?!\w)'      ; ...
            '\<Ltd\.?\>(?!\w)'      ; ...
            '\<Engg\.?\>(?!\w)'      ; ...
            '\<Govt\.?\>(?!\w)'      ; ...
            '\<Info\.?\>(?!\w)'      ; ...
            '\<Mgmt\.?\>(?!\w)'      ; ...
            '\<Ctr\.?\>(?!\w)' ; ...
            '\<Tech\>(?!\w)'};
            
            replace = {                                 ...
            'University' ; ...
            'University'   ; ...'
            'University'   ; ...
            'University'   ; ...
            'Institute'      ; ...
            'Private'   ; ...
            'Limited'      ; ...
            'Engineering' ; ...
            'Government' ; ...
            'Information' ; ...
            'Management' ; ...
            'Center' ; ...
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
        
        function [ w ] = removePunctuations( univName )
            %% Regex that ignores Punctuations
            expression = '[\.-,\''\/\\_()]';
            replace = '';
            w = regexprep(univName,expression,replace,'ignorecase');             
        end
        
        function [ w ] = removeIrrelevantWords( univName )
             %% Regex that ignores Punctuations
            expression = '[\.-,\''\/\\_()]';
            replace = '';
            w = regexprep(univName,expression,replace,'ignorecase');    
        end
        
        function [ wl ] = generateUnigram( univName )
            wl = cell(length(univName),1);
            for k=1:length(univName)
                w = regexp(univName{k},'<s>|\w*|</s>','match');
                wl(k,1) = {strjoin(cellstr(w),',')};
            end            
        end
        
        function [ wl ] = generateBigram( univName )
            wl = cell(length(univName),1);
            for k=1:length(univName)
                w = regexp(univName{k},'<s>|\w*|</s>','match');
                if (length(w)>=2)                    
                    w = strcat(w(1:end-1),{' '},w(2:end));
                    wl(k,1) = {strjoin(cellstr(w),',')};
                else
                    wl(k,1) = {'NA'};
                end                
            end           
        end
        
        function [ wl ] = generateTrigram( univName )
             wl = cell(length(univName),1);
            for k=1:length(univName)
                w = regexp(univName{k},'<s>|\w*|</s>','match');
                if (length(w)>=3)                    
                    w=cellfun(@(x,y,z) [x ' ' y ' ' z],w(1:end-2), w(2:end-1),w(3:end),'un',0);
                    wl(k,1) = {strjoin(cellstr(w),',')};
                else
                    wl(k,1) = {'NA'};
                end                
            end    
        end
        
    end
    
end

