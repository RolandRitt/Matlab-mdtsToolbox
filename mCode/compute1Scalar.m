function output = compute1Scalar(operator, scalar, input)
% vector operations
%
% Purpose : execute operation on inputVector
%
% Syntax : output = compute1Scalar(operator, scalar, inputVector)
%
% Input Parameters :
%   operator : Computation operator. Possible options are:
%
%       '*' := Element wise multiplikation
%
%       '/' := Element wise division
%
%       '+' := Element wise addition
%
%       '-' := Element wise subtraction
%
%   scalar : Scalar for the operation
%
%   input : Input for the computation. This can be given as:
%
%       Vector := Double vector holding the data
%
%       Struct := Struct which holds the handle to the mdtsObject as
%       input.object and the required tag as input.tag
%
% Return Parameters :
%   output : result as vector
%
% Description : 
%   Apply a the operation specified in operator on the input, using the
%   scalar given in scalar
%
% Author : 
%   Paul O'Leary
%   Roland Ritt
%   Thomas Grandl
%
% History :
% \change{1.0}{18-Dec-2017}{Original}
%
% --------------------------------------------------------
% (c) 2017 Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
% --------------------------------------------------------
%
%% Extract input data and validate inputs

if(isa(input, 'double'))
    
    inputVector = input;
    
elseif(isa(input, 'struct'))
    
    object = input.object;
    tag = input.tag;
    inputVector = object.data(:, object.getTagIndices(tag));
    
else
    
    errID = 'compute1Scalar:IllegalInputFormat';
    errMsg = 'Illegal input format! Input must be either a double vector or a struct!';
    error(errID, errMsg);    
    
end

if(~isa(scalar, 'double') || ~(isequal(size(scalar), [1, 1])))
    
    errID = 'compute1Scalar:NoScalar';
    errMsg = 'Number given in scalar must be a scalar!';
    error(errID, errMsg);  
    
end

%% Compute

if(isa(operator, 'function_handle'))
    
    output = operator(inputVector, scalar);
    
else
    
    switch operator
        case '*'
            output = inputVector * scalar;
        case '/'
            output = inputVector / scalar;
        case '+'
            output = inputVector + scalar;
        case '-'
            output = inputVector - scalar;
        otherwise
            errID = 'compute1Scalar:InvalidOperator';
            errMsg = 'Invalid operator!';
            error(errID, errMsg);
    end
    
end

end

