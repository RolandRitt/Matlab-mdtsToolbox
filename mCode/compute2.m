function outputVector = compute2(operator, input1, input2)
% vector operations
%
% Purpose : execute operation with two inputs
%
% Syntax : outputVector = compute2(operator, input1, input2)
%
% Input Parameters :
%   input1 : struct which holds the handle to the first mdtsObject as
%   input1.object and the required tag as input1.tag
%   input2 : struct which holds the handle to the second mdtsObject as
%   input2.object and the required tag as input2.tag
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

%% Extract input data

object1 = input1.object;
object2 = input2.object;

tag1 = input1.tag;
tag2 = input2.tag;

vector1 = object1.data(:, object1.getTagIndices(tag1));
vector2 = object2.data(:, object2.getTagIndices(tag2));

if~(numel(vector1) == numel(vector2))
    
    errID = 'compute2:UnequalVectorLength';
    errMsg = 'Both input vectors must have the same length!';
    error(errID, errMsg);
    
end

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
        otherwise
            errID = 'compute2:InvalidOperator';
            errMsg = 'Invalid operator!';
            error(errID, errMsg);
    end
    
end



end

