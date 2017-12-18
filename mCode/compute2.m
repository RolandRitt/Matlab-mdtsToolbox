function outputVector = compute2(operator, input1, input2)
% vector operations
%
% Purpose : execute operation with two inputs
%
% Syntax : outputVector = compute2(operator, input1, input2)
%
% Input Parameters :
%   operator : Computation operator. Possible options are:
%
%       '.*' := Element wise multiplikation
%
%       './' := Element wise division
%
%       '+' := Element wise addition
%
%       '-' := Element wise subtraction
%
%       'dot' := Inner product (dot product) of both vectors
%
%       'outer' := Outer product of both vectors
%       
%       'xcorr' := Cross correlation between both inputs
%
%       handle := handle to other function
%
%   input1, input2 : Inputs for the computation. They can be given as:
%
%       Vectors := Double vector holding the data
%
%       Structs := Struct which holds the handle to the mdtsObject as
%       input.object and the required tag as input.tag
%
% Return Parameters :
%   outputVector : result as vector
%
% Description : 
%   Apply the operation determined by 'operator' on the data of both
%   inputs. Return the result vector in the output parameter
%
% Author : 
%   Paul O'Leary
%   Roland Ritt
%   Thomas Grandl
%
% History :
% \change{1.0}{12-Dec-2017}{Original}
%
% --------------------------------------------------------
% (c) 2017 Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
% --------------------------------------------------------

%% Extract input data and validate inputs

if(isa(input1, 'double'))
    
    vector1 = input1;
    
elseif(isa(input1, 'struct'))
    
    object1 = input1.object;
    tag1 = input1.tag;
    vector1 = object1.data(:, object1.getTagIndices(tag1));
    
else
    
    errID = 'compute2:IllegalInputFormat';
    errMsg = 'Illegal input format of ''input1''! Input must be either a double vector or a struct!';
    error(errID, errMsg);    
    
end

if(isa(input2, 'double'))
    
    vector2 = input2;
    
elseif(isa(input2, 'struct'))
    
    object2 = input2.object;
    tag2 = input2.tag;
    vector2 = object2.data(:, object2.getTagIndices(tag2));
    
else
    
    errID = 'compute2:IllegalInputFormat';
    errMsg = 'Illegal input format of ''input2''! Input must be either a double vector or a struct!';
    error(errID, errMsg);   
    
end

if~(numel(vector1) == numel(vector2))
    
    errID = 'compute2:UnequalVectorLength';
    errMsg = 'Both input vectors must have the same length!';
    error(errID, errMsg);
    
end

%% Compute

if(isa(operator, 'function_handle'))
    
    outputVector = operator(vector1, vector2);
    
else
    
    switch operator
        case '.*'
            outputVector = vector1 .* vector2;
        case './'
            outputVector = vector1 ./ vector2;
        case '+'
            outputVector = vector1 + vector2;
        case '-'
            outputVector = vector1 - vector2;
        case 'dot'
            outputVector = dot(vector1, vector2);
        case 'outer'
            outputVector = vector1 * vector2';
        case 'xcorr'
            outputVector = xcorr(vector1, vector2);
        otherwise
            errID = 'compute2:InvalidOperator';
            errMsg = 'Invalid operator!';
            error(errID, errMsg);
    end
    
end



end

