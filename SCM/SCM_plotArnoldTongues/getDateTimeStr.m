function outputStr = getDateTimeStr()
%%% 26-01-23    first commit

formatOut = 'dd-mmm-yy_HH-MM-ss';
outputStr = datestr(clock,formatOut);

end

