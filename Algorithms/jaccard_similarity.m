function [jaccardIdx] = jaccard_simlarity(word_Orig,word_User,n_gram)
% Jaccard index and distance co-efficient of Actual university name with
% that of user entered university name
% Usage: [index] = jaccard_coefficient(Orig_word,User_Image,n_gram);

% Binarize the words based on the N-grams. Ignore special characters like -
% N-grams: Unigram, Bigram and Trigram are implemented

if (n_gram == 1)
    s1 = regexp(word_Orig,'<s>|\w*|</s>','split');
    s2 = regexp(word_User,'<s>|\w*|</s>','split');
elseif (n_gram == 2)
    z=regexp(word_Orig,'<s>|\w*|</s>','split'); %'\w*','match'
    s1 = strcat(z(1:end-1),{' '},z(2:end));
    z=regexp(word_User,'<s>|\w*|</s>','split');
    s2 = strcat(z(1:end-1),{' '},z(2:end));
elseif (n_gram == 3)
   words=regexp(word_Orig,'<s>|\w*|</s>','split'); %<s>|\w*|</s>
   s1=cellfun(@(x,y,z) [x ' ' y ' ' z],words(1:end-2), words(2:end-1),words(3:end),'un',0);
   words=regexp(word_User,'<s>|\w*|</s>','split'); %<s>|\w*|</s>
   s2=cellfun(@(x,y,z) [x ' ' y ' ' z],words(1:end-2), words(2:end-1),words(3:end),'un',0);
end

uWords = union(s1,s2);

% Binarize words
S1 = zeros(size(fs));
for k = 1:size(s1,1)
    S1(k,:) = ismember(fs(k,:),s1);
end

S2 = zeros(size(fs));
for k = 1:size(s2,1)
    S2(k,:) = ismember(fs(k,:),s2);
end

% Find the intersection of the two strings
inter_word = word_Orig & word_User;

% Find the union of the two strings
union_word = word_Orig | word_User;


jaccardIdx = sum(inter_word(:))/sum(union_word(:));





Index = jaccard_coefficient(S1,S2);
Index
