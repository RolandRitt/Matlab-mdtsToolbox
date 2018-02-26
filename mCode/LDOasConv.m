function derVec = LDOasConv(input)
% vector operations, convolution
%
% Purpose : compute the first derivative of the input using convolution
%
% Syntax : derVec = LDOasConv(input)
%
% Input Parameters :
%   input : Input for the computation. This can be given as:
%
%       Vector := Double vector holding the data
%
%       Struct := Struct which holds the handle to the mdtsObject as
%       input.object and the required tag as input.tag
%
% Return Parameters :
%   derVec : result (first derivative) as vector
%
% Description : 
%   Comute the first derivative of the numeric vector given in input. Use
%   the convolution in 'compute1' to do this.
%
% Author : 
%   Paul O'Leary
%   Roland Ritt
%   Thomas Grandl
%
% History :
% \change{1.0}{29-Jan-2018}{Original}
%
% --------------------------------------------------------
% (c) 2018 Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
% --------------------------------------------------------
%

%% Validate inputs

if(isValidInput(input) == 0)
    
    errID = 'LDOasConv:IllegalInputFormat';
    errMsg = 'Illegal input format! Input must be a struct or a numerical vector!';
    error(errID, errMsg);
    
end

%% Compute

ls = 11;
noBfs = 2;

[P,dP] = dop(ls, noBfs);

derMatrix = dP * P';

derVec = compute1(derMatrix, input);

end

