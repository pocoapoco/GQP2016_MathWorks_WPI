function data = chili(html)
% CHILI extract information from html like searching for meat in your chili
%
% data = chili(urlread('www.mathworks.com'));
%
%

% Translate ASCII HTML into char they represent
html = regexprep(html,'<br>',char(13));
html = removeAccent(html);
html = removeExplicitChar(html);

% Get all href in the doc
[href,idxhref]=regexp(html,'<a href="([^"]*)"','tokens');

%html = regexprep(html,'<a href.*?/a>','');
cat = repmat({'href'},length(idxhref),1);

% If the HTML has a doc type of structure they may use H leveling so
% extract this information from the page
[h,cath,idxh]=extractHeadings(html);
cat = {cat{:},cath{:}}';
idxval=[idxhref,idxh]';
val = {href{:},h{:}}';

% Extract the scripts
% [scripts,scriptcat,idxscripts]=extracttag(html,'script');
% cat = {cat{:},scriptcat{:}}';
% idxval = [idxval',idxscripts]';
% val = {val{:}, scripts{:}}';

% Add title
[title,titlecat,idxtitle]=extracttag(html,'title');
cat = {cat{:},titlecat{:}}';
idxval = [idxval',idxtitle]';
val = {val{:}, title{:}}';

for idx=1:length(idxval)
    val{idx} = regexprep(val{idx},'<[^>]*>',''); % Remove Tags and Attributes
    val{idx} = regexprep(val{idx},'[<>]*',''); % remove special characters
    val{idx} = regexprep(val{idx},['[',char(13),char(10),']*'],''); % Remove Charage Return and Line Feed
    val{idx} = regexprep(val{idx},'  ',' '); % Replace multiple space with single
    val{idx} = strtrim(val{idx}); % Remove leading space
end
cat = categorical(cat);
data=table(cat,val,idxval,'VariableNames',{'cat','val','index'});
data=sortrows(data,'index');

end

function [matchVal,cat,idxVal]=extractHeadings(str)

[matchVal,tokenVal,idxVal]=regexp(str,'<(h\d).*?/(\1)>','match','tokens');
cat = cell(length(idxVal),1);
for idx = 1:length(idxVal)
        cat{idx}=tokenVal{idx}{1};
end
end

function [matchVal,cat,idxVal]=extracttag(str,tag)
% Pull tag out
[matchVal,idxVal]=regexp(str,['<',tag,'.*?/',tag,'>'],'match');
cat = repmat({tag},length(idxVal),1);
end

function newStr = removeAccent(str)
newStr = regexprep(str,'&Aacute;','Á');
newStr = regexprep(newStr,'&aacute;','á');
newStr = regexprep(newStr,'&Agrave;','À');
newStr = regexprep(newStr,'&Acirc;','Â');
newStr = regexprep(newStr,'&agrave;','à');
newStr = regexprep(newStr,'&Acirc;','Â');
newStr = regexprep(newStr,'&acirc;','â');
newStr = regexprep(newStr,'&Auml;','Ä');
newStr = regexprep(newStr,'&auml;','ä');
newStr = regexprep(newStr,'&Atilde;','Ã');
newStr = regexprep(newStr,'&atilde;','ã');
newStr = regexprep(newStr,'&Aring;','Å');
newStr = regexprep(newStr,'&aring;','å');
newStr = regexprep(newStr,'&Aelig;','Æ');
newStr = regexprep(newStr,'&aelig;','æ');
newStr = regexprep(newStr,'&Ccedil;','Ç');
newStr = regexprep(newStr,'&ccedil;','ç');
newStr = regexprep(newStr,'&Eth;','Ð');
newStr = regexprep(newStr,'&eth;','ð');
newStr = regexprep(newStr,'&Eacute;','É');
newStr = regexprep(newStr,'&eacute;','é');
newStr = regexprep(newStr,'&Egrave;','È');
newStr = regexprep(newStr,'&egrave;','è');
newStr = regexprep(newStr,'&Ecirc;','Ê');
newStr = regexprep(newStr,'&ecirc;','ê');
newStr = regexprep(newStr,'&Euml;','Ë');
newStr = regexprep(newStr,'&euml;','ë');
newStr = regexprep(newStr,'&Iacute;','Í');
newStr = regexprep(newStr,'&iacute;','í');
newStr = regexprep(newStr,'&Igrave;','Ì');
newStr = regexprep(newStr,'&igrave;','ì');
newStr = regexprep(newStr,'&Icirc;','Î');
newStr = regexprep(newStr,'&icirc;','î');
newStr = regexprep(newStr,'&Iuml;','Ï');
newStr = regexprep(newStr,'&iuml;','ï ');
newStr = regexprep(newStr,'&Ntilde;','Ñ');
newStr = regexprep(newStr,'&ntilde;','ñ');
newStr = regexprep(newStr,'&Oacute;','Ó');
newStr = regexprep(newStr,'&oacute;','ó');
newStr = regexprep(newStr,'&Ograve;','Ò');
newStr = regexprep(newStr,'&ograve;','ò');
newStr = regexprep(newStr,'&Ocirc;','Ô');
newStr = regexprep(newStr,'&ocirc;','ô');
newStr = regexprep(newStr,'&Ouml;','Ö');
newStr = regexprep(newStr,'&ouml;','ö');
newStr = regexprep(newStr,'&Otilde;','Õ');
newStr = regexprep(newStr,'&otilde;','õ');
newStr = regexprep(newStr,'&Oslash;','Ø');
newStr = regexprep(newStr,'&oslash;','ø');
newStr = regexprep(newStr,'&szlig;','ß');
newStr = regexprep(newStr,'&Thorn;','Þ');
newStr = regexprep(newStr,'&thorn;','þ');
newStr = regexprep(newStr,'&Uacute;','Ú');
newStr = regexprep(newStr,'&uacute;','ú');
newStr = regexprep(newStr,'&Ugrave;','Ù');
newStr = regexprep(newStr,'&ugrave;','ù');
newStr = regexprep(newStr,'&Ucirc;','Û');
newStr = regexprep(newStr,'&ucirc;','û');
newStr = regexprep(newStr,'&Uuml;','Ü');
newStr = regexprep(newStr,'&uuml;','ü');
newStr = regexprep(newStr,'&Yacute;','Ý');
newStr = regexprep(newStr,'&yacute;','ý');
newStr = regexprep(newStr,'&yuml;','ÿ');
newStr = regexprep(newStr,'&copy;','©');
newStr = regexprep(newStr,'&reg;','®');
newStr = regexprep(newStr,'&trade;','™');
newStr = regexprep(newStr,'&amp;','&');
newStr = regexprep(newStr,'&lt;','<');
newStr = regexprep(newStr,'&gt;','>');
newStr = regexprep(newStr,'&euro;','€');
newStr = regexprep(newStr,'&cent;','¢ ');
newStr = regexprep(newStr,'&pound;','£ ');
newStr = regexprep(newStr,'&quot;','"');
newStr = regexprep(newStr,'&lsquo;','‘');
newStr = regexprep(newStr,'&rsquo;','’');
newStr = regexprep(newStr,'&ldquo;','“');
newStr = regexprep(newStr,'&rdquo;','”');
newStr = regexprep(newStr,'&laquo;','«');
newStr = regexprep(newStr,'&raquo;','»');
newStr = regexprep(newStr,'&mdash;','—');
newStr = regexprep(newStr,'&ndash;','–');
newStr = regexprep(newStr,'&deg;','°');
newStr = regexprep(newStr,'&plusmn;','±');
newStr = regexprep(newStr,'&frac14;','¼');
newStr = regexprep(newStr,'&frac12;','½');
newStr = regexprep(newStr,'&frac34;','¾');
newStr = regexprep(newStr,'&times;','×');
newStr = regexprep(newStr,'&divide;','÷');
newStr = regexprep(newStr,'&alpha;','?');
newStr = regexprep(newStr,'&beta;','?');
newStr = regexprep(newStr,'&infin;','?');
newStr = regexprep(newStr,'&nbsp;',' ');
newStr = regexprep(newStr,'&hearts;','&#10084;');

end

function str = removeExplicitChar(str)
% Sometimes people encode special characters using &#(number);
numStr = regexp(str,'&#(\d+);','tokens');
for idx = 1:length(numStr)
    specNum = numStr{idx};
    str = regexprep(str,['&#',specNum{1},';'],char(str2double(specNum{1})));
end

end

function [meta,newval] = extractval(val)

newval = cell(length(val),1);
meta = cell(length(val),1);

for idx=1:length(val)
    workVal = val{idx};
%     if workVal(4)=='>'
%         newval{idx}=workVal(5:end-6);
%         meta{idx}={};
%     else
        startIdx = find(workVal=='<');
        endIdx = find(workVal=='>');
        x=sort([startIdx,endIdx]);
        newval{idx}=workVal(x(floor(length(x)/2))+1:x(floor(length(x)/2)+1)-1);
        meta{idx}=regexp(workVal,' (?<class>[\w\s]*)="(?<val>[^"]*)"','tokens');
        
%     end
   
end

end

% load('.\data\metadata.mat');
% N = height(data);
% 
% schoollist = table;
% 
% for idx = 1:N
%     html = fileread(['.\data\',data.filename{idx}]);
%     htmlData = readHTML(html);
%     if verbose
%         disp(['Working on ',num2str(idx),' of ' num2str(N),' pages. ',htmlData.University{1}])
%     end
%     schoollist(idx,:)=htmlData;
%     data.processed(idx)=1;
% end
% end
%     function data=readHTML(html)
