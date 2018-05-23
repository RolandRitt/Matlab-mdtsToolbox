function conformElements = computeFind(operator, input, value, preAppliedFunction)
% boolean operations, segmentation
%
% Purpose : find all elements of an input which fulfil a condition
%
% Syntax :
%   conformElements = computeFind(operator, input, value)
%   conformElements = computeFind(operator, input, value, preAppliedFunction)
%
% Input Parameters :
%   operator : condition operator as string. Available options: >, <, ==,
%   ~=, >=, <=
%
%   input : Input for the computation as struct which holds the handle to
%           the mdtsObject as input.object and the required tag as
%           input.tag
%
%   value : reference value for the condition
%
%   preAppliedFunction : Function which is applied on the data vector
%   before the condition is evaluated (optional input). Available options:
%   abs (absolute value)
%
% Return Parameters :
%   conformElements : logical array which indicates the elements of 'input'
%   which fulfil the condition
%
% Description : 
%   Finds all elements of 'input' which fulfil the condition according to the
%   operator and the value. If the input 'preAppliedFunction' is specified,
%   the specified function will be applied on the data vector, before the
%   condition is evaluated.
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

if (nargin > 3 && ~isa(preAppliedFunction, 'char'))
    
    errID = 'computeFind:IllegalPreAppliedFunctionFormat';
    errMsg = 'Illegal format of the input preAppliedFunction! preAppliedFunction must be a character vector (string)!';
    error(errID, errMsg);
    
end

%% Apply Function on Input

if(nargin > 3)
    
    switch preAppliedFunction
        case 'abs'
            vector1 = abs(vector1);
        otherwise
            errID = 'computeFind:InvalidPreAppliedFunction';
            errMsg = 'Invalid PreAppliedFunction!';
            error(errID, errMsg);
    end
end

%% Evaluate Condition

switch operator
    case '>'
        conformElements = vector1 > value;
    case '<'
        conformElements = vector1 < value;
    case '=='
        conformElements = vector1 == value;
    case '~='
        conformElements = vector1 ~= value;
    case '>='
        conformElements = vector1 >= value;
    case '<='
        conformElements = vector1 <= value;
    otherwise
        errID = 'computeFind:InvalidOperator';
        errMsg = 'Invalid operator!';
        error(errID, errMsg);
end

end

