function get4icuwebpages(varargin)

% Constructor
if nargin==0
    verbose = false;
else
    verbose = varargin{1};
end

% Download all the pages and put them in directory
urlList = icuList();
N=length(urlList);
data = table(cell(N,1),cell(N,1),cell(N,1),zeros(N,1),...
    'VariableNames',{'filename','url','downloaddate','processed'});

if ~isdir('data')
    mkdir('data');
end

for idx = 1:length(urlList)
    fileName = urlList{idx}{:};
    url = ['http://www.4icu.org',fileName];
    fileName = regexp(fileName,'/[\w\d]*.htm','match');
    fileName = fileName{1}(2:end);
    
    if verbose, disp(['Working on ',url]); end
    try
        urlwrite(url,['.',filesep,'data',filesep,fileName]);
    catch
    end
    downloaddate = now();
    data(idx,:)={{fileName},{url},{downloaddate},0};
end
save(['.',filesep,'data',filesep,'metadata.mat'],'data');
end

function fullhreflist = icuList()
% Pull in all the review pages to find all the universities webpages.

html = webread('http://www.4icu.org/reviews/index0001.htm');
idxhref = getIndexLinks(html);
fullhreflist = {};
for idx = 1:length(idxhref)
    html = webread(['http://www.4icu.org/reviews/',idxhref{idx}{:}]);
    href = getReviewLinks(html);
    fullhreflist = [fullhreflist,href]; %#ok<AGROW>
end

end

function idxhref = getIndexLinks(html)
% Find all the hrefs with text "index" into it
hreflinks = regexp(html,'<a href="([^"]*)">','tokens');
idxReview = false(1,length(hreflinks));
for idx=1:length(hreflinks)
    if strncmp('index',hreflinks{idx},length('index'))
        idxReview(idx)=true;
    end
end
idxhref=hreflinks(idxReview);
end


function href = getReviewLinks(html)
hreflinks = regexp(html,'<a href="([^"]*)">','tokens');
idxReview = false(1,length(hreflinks));
for idx=1:length(hreflinks)
    if strncmp('/reviews',hreflinks{idx},length('/reviews'))
        idxReview(idx)=true;
    end
end
href=hreflinks(idxReview);
end

