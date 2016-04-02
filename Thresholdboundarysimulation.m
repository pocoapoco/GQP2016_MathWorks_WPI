function Thresholdboundarysimulation(data , testData) 


cellData = table2cell(data(:,2))
cellString = cellstr(cellData) 
DataStringFormat= char(cellString)


cellTestData = table2cell(testData(:,2))
cellTestString = cellstr(cellTestData) 
testDataStringFormat= char(cellTestString)
testDataStringFormat = testDataStringFormat(ismember(testDataStringFormat(:,5) , 'UNITED STATES') , :)

notMatchedCounter = 0
n=0;
sRellevent = zeros(size(testDataStringFormat,1) , 1 );
sIrrellevent = zeros(size(testDataStringFormat,1) , 1 );
minRellevent = 1000;
maxIrrelevent = 0;

for i=1:size(testDataStringFormat,1)
    
[distances , cl] = confidenceLevel (testDataStringFormat(i,:) , data(:,:))
equalWords = zeros( size(cl,1) ,1 )
cl(1:3,:)
testDataStringFormat(i,:)
%equalWords( ismember(strtrim(cl(:,:)) , strtrim(testDataStringFormat(i,:)) ) , 1) = 1;
equalWords( strmatch( strtrim(testDataStringFormat(i,:)) , strtrim(cl(:,:))   ) , 1) = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% % This is the main calculatin of the threshold
% if sum(equalWords) == 0
%     notMatchedCounter= notMatchedCounter + 1;
% 
% else 
%     
%     n=n+1;
%     lastOne = 0;
%     isNextZero = false;
%     while (isNextZero == false)
%         lastOne = lastOne + 1;
%         if (equalWords(lastOne+1) == 0)
%             isNextZero = true;
%         end
%             
%     end
%     sRellevent(n) = cl(lastOne);
%     sIrrellevent(n) = cl(lastOne + 1);
%     
%     if cl(lastOne) < minRellevent
%         minRellevent = cl(lastOne)
%     end
%     
% 
%     if cl(lastOne+1) > maxIrrelevent
%         maxIrrelevent = cl(lastOne+1);
%     end    
%     
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%THis is a test part should be checked !!!!!!!!!
n=n+1;
sRellevent(n) = distances(1);
sIrrellevent(n) = distances(2);
    
if distances(1) < minRellevent
   minRellevent = distances(1)
end
    

if distances(2) > maxIrrelevent
    maxIrrelevent = distances(2);
end    


end   

h= 0.05
[tBestMinimum, tBestMaximum] = ThresholdCalculation(n, minRellevent,maxIrrelevent,sRellevent(1:n,1),sIrrellevent(1:n,1),h)


end
  



    


function [ scores , CL1 ]  = confidenceLevel(universityName ,  data)
%result = arrayfun(strdist, data(:,3) ,  repmat( universityName , size(data,2),1 ) , repmat( 2 , size(data,2),1 ) , repmat( 1 , size(data,2),1 ) )

cellArrayData = table2cell(data(:,2))
cellSrtingData = cellstr(cellArrayData)
charArrayData = char(cellSrtingData)


for i=1:size(charArrayData,1)
    distance(i,:) = strdist(strtrim(universityName) , strtrim(charArrayData(i,:)) , 2);
end

sortedDistance = sort(distance , 1, 'ascend')

[a1,b1] = min(distance(:,1));
%[a2,b2] = min(distance(:,2));


CL1 = charArrayData(ismember(distance(:,1) , sortedDistance(1:20,1))  , :)
%CL2 = charArrayData(distance(:,2) == a2(1,1)   , :)
scores = sortedDistance(1:20,1)

%CompleteInformation  = charArrayData(distance(:,1) == a1(1,1)   , :)
%CompleteInformation  = charArrayData(distance(:,1) == a1(1,1)   , :)
end


function [d,A]=strdist(r,b,krk,cas)
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
end








function [tBestMinimum, tBestMaximum] = ThresholdCalculation(n, tmin,tmax,sRelevent,sIrrelevent,h)


fmax = -2*n;
ndiv = (tmax - tmin)/h
for i = 1:ndiv 
    t = tmin + (i*h);
    ft = 0;

    for k= 1 : n
        d = 0;
        if (sRelevent(k,1) > t) 
            d = d + 1;
        else
            d = d - 1;
        end 
        if (sIrrelevent(k,1) < t) 
            d = d + 1;
        else
            d = d - 1;
        end 
        ft = ft + d;
    end
    if (ft > fmax)
        fmax = ft;
    end 
end

t = tmin


while rewardFunction(t, sRelevent ,sIrrelevent) ~= fmax
    t = t + h;
    a = rewardFunction(t, sRelevent ,sIrrelevent)
end

tBestMinimum = t
t = tmax


while rewardFunction(t, sRelevent ,sIrrelevent) ~= fmax
    t = t - h;
end

tBestMaximum = t
if fmax < 0 
    aux = tBestMaximum
    tBestMaximum = tBestMinimum
    tBestMinimum = tBestMaximum 
end
end


function  result = rewardFunction(t , sRelevent , sIrrelevent )
sReleventCopy = sRelevent
sReleventCopy(sReleventCopy > t) = 1;
sReleventCopy(sReleventCopy <= t) = -1;

sIreleventCopy  = sIrrelevent
sIreleventCopy(sIreleventCopy >= t) = -1;
sIreleventCopy(sIreleventCopy < t) = 1;

result = sum (sReleventCopy + sIreleventCopy);

end