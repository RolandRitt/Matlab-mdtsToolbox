function conformElements = computeFind(operator, input, value)
% boolean operations, segmentation
%
% Purpose : find all elements of an input which fulfil a condition
%
% Syntax :
%   conformElements = computeFind(operator, input, value)
%
% Input Parameters :
%   operator : condition operator as string. Available options: >, <, ==, ~=
%
%   input : Input for the computation as struct which holds the handle to
%           the mdtsObject as input.object and the required tag as
%           input.tag
%
%   value : reference value for the condition
%
% Return Parameters :
%   conformElements : logical array which indicates the elements of 'input'
%   which fulfil the condition
%
% Description : 
%   Finds all elements of 'input' which fulfil the condition according to the
%   operator and the value.
%
% Author : 
%   Paul O'Leary
%   Roland Ritt
%   Thomas Grandl
%
% History :
% \change{1.0}{22-Dec-2017}{Original}
%
% --------------------------------------------------------
% (c) 2017 Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
% --------------------------------------------------------
%
%% Validate inputs

if (isValidInput(input) == 1)
    
    object1 = input.object;
    tag1 = input.tag;
    vector1 = object1.data(:, object1.getTagIndices(tag1));
    
else
    
    errID = 'computeFind:IllegalInputFormat';
    errMsg = 'Illegal input format! Input must be a struct!';
    error(errID, errMsg);
    
end

if ~(isa(value, 'numeric') && ...
    isequal(size(value), [1, 1]))

    errID = 'computeFind:IllegalValueFormat';
    errMsg = 'Illegal value format! Value must be a scalar!';
    error(errID, errMsg);
    
end

%% Compute

switch operator
    case '>'
        conformElements = vector1 > value;
    case '<'
        conformElements = vector1 < value;
    case '=='
        conformElements = vector1 == value;
    case '~='
        conformElements = vector1 ~= value;
    otherwise
        errID = 'computeFind:InvalidOperator';
        errMsg = 'Invalid operator!';
        error(errID, errMsg);
end

end

