function summaryTable = getSummaryTable(obj)
% summaryTable
%
% Purpose : generates the summarytable for the given mdtsObject
%
% Syntax :
%
% Input Parameters :
%   obj: and instance of an mdtsObj
%
% Return Parameters :
%   summaryTable: a table containing all summaryTable values for each
%   channel
%
% Description :
%
% Author : 
%    Roland Ritt
%
% History :
% \change{1.0}{13-Sep-2019}{Original}
%
% --------------------------------------------------
% (c) 2019, Roland Ritt
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%%
summaryTable = genSummaryTable(obj.data, obj.tags);