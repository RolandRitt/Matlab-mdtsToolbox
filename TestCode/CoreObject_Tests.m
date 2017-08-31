%% TestCases for CoreObject class
%
% Description : Test the CoreObject class
%
% Author :
%    Paul O'Leary
%    Roland Ritt
%    Thomas Grandl
%
% History :
% \change{1.0}{31-Jul-2017}{Original}
%
% --------------------------------------------------
% (c) 2017, Paul O'Leary
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%

%% Test 1: Create object with constructor
% uniform

ts = duration(0, 0, 0, 50);
time = [datenum(datetime(2017, 7, 31, 14, 3, 123 + 0 * seconds(ts)));
        datenum(datetime(2017, 7, 31, 14, 3, 123 + 1 * seconds(ts)));
        datenum(datetime(2017, 7, 31, 14, 3, 123 + 2 * seconds(ts)));
        datenum(datetime(2017, 7, 31, 14, 3, 123 + 3 * seconds(ts)))];
data = [9, 8;
        7, 6;
        8, 7;
        6, 5];
tags = {'Channel 1'; 'Channel2'};
units = {'s', 'min'};
name = 'TS-Test';
who = 'Operator';
when = 'Now';
description = {'This is a TS-Test'; 'with two text lines'};
comment = {'This is'; 'a comment'};

returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);

assert(isequal(returns.time, time), 'Time was not stored correctly');
assert(isequal(returns.data, data), 'Data was not stored correctly');
assert(isequal(returns.tags, tags), 'Tags were not stored correctly');
assert(isequal(returns.units, units), 'Units were not stored correctly');
assert(isequal(returns.ts, ts), 'Duration was not stored correctly');
assert(isequal(returns.uniform, 1), 'Uniformity was set incorrectly');
assert(isequal(returns.name, name), 'Name was not stored correctly');
assert(isequal(returns.who, who), 'Who was not stored correctly');
assert(isequal(returns.when, when), 'When was not stored correctly');
assert(isequal(returns.description, description), 'Description was not stored correctly');
assert(isequal(returns.comment, comment), 'Comment was not stored correctly');

assert(isequal(returns.fs, duration(0, 0, 1 / seconds(ts))), 'fs was not computed correctly');
assert(isequal(returns.timeRelative, time - time(1)), 'Relative time was not computed correctly');

%% Test 2: Create object with constructor
% non uniform

ts = [];
time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123));
        datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 50));
        datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 62));
        datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 99))];
data = [9, 8;
        7, 6;
        8, 7;
        6, 5];
tags = {'Channel 1'; 'Channel2'};
units = {'s', 'min'};
name = 'TS-Test';
who = 'Operator';
when = 'Now';
description = {'This is a TS-Test'; 'with two text lines'};
comment = {'This is'; 'a comment'};

returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);

assert(isequal(returns.time, time), 'Time was not stored correctly');
assert(isequal(returns.data, data), 'Data was not stored correctly');
assert(isequal(returns.tags, tags), 'Tags were not stored correctly');
assert(isequal(returns.units, units), 'Units were not stored correctly');
assert(isequal(returns.ts, ts), 'Duration was not stored correctly');
assert(isequal(returns.uniform, 0), 'Uniformity was set incorrectly');
assert(isequal(returns.name, name), 'Name was not stored correctly');
assert(isequal(returns.who, who), 'Who was not stored correctly');
assert(isequal(returns.when, when), 'When was not stored correctly');
assert(isequal(returns.description, description), 'Description was not stored correctly');
assert(isequal(returns.comment, comment), 'Comment was not stored correctly');

assert(isequal(returns.timeRelative, time - time(1)), 'Relative time was not computed correctly');

%% Test 3: get Data from Object - nargin = 0

ts = duration(0, 0, 0, 50);
time = [datenum(datetime(2017, 7, 31, 14, 3, 123 + 0 * seconds(ts)));
        datenum(datetime(2017, 7, 31, 14, 3, 123 + 1 * seconds(ts)));
        datenum(datetime(2017, 7, 31, 14, 3, 123 + 2 * seconds(ts)));
        datenum(datetime(2017, 7, 31, 14, 3, 123 + 3 * seconds(ts)))];
data = [9, 8, 7, 6;
        7, 6, 5, 4;
        8, 7, 6, 5;
        6, 5, 4, 3];
tags = {'Channel 1'; 'Channel 2'; 'Channel 3'; 'Channel 4'};
units = {'s', 'min', 'elephants', 'giraffes'};
name = 'TS-Test';
who = 'Operator';
when = 'Now';
description = {'This is a TS-Test'; 'with two text lines'};
comment = {'This is'; 'a comment'};

returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
returnObject = returns.getData;

assert(isequal(returnObject.time, time), 'Time was not stored correctly');
assert(isequal(returnObject.data, data), 'Data was not stored correctly');
assert(isequal(returnObject.tags, tags), 'Tags were not stored correctly');
assert(isequal(returnObject.units, units), 'Units were not stored correctly');

%% Test 4: get Data from Object - nargin = 1

ts = duration(0, 0, 0, 50);
time = [datenum(datetime(2017, 7, 31, 14, 3, 123 + 0 * seconds(ts)));
        datenum(datetime(2017, 7, 31, 14, 3, 123 + 1 * seconds(ts)));
        datenum(datetime(2017, 7, 31, 14, 3, 123 + 2 * seconds(ts)));
        datenum(datetime(2017, 7, 31, 14, 3, 123 + 3 * seconds(ts)))];
data = [9, 8, 7, 6;
        7, 6, 5, 4;
        8, 7, 6, 5;
        6, 5, 4, 3];
tags = {'Channel 1'; 'Channel 2'; 'Channel 3'; 'Channel 4'};
units = {'s', 'min', 'elephants', 'giraffes'};
name = 'TS-Test';
who = 'Operator';
when = 'Now';
description = {'This is a TS-Test'; 'with two text lines'};
comment = {'This is'; 'a comment'};

columnsToExtract = [2, 4];
tagsToExtract = tags(columnsToExtract);
dataToExtract = data(:, columnsToExtract);
unitsToExtract = units(:, columnsToExtract);

returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
returnObject = returns.getData(tagsToExtract);

assert(isequal(returnObject.time, time), 'Time was not extracted correctly');
assert(isequal(returnObject.data, dataToExtract), 'Data was not extracted correctly');
assert(isequal(returnObject.tags, tagsToExtract), 'Tags were not extracted correctly');
assert(isequal(returnObject.units, unitsToExtract), 'Units were not extracted correctly');

%% Test 5: get Data from Object - nargin = 2

ts = duration(0, 0, 0, 50);
time = [datenum(datetime(2017, 7, 31, 14, 3, 123 + 0 * seconds(ts)));
        datenum(datetime(2017, 7, 31, 14, 3, 123 + 1 * seconds(ts)));
        datenum(datetime(2017, 7, 31, 14, 3, 123 + 2 * seconds(ts)));
        datenum(datetime(2017, 7, 31, 14, 3, 123 + 3 * seconds(ts)))];
data = [9, 8, 7, 6;
        7, 6, 5, 4;
        8, 7, 6, 5;
        6, 5, 4, 3];
tags = {'Channel 1'; 'Channel 2'; 'Channel 3'; 'Channel 4'};
units = {'s', 'min', 'elephants', 'giraffes'};
name = 'TS-Test';
who = 'Operator';
when = 'Now';
description = {'This is a TS-Test'; 'with two text lines'};
comment = {'This is'; 'a comment'};

columnsToExtract = [2, 4];
linesToExtract = [2 : 3];
timeToExtract = time(linesToExtract);
tagsToExtract = tags(columnsToExtract);
dataToExtract = data(linesToExtract, columnsToExtract);
unitsToExtract = units(:, columnsToExtract);

returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
returnObject = returns.getData(tagsToExtract, timeToExtract);

assert(isequal(returnObject.time, timeToExtract), 'Time was not extracted correctly');
assert(isequal(returnObject.data, dataToExtract), 'Data was not extracted correctly');
assert(isequal(returnObject.tags, tagsToExtract), 'Tags were not extracted correctly');
assert(isequal(returnObject.units, unitsToExtract), 'Units were not extracted correctly');

%% Test 6: get Tag Indices

ts = duration(0, 0, 0, 50);
time = [datenum(datetime(2017, 7, 31, 14, 3, 123 + 0 * seconds(ts)));
        datenum(datetime(2017, 7, 31, 14, 3, 123 + 1 * seconds(ts)));
        datenum(datetime(2017, 7, 31, 14, 3, 123 + 2 * seconds(ts)));
        datenum(datetime(2017, 7, 31, 14, 3, 123 + 3 * seconds(ts)))];
data = [9, 8, 7, 6;
        7, 6, 5, 4;
        8, 7, 6, 5;
        6, 5, 4, 3];
tags = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
units = {'s', 'min', 'elephants', 'giraffes'};
name = 'TS-Test';
who = 'Operator';
when = 'Now';
description = {'This is a TS-Test'; 'with two text lines'};
comment = {'This is'; 'a comment'};

columnsToExtract = [2, 4];
tagsToExtract = tags(columnsToExtract);

returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
tagIndices = returns.getTagIndices(tagsToExtract);

assert(isequal(tagIndices, columnsToExtract), 'Indices were not extracted correctly');

