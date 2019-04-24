function inputType = isValidInput(input)
% parameter validation
%
% Purpose : validate input parameter
%
% Syntax :
%   inputType = isValidInput(input)
%
% Input Parameters :
%   input : input parameter, which has to be validated
%
% Return Parameters :
%   inputType : type of the input. Possible input types are:
%
%       1 := structured input. The input is a struct where input.object
%       holds a reference to the mdtsObject and input.tag is a valid tag of
%       this mdtsObject
%
%       2 := n x 1 vector of numeric elements
%
%       0 := input is invalid
%
% Description : 
%   Checks if the given input is either a struct with a handle to the
%   mdtsObject and a valid tag or a numeric vector. The output referes to
%   one of these two types or to an invalid input
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
%% Validate

if(isa(input, 'struct') && ...
   isfield(input, 'object') && ...
   isfield(input, 'tag') && ...
   isa(input.object, 'mdtsObject') && ...
   isa(input.tag, 'char'))
    
    inputType = 1;
    
elseif(isa(input, 'numeric') && ...
       size(input, 1) > 1 && ...
       size(input, 2) == 1)
    
    inputType = 2;
    
else
    
    inputType = 0;
    
end

end

