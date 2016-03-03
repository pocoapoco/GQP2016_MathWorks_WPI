function varargout = process4icuwebsite(varargin)
% Process the 4ICU website into a table of data and return it
% This file assumes that you have created a table with a list of files to
% be processed.  It assumeds you called get4icuwebpages before calling this
% file.

if nargin==0
    verbose = false;
else
    verbose = varargin{1};
end
load(['.',filesep,'data',filesep,'metadata.mat']);
N = height(data);

schoollist = table;

for idx = 1:N
    html = fileread(['.',filesep,'data',filesep,data.filename{idx}]);
    htmlData = readHTML(html);
    if verbose
        disp(['Working on ',num2str(idx),' of ' num2str(N),' pages. ',htmlData.UniversityName{:}])
    end
    if idx==1
        schoollist=htmlData;
    else
        schoollist = tunion(schoollist,htmlData,'cell');
    end
    data.processed(idx)=1;
end

% save datameta to say we processed the files
save(['.',filesep,'data',filesep,'metadata.mat'],'data');
save(['.',filesep,'data',filesep,'schoollist.mat'],'schoollist');

if nargout>0
    varargout{1} = schoollist;
end

end

function data = readHTML(html)

data = chili(html);
val = data;
val.newcat = val.cat;

for idx=1:height(data)
    
    switch(data.cat(idx))
        case 'href'
            if strfind(data.val{idx}{:},'http')
                if strfind(lower(data.val{idx}{:}),'4icu')
                    val.newcat(idx) = 'InternalReference';
                elseif strfind(lower(data.val{idx}{:}),'wikipedia')
                    val.newcat(idx) = 'Wikipedia';
                elseif strfind(lower(data.val{idx}{:}),'facebook')
                    val.newcat(idx) = 'Facebook';
                elseif strfind(lower(data.val{idx}{:}),'google')
                    val.newcat(idx) = 'Google';
                elseif strfind(lower(data.val{idx}{:}),'xe.com')
                    val.newcat(idx) = 'InternalReference'; % Really and Ad
                else
                    val.newcat(idx) = 'ExternalReference';
                end
            else
                val.newcat(idx) = 'InternalReference';
            end
        case 'h4'
            mask = zeros(height(data),1);
            mask(idx:end)=1;
            val.newcat(val.cat=='h5'&mask)=regexprep(data.val{idx},'[^\w\d]*','');
        case 'h3'
            val.newcat(idx) = 'UniveristyName2';
        case 'h2'
            val.newcat(idx) = 'UniversityLocalName';
        case 'title'
            val.newcat(idx) = 'pagetitle';
        otherwise
    end
       
end

% Now remove data we don't care about
val(val.cat=='h4',:)=[];
val(val.newcat=='h5',:)=[];
val(val.cat=='h6',:)=[];
val(val.newcat=='InternalReference',:)=[];


val.newcat(strcmp(val.newcat,'NameinEnglish')) = 'EnglishName';

mask = zeros(height(val),1);
mask(1:8)=1;
val.newcat(val.newcat=='ExternalReference'&mask)='URL';

idx = find(val.newcat=='Populationrange');
val(idx(2:end),:)=[];
val(val.newcat=='COURSELEVELSANDAREASOFSTUDIES',:)=[];
val(val.newcat=='YEARLYTUITIONRANGE',:)=[];
val(val.newcat=='ACADEMICSTRUCTURE',:)=[];
val(val.newcat=='AFFILIATIONSANDMEMBERSHIPS',:)=[];
val(val.newcat=='VIDEOPRESENTATION',:)=[];
idx = find(val.newcat=='Address');
val.newcat(idx(1))= 'Street';
val.newcat(idx(2))= 'City';
val.newcat(idx(3))= 'StateZip';
val.newcat(idx(4))= 'Country';

val.cat = [];
val.index = [];

data = table;
for idx=1:height(val)
    data.(char(val.newcat(idx))) = val.val(idx);
end

% Pull Zipcode and State apart
Zipcode =regexp(data.StateZip,'^([\d-]*)','tokens');
State =regexp(data.StateZip,'^[\d-\s]*([\w\d\s]*)','tokens');
if ~isempty(Zipcode{1})
    data.Zipcode(1) = Zipcode{1};
else
    data.Zipcode(1) = {''};
end
if ~isempty(State{1})
    data.State(1) = State{1};
else
    data.State(1) = {''};
end

end
