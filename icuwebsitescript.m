%Background script for getting all the web pages from 4ICU
disp('Save all the webpages locally');
%%get4icuwebpages(false);

%% Process Webpages 
disp('Process webpages saved');
process4icuwebsite(false);

%%disp('Exiting Normally');
%%exit