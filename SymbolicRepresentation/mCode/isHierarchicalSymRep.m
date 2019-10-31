function bTrue = isHierarchicalSymRep(hierarchicalSymbolicData)
% <keywords>
%
% Purpose : verify if given input is a hierarchicalSymbolicData used in
% genHierarchicalCompounding
%
% Syntax :
%
% Input Parameters :
%   hierarchicalSymbolicData := a hierarical representation of
%
% Return Parameters :
%   bTrue := returns true if input is valid hierachical symbolic representation
%
% Description :
%
% Author :
%    Roland Ritt
%
% History :
% \change{1.0}{19-Dec-2017}{Original}
%
% --------------------------------------------------
% (c) 2017, Roland Ritt
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%%

bTrue = false;
try
    if ~iscell(hierarchicalSymbolicData)
        return;
    end
    
    
    for i=1:length(hierarchicalSymbolicData)
        if ~isa(hierarchicalSymbolicData{i}, 'SymbRepObject')
            return;
        end
    end

    bTrue = true;
catch
    bTrue = false;
end
