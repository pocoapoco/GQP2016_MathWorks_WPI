function [CompleteInformation , CL1 ]  = confidenceLevel(universityName ,  data)
%result = arrayfun(strdist, data(:,3) ,  repmat( universityName , size(data,2),1 ) , repmat( 2 , size(data,2),1 ) , repmat( 1 , size(data,2),1 ) )

cellArrayData = table2cell(data(:,3))
cellSrtingData = cellstr(cellArrayData)
charArrayData = char(cellSrtingData)


for i=1:size(charArrayData,1)
    distance(i,:) = strdist(universityName , strtrim(charArrayData(i,:)) , 2);
end

[a1,b1] = min(distance(:,1));
[a2,b2] = min(distance(:,2));


CL1 = charArrayData(distance(:,1) == a1(1,1)  , :)
CL2 = charArrayData(distance(:,2) == a2(1,1)   , :)


CompleteInformation  = data(distance(:,1) == a1(1,1)   , :)
Groups = unique(CompleteInformation(:,1:5))

prob = 100 / size(Groups,1);




function [d,A]=strdist(r,b,krk,cas)
%d=strdist(r,b,krk,cas) computes Levenshtein and editor distance 
%between strings r and b with use of Vagner-Fisher algorithm.
%   Levenshtein distance is the minimal quantity of character
%substitutions, deletions and insertions for transformation
%of string r into string b. An editor distance is computed as 
%Levenshtein distance with substitutions weight of 2.
%d=strdist(r) computes numel(r);
%d=strdist(r,b) computes Levenshtein distance between r and b.
%If b is empty string then d=numel(r);
%d=strdist(r,b,krk)computes both Levenshtein and an editor distance
%when krk=2. d=strdist(r,b,krk,cas) computes a distance accordingly 
%with krk and cas. If cas>0 then case is ignored.
%
%Example.

% disp(strdist('matlab'))
%    6
% disp(strdist('matlab','Mathworks'))
%    7
% disp(strdist('matlab','Mathworks',2))
%    7    11
% disp(strdist('matlab','Mathworks',2,1))
%    6     9
% Based on
%http://www.mathworks.com/matlabcentral/fileexchange/17585-calculation-of-distance-between-strings/content/strdist.m
switch nargin
   case 1
      d=numel(r);
      return
   case 2
      krk=1;
      bb=b;
      rr=r;
   case 3
       bb=b;
       rr=r;
   case 4
      bb=b;
      rr=r;
      if cas>0
         bb=upper(b);
         rr=upper(r);
      end
end

if krk~=2
   krk=1;
end

d=[];
luma=numel(bb);	lima=numel(rr);
lu1=luma+1;       li1=lima+1;
dl=zeros([lu1,li1]);
dl(1,:)=0:lima;   dl(:,1)=0:luma;
%Distance
for krk1=1:krk
for i=2:lu1
   bbi=bb(i-1);
   for j=2:li1
      kr=krk1;      
      
      if strcmp(rr(j-1),bbi)
         kr=0;
      end
   dl(i,j)=min([dl(i-1,j-1)+kr,dl(i-1,j)+1,dl(i,j-1)+1]);
   end
end
d=[d dl(end,end)];
end


% ties to update the track of errors and corrections of the user.
% This function should be called in the interaction page and update the log
%Table that keeps track of  errors

function LogUpdate(userInput, userSelection)
if logTable(logTable(:,1) == userInput , logTable(:,2) == userSelection )
    logTable(:,3) = logTable(:,3) + 1
else
    logTable(end +1 , 1) = userInput
    logTable(end +1 , 2) = userSelection
    logTable(end +1 , 3) = 1
end



