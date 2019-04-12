n = 1000;
x = linspace(0,2*pi, n)';
xdT = linspace(datetime(2018,09,11), datetime(2018,09,12), n );
D(:,1) = cos(x);
D(:,2) = sin(x);
D(:,3) = tan(x);
D(:,4) = exp(x);


tags = {'cos', 'sin', 'tan', 'exp'};
mdtsObj = mdtsObject(x,D, tags);

segs = segmentsObject(n);
segs = segs.addSegmentVector('cosPos', logical(D(:,1)>0.3));
segs = segs.addSegmentVector('cosNeg', logical(D(:,1)<-0.3));


ax_out = plotmdtsObject(mdtsObj);


input1.object = mdtsObj;
input1.tag = 'cos';
alphabet1 = {'a', 'b', 'c','d','e'};
edges1 = [linspace(-1,1, 6)];

symbObj1 = symbRepChannel(input1, edges1, alphabet1);  

input2.object = mdtsObj;
input2.tag = 'sin';
alphabet2 = {'a', 'b', 'c','d','e'};
edges2 = [linspace(-1,1, 6)];

symbObj2 = symbRepChannel(input2, edges2, alphabet2);  

 
mdtsObj.addSymbRepToChannel(1,symbObj1);
mdtsObj.addSymbRepToChannel(2,symbObj2);
  
 
ax_out = plotmdtsObject(mdtsObj);

%% plot segments

segs.plotOnAxes( ax_out(mdtsObj.getTagIndices('tan')), mdtsObj.timeInFormat);

segs.plotOnAxes(ax_out(mdtsObj.getTagIndices('exp')), mdtsObj.timeInFormat, 'segmentTags', 'cosNeg');