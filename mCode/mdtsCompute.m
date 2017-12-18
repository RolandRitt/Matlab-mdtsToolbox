function output = mdtsCompute(varargin)
% computation
%
% Purpose : execute various computations
%
% Syntax : output = mdtsCompute(varargin)
%
% Input Parameters :
%   varargin : Different input parameters, according to corresponding
%   functions
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

