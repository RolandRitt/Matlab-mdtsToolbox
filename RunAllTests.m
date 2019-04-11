%% Run Tests in mdtsToolbox
% Run all tests which belong to the toolbox and renturn the results

allTests = {};

%% Summarize all Tests

% mdtsCoreObject

allTests = [allTests; 'mdtsCoreObjectTestClass'];

% mdtsObject

allTests = [allTests; 'mdtsObjectTestClass'];

% Symbolic Representation

allTests = [allTests; 'applyMCLATestClass'];
allTests = [allTests; 'symbRepChannelTestClass'];
allTests = [allTests; 'SymbRepObjectTestClass'];
allTests = [allTests; 'plotSymRepObjectOnAllAxesTestClass'];
allTests = [allTests; 'plotSymRepObjectOnAxesTestClass'];


% Calculation Functions

allTests = [allTests; 'compute1ScalarTestClass'];
allTests = [allTests; 'compute1TestClass'];
allTests = [allTests; 'compute2TestClass'];
allTests = [allTests; 'isValidInputTestClass'];
allTests = [allTests; 'LDOasConvTestClass'];
allTests = [allTests; 'smoothAsConvTestClass'];

% Segmentation

allTests = [allTests; 'segmentsObjectTestClass'];
allTests = [allTests; 'plotSegmentsTestClass'];
allTests = [allTests; 'extractSegmentsTestClass'];

% Reporting

allTests = [allTests; 'genModeListTestClass'];
allTests = [allTests; 'ReportObjectTestClass'];

% Illustration

allTests = [allTests; 'plotmdtsObjectTestClass'];

%% Run Tests

results = runtests(allTests)