function ruleElements = computeRule(operator, conformElements1, conformElements2)
% boolean operations, segmentation
%
% Purpose : compute a rule given by the operator
%
% Syntax :
%   ruleElements = computeRule(operator, conformElements1, conformElements2)
%
% Input Parameters :
%   operator : rule operator as string. Available options: &, |
%
%   conformElements1, conformElements2 : logical arrays which represent a
%   condition applied to a data set
%
% Return Parameters :
%   ruleElements : logical array which indicates the rule conform 
%       elements
%
% Description : 
%   Finds all elements of which apply to the rule according to the
%   operator
%
% Author : 
%   Paul O'Leary
%   Roland Ritt
%   Thomas Grandl
%
% History :
% \change{1.0}{29-Dec-2017}{Original}
%
% --------------------------------------------------------
% (c) 2017 Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
% --------------------------------------------------------
%
%% Validate inputs

if ~(islogical(conformElements1) && islogical(conformElements2))
    
    errID = 'computeRule:IllegalInputFormat';
    errMsg = 'Illegal input format! Input must be of type logical!';
    error(errID, errMsg);
        
end

if ~(size(conformElements1, 1) == size(conformElements2, 1))
    
    errID = 'computeRule:InputsOfDifferentLength';
    errMsg = 'Illegal inputs! Inputs must be two n x 1 vectors of the same length!';
    error(errID, errMsg);
    
end

%% Compute

switch operator
    case '&'
        ruleElements = conformElements1 & conformElements2;
    case '|'
        ruleElements = conformElements1 | conformElements2;
    otherwise
        errID = 'computeRule:InvalidOperator';
        errMsg = 'Invalid operator!';
        error(errID, errMsg);
end

end

