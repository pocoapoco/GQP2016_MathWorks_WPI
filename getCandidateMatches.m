function [ TCandidates ] = getCandidateMatches( actName, TSchools )
%getCandidateMatches records that might be a possible match

 % Get only the candidate matches
    aBigram = preProcessingRules.generateBigram({actName});
    aBigram = strsplit(aBigram{1},',');
    index = false(height(TSchools), 1);
    for k = 1:height(TSchools)
        sBigram = TSchools(k,'Bigrams');
        sBigram = table2array(sBigram);
        sBigram = strsplit(sBigram{1},',');
        idx = ismember(sBigram,aBigram);
        if (~strcmpi(sBigram,'NA') & (~isempty(find(idx,1))))
             index(k) = true;
        end
    end

    % Run matches with only the candidates saved in TCandidates 
    TCandidates = TSchools(index,:);

end

