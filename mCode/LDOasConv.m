function derVec = LDOasConv(input, varargin)
% vector operations, convolution
%
% Purpose : compute approximated values for derivatives of the input using 
%           convolution. Default first derivative is returned.
%
% Syntax :
%   derVec = LDOasConv(input)
%
% Input Parameters :
%   input : Input for the computation. This can be given as:
%
%       Vector := Double vector holding the data
%
%       Struct := Struct which holds the handle to the mdtsObject as
%       input.object and the required tag as input.tag
%
%   ls : support length as name value pair
%
%   noBfs : number of basis functions as name value pair
%
%   order : order of the derivative as name value pair. Default is 1. A
%   value of 0 can be used for reconstruction of the input (smooth).
%
% Return Parameters :
%   derVec : result (derivative) as vector
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
    
elseif(isValidInput(input) == 1)
        
    xTime = input.object.time;
    
elseif(isValidInput(input) == 2)
    
    xTime = (1 : numel(input))';
    
end

p = inputParser;

defaultls = 11;
defaultnoBfs = 2;
defaultorder = 1;

addParameter(p, 'ls', defaultls, @(x)validateattributes(x, {'numeric'}, {'size', [1, 1]}));
addParameter(p, 'noBfs', defaultnoBfs, @(x)validateattributes(x, {'numeric'}, {'size', [1, 1]}));
addParameter(p, 'order', defaultorder, @(x)validateattributes(x, {'numeric'}, {'size', [1, 1]}));

parse(p, varargin{:});

ls = p.Results.ls;
noBfs = p.Results.noBfs;
order = p.Results.order;

if(noBfs > ls)
    
    errID = 'LDOasConv:lsTooSmall';
    errMsg = 'Input ls must be greater than or equal to noBfs!';
    error(errID, errMsg);
    
end

if(noBfs < order)
    
    errID = 'LDOasConv:OrderToLarge';
    errMsg = 'Input order must be smaller than or equal to noBfs!';
    error(errID, errMsg);
    
end

if~isOdd(ls)
    
    errID = 'LDOasConv:lsMustBeOdd';
    errMsg = 'Input ls must be odd!';
    error(errID, errMsg);
    
end

%% Compute

x = xTime(1 : ls);

x = x - x((ls + 1) / 2);

[P,dP] = dop(x, noBfs);

if(order == 0)
    
    derMatrix = P * P';
    
else

    derMatrix = dP * P';

end

derVec = compute1(derMatrix, input);

for i = 2 : order

    derVec = compute1(derMatrix, derVec);

end

