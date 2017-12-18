function output = mdtsCompute(varargin)
% computation
%
% Purpose : execute various computations
%
% Syntax :
%   output = mdtsCompute(operator1, input1, input2) : compute2 function
%   output = mdtsCompute(operator2, scalar, input) : compute1Scalar function
%   output = mdtsCompute(matrix, input) : compute1 function
%
% Input Parameters :
%   input, input1, input2 : Input for the computation. These can be given as:
%
%       Vector := Double vector holding the data
%
%       Struct := Struct which holds the handle to the mdtsObject as
%       input.object and the required tag as input.tag
%
%   operator1 : Computation operator. Possible options are:
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
%   operator2 : Computation operator. Possible options are:
%
%       '*' := Element wise multiplikation
%
%       '/' := Element wise division
%
%       '+' := Element wise addition
%
%       '-' := Element wise subtraction
%
%       handle := handle to other function
%
%   scalar : Scalar for the operation
%
%   matrix : Convolution matrix
%
% Return Parameters :
%   output : result of computation
%
% Description : 
%   Apply a computation specified within the input parameters, using
%   operators and further parameters given in the input parameters.
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
%% Validate inputs and select correct function

if(nargin == 3)
    
    if((isa(varargin{1}, 'function_handle') || isa(varargin{1}, 'char')) &&...
       (isa(varargin{2}, 'struct') || (isa(varargin{2}, 'double') && (size(varargin{2}, 1) > 1) && (size(varargin{2}, 2) == 1))) &&...
       (isa(varargin{3}, 'struct') || isa(varargin{3}, 'double')))
   
        output = compute2(varargin{1}, varargin{2}, varargin{3});
        
    elseif((isa(varargin{1}, 'function_handle') || isa(varargin{1}, 'char')) &&...
           (isa(varargin{2}, 'double') && (isequal(size(varargin{2}), [1, 1]))) &&...
           (isa(varargin{3}, 'struct') || isa(varargin{3}, 'double')))
        
        output = compute1Scalar(varargin{1}, varargin{2}, varargin{3});
        
    else
        
        errID = 'mdtsCompute:IllegalInputs';
        errMsg = 'Illegal format of inputs!';
        error(errID, errMsg);    
        
    end            
    
elseif(nargin == 2)
    
    if((isa(varargin{1}, 'numeric') && (size(varargin{1}, 1) > 1) && (size(varargin{1}, 2) > 1)) &&...
       (isa(varargin{2}, 'struct') || (isa(varargin{2}, 'double') && ~isequal(size(varargin{2}), [1, 1]))))
   
        output = compute1(varargin{1}, varargin{2});
   
    else
        
        errID = 'mdtsCompute:IllegalInputs';
        errMsg = 'Illegal format of inputs!';
        error(errID, errMsg);
        
    end
    
else
    
    errID = 'mdtsCompute:IllegalInputs';
    errMsg = 'Illegal format of inputs!';
    error(errID, errMsg);
    
end

end

