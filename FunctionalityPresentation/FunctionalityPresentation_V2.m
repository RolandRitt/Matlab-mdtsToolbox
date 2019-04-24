%% Demonstrate the use of mdtsObject
% 
% Description : This script should demonstrate the functionality of the
% provided mdts-Toolbox
%
% Author : 
%    Roland Ritt
%
% History :
% \change{1.0}{06-Aug-2018}{Original}
%
% --------------------------------------------------
% (c) 2018, Roland Ritt
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%% SetUp Workspace
clear all;
close all hidden;
clc;

%% Initialize mdtsObject - absolute Datetime
n=1000;
%generate dataset
x = linspace(datetime(2017,1,1), datetime(2018,1,1),n)'; %datetime - xvalues
xy = linspace(0,2*pi,n)';
y1 = sin(xy);
y2 = cos(xy);
y3 = tan(xy);
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';

mymdtsObject = mdtsObject(x,D, tags, 'name', name); % initialize mdtsObject
plotmdtsObject(mymdtsObject);   % plot the object


%% Initialize mdtsObject - Durations
n=1000;
%generate dataset
x = minutes(1).*(1:n)';
xy = linspace(0,2*pi,n)';
y1 = sin(xy);
y2 = cos(xy);
y3 = tan(xy);
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';
% initialize mdtsObject
mymdtsObject = mdtsObject(x,D, tags, 'name', name); 
plotmdtsObject(mymdtsObject);   % plot the object

%% Initialize mdtsObject - numeric values
n=1000;
%generate dataset
x = linspace(0,2*pi,n)';
y1 = sin(x);
y2 = cos(x);
y3 = tan(x);
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';
% initialize mdtsObject
mymdtsObject = mdtsObject(x,D, tags, 'name', name); 
plotmdtsObject(mymdtsObject);   % plot the object


%% Extract subset from mdts - direct Indexing
n=1000;
%generate dataset
x = linspace(datetime(2017,1,1), datetime(2018,1,1),n)'; %datetime - xvalues
xy = linspace(0,2*pi,n)';
y1 = sin(xy);
y2 = cos(xy);
y3 = tan(xy);
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';

% initialize mdtsObject
mymdtsObject = mdtsObject(x,D, tags, 'name', name); 

%slice
timeInds = (200:800);
tagInds = [2,3];
mymdtsObjectSnippet = mymdtsObject(timeInds,tagInds);

%plot
plotmdtsObject(mymdtsObjectSnippet);   % plot the object


%% Extract subset from mdts - Using Functions
n=1000;
%generate dataset
x = linspace(datetime(2017,1,1), datetime(2018,1,1),n)'; %datetime - xvalues
xy = linspace(0,2*pi,n)';
y1 = sin(xy);
y2 = cos(xy);
y3 = tan(xy);
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';

% initialize mdtsObject
mymdtsObject = mdtsObject(x,D, tags, 'name', name); 

%slice
timeSnippet = [datetime(2017,3,15), datetime(2017,10,31)];
tagsSnippet = {'y_3', 'y_2'};
mymdtsObjectSnippet = mymdtsObject.getData(tagsSnippet, timeSnippet);

%plot
plotmdtsObject(mymdtsObjectSnippet);   % plot the object


%% Extract data from mdts - DirectIndexing of dataField
n=1000;
%generate dataset
x = linspace(datetime(2017,1,1), datetime(2018,1,1),n)'; %datetime - xvalues
xy = linspace(0,2*pi,n)';
y1 = sin(xy);
y2 = cos(xy);
y3 = tan(xy);
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';

% initialize mdtsObject
mymdtsObject = mdtsObject(x,D, tags, 'name', name); 

%slice
timeInds = (200:800);
tagInds = [2,3];
dataExtracted = mymdtsObject.data(timeInds, tagInds);

%% Extract data from mdts - Using Functions
n=1000;
%generate dataset
x = linspace(datetime(2017,1,1), datetime(2018,1,1),n)'; %datetime - xvalues
xy = linspace(0,2*pi,n)';
y1 = sin(xy);
y2 = cos(xy);
y3 = tan(xy);
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';

% initialize mdtsObject
mymdtsObject = mdtsObject(x,D, tags, 'name', name); 

%slice
timeSnippet = [datetime(2017,3,15), datetime(2017,10,31)];
tagsSnippet = {'y_3', 'y_2'};
dataExtracted = mymdtsObject.getRawData(tagsSnippet, timeSnippet);


%% Add data to mdts - Using Functions
n=1000;
%generate dataset
x = linspace(datetime(2017,1,1), datetime(2018,1,1),n)'; %datetime - xvalues
xy = linspace(0,2*pi,n)';
y1 = sin(xy);
y2 = cos(xy);
y3 = tan(xy);
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';

% initialize mdtsObject
mymdtsObject = mdtsObject(x,D, tags, 'name', name); 

%add data to mdtsObject
y_cosh = cosh(xy);
y_sinh = sinh(xy);
data_expand = [y_cosh, y_sinh];
tags_expand = {'cosh', 'sinh'};

mymdtsObject.expandDataSet(data_expand, tags_expand);
plotmdtsObject(mymdtsObject);

%% Add events to mdts - Using Functions
n=1000;
%generate dataset
x = linspace(datetime(2017,1,1), datetime(2018,1,1),n)'; %datetime - xvalues
xy = linspace(0,2*pi,n)';
y1 = sin(xy);
y2 = cos(xy);
y3 = tan(xy);
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';

% initialize mdtsObject
mymdtsObject = mdtsObject(x,D, tags, 'name', name); 

event1time = x(700);
event1ID = 'event 1';
event1duration = seconds(5);

event2time = x(500);
event2ID = 'event 2';
event2duration = seconds(3);

mymdtsObject.addEvent(event1ID,event1time,event1duration);
mymdtsObject.addEvent(event2ID,event2time,event2duration);
plotmdtsObject(mymdtsObject);


%% perform calculation - compute 1
n=1000;
%generate dataset
x = linspace(datetime(2017,1,1), datetime(2018,1,1),n)'; %datetime - xvalues
xy = linspace(0,2*pi,n)';
y1 = sin(xy);
y2 = cos(xy);
y3 = tan(xy);
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';

% initialize mdtsObject
mymdtsObject = mdtsObject(x,D, tags, 'name', name); 
ls = 5;

[B,dB] = dop(ls);
DMat = dB*B';

input1.tag = 'y_1';
input1.object= mymdtsObject;

dy_1 = compute1(DMat, input1);
mymdtsObject.expandDataSet(dy_1, 'dy_1');

plotmdtsObject(mymdtsObject);


%% perform calculation - compute1scalar
n=1000;
%generate dataset
x = linspace(datetime(2017,1,1), datetime(2018,1,1),n)'; %datetime - xvalues
xy = linspace(0,2*pi,n)';
y1 = sin(xy);
y2 = cos(xy);
y3 = tan(xy);
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';

% initialize mdtsObject
mymdtsObject = mdtsObject(x,D, tags, 'name', name); 

input1.tag = 'y_1';
input1.object= mymdtsObject;
operator = '+';
scalarVal = 5;

y_15 = compute1Scalar(operator, scalarVal,input1);
mymdtsObject.expandDataSet(y_15, 'y_1+5');

plotmdtsObject(mymdtsObject);


%% perform calculation - compute2
n=1000;
sigma = 0.1;
%generate dataset
x = linspace(datetime(2017,1,1), datetime(2018,1,1),n)'; %datetime - xvalues
xy = linspace(0,2*pi,n)';
y1 = sin(xy) + randn(size(x))*sigma;
y2 = cos(xy)+ randn(size(x))*sigma;
y3 = tan(xy)+ randn(size(x))*sigma;
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';

% initialize mdtsObject
mymdtsObject = mdtsObject(x,D, tags, 'name', name); 


input1.tag = 'y_1';
input1.object= mymdtsObject;
input2.tag = 'y_2';
input2.object = mymdtsObject;

operator = 'xcorr';
 
xcorry_12 = compute2(operator, input1, input2);
 
figureGen;
plot(xcorry_12);
title('xcorr');

%% perform calculation - smoothAsConv
n=1000;
sigma = 0.1;
%generate dataset
x = linspace(datetime(2017,1,1), datetime(2018,1,1),n)'; %datetime - xvalues
xy = linspace(0,2*pi,n)';
y1 = sin(xy) + randn(size(x))*sigma;
y2 = cos(xy)+ randn(size(x))*sigma;
y3 = tan(xy)+ randn(size(x))*sigma;
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';

% initialize mdtsObject
mymdtsObject = mdtsObject(x,D, tags, 'name', name); 


input1.tag = 'y_1';
input1.object= mymdtsObject;
y1s = smoothAsConv(input1, 'ls', 11, 'noBfs', 3);
mymdtsObject.expandDataSet(y_15, 'y_1s');
plotmdtsObject(mymdtsObject);

%% perform calculation - computeFind
n=1000;
sigma = 0.1;
%generate dataset
x = linspace(datetime(2017,1,1), datetime(2018,1,1),n)'; %datetime - xvalues
xy = linspace(0,2*pi,n)';
y1 = sin(xy) ;
y2 = cos(xy);
y3 = tan(xy);
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';

% initialize mdtsObject
mymdtsObject = mdtsObject(x,D, tags, 'name', name); 


input1.tag = 'y_1';
input1.object= mymdtsObject;

valueComp = 0.5;

ruleRes = computeFind('<', input1, valueComp);
mymdtsObject.expandDataSet(ruleRes, '<0.5');

plotmdtsObject(mymdtsObject);

%% perform calculation - computeRule
n=1000;
sigma = 0.1;
%generate dataset
x = linspace(datetime(2017,1,1), datetime(2018,1,1),n)'; %datetime - xvalues
xy = linspace(0,2*pi,n)';
y1 = sin(xy) ;
y2 = cos(xy);
y3 = tan(xy);
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';

% initialize mdtsObject
mymdtsObject = mdtsObject(x,D, tags, 'name', name); 


input1.tag = 'y_1';
input1.object= mymdtsObject;
input2.tag = 'y_2';
input2.object=mymdtsObject;

valueComp1 = 0.5;
valueComp2 = 0;

findRes1 = computeFind('>', input1, valueComp1);
findRes2 = computeFind('<', input2, valueComp2);

ruleOperator = '&';
ruleRes = computeRule(ruleOperator, findRes1, findRes2);

mymdtsObject.expandDataSet(ruleRes, 'rule');

plotmdtsObject(mymdtsObject);



%% perform segmentation
n=1000;
sigma = 0.1;
%generate dataset
x = linspace(datetime(2017,1,1), datetime(2018,1,1),n)'; %datetime - xvalues
xy = linspace(0,2*pi,n)';
y1 = sin(xy) ;
y2 = cos(xy);
y3 = tan(xy);
D = [y1,y2, y3]; %concatenate data to matrix
tags = {'y_1', 'y_2', 'y_3'} %define the tag names (channel names)
name = 'Dataset 1';

% initialize mdtsObject
mymdtsObject = mdtsObject(x,D, tags, 'name', name); 


input1.tag = 'y_1';
input1.object= mymdtsObject;

valueComp1 = 0.5;


findRes1 = computeFind('<', input1, valueComp1);

nRow = length(mymdtsObject.time);
mySeg1 = segmentsObject(nRow);
segTag = 'segment1';
mySeg1 =mySeg1.addSegmentVector(segTag, findRes1);
mymdtsObject.addSegments(mySeg1);

plotSegments(mymdtsObject, segTag);

segsMdtsObjects = extractSegments(mymdtsObject, segTag);
for i=1:length(segsMdtsObjects)
    plotmdtsObject(segsMdtsObjects{i});
end

