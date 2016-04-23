function [cosineSim] = cosine_similarity(word_User, word_Orig, n_gram, remove_stop)
% Jaccard index and distance co-efficient of Actual university name with
% that of user entered university name
% Usage: [index] = jaccard_coefficient(Orig_word,User_Image,n_gram);

% Binarize the words based on the N-grams. Ignore special characters like -
% N-grams: Unigram, Bigram and Trigram are implemented

% Avoid generating NaN for bigram and trigram when the length of the word
% is lesser than the n_gram
if remove_stop
 [word_Orig, word_User]= remove_stopword(word_Orig, word_User);
end


s1 = regexp(word_Orig,'<s>|\w*|</s>','match');
s2 = regexp(word_User,'<s>|\w*|</s>','match');

if ((length(s1)<2 || length(s2)<2) && n_gram == 2)
    n_gram = 1;
elseif ((length(s1)<3 || length(s2)<3) && n_gram == 3)
    n_gram = 2;
end

if (n_gram == 1)
    s1 = regexp(word_Orig,'<s>|\w*|</s>','match');
    s2 = regexp(word_User,'<s>|\w*|</s>','match');
elseif (n_gram == 2)
    z=regexp(word_Orig,'<s>|\w*|</s>','match'); %'\w*','match'
    s1 = strcat(z(1:end-1),{' '},z(2:end));
    z=regexp(word_User,'<s>|\w*|</s>','match');
    s2 = strcat(z(1:end-1),{' '},z(2:end));
elseif (n_gram == 3)
    words=regexp(word_Orig,'<s>|\w*|</s>','match'); %<s>|\w*|</s>
    s1=cellfun(@(x,y,z) [x ' ' y ' ' z],words(1:end-2), words(2:end-1),words(3:end),'un',0);
    words=regexp(word_User,'<s>|\w*|</s>','match'); %<s>|\w*|</s>
    s2=cellfun(@(x,y,z) [x ' ' y ' ' z],words(1:end-2), words(2:end-1),words(3:end),'un',0);
end

uWords = union(s1,s2);

% Binarize words
S1 = zeros(size(uWords));
for k = 1:size(s1,1)
    S1(k,:) = ismember(uWords(k,:),s1);
end

S2 = zeros(size(uWords));
for k = 1:size(s2,1)
    S2(k,:) = ismember(uWords(k,:),s2);
end

cosineSim = pdist2(S1, S2, 'cosine');
