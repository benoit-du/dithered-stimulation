function [names,n] = getFilesInDir(dirName)

%%% 26-01-23    first commit

fList=dir(dirName);
fList([fList.isdir])=[];

names={fList.name};

assert(~isempty(names),['no files in dir ' dirName])

n=length(names);

end