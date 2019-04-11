function returnObject = symbRepChannel(input, edges, alphabet)
% segmentation
%
% Purpose : Generate symbolic representation of given channel
%
% Syntax : returnObject = symbRepChannel(input, edges, alphabet)
%
% Input Parameters :
%   input : Input for the computation as struct which holds the handle to
%           the mdtsObject as input.object and the required tag as
%           input.tag
%   edges : Array of length(alphabet) + 1, which contains the edges for
%           the quantization
%   alphabet : Array containing the symbols to assing to the values
%
% Return Parameters :
%   returnObject : symbRepObject with the symbolized channel
%
% Description : 
%   Extract the data from the according channel of the mdtsObject specified
%   in 'input', assign every data point of this channel a symbol given in
%   'alphabet' according to the limits given in 'edges'.
%
% Author : 
%   Paul O'Leary
%   Roland Ritt
%   Thomas Grandl
%
% History :
% \change{1.0}{10-Jan-2018}{Original}
%
% --------------------------------------------------------
% (c) 2018 Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
% --------------------------------------------------------

%% Extract data from the mdtsObject

object = input.object;
tag = input.tag;
y = object.data(:, object.getTagIndices(tag));

nSym = numel(alphabet);
nEdges = numel(edges);

if ~(nSym + 1 == nEdges)
    
    errID = 'segmentChannel:InvalidNumberOfSymbos';
    errMsg = 'The number of elements in edges must be greater by 1 than the number of elements in alphabet!';
    error(errID, errMsg);
    
end

symbRepr = discretize(y, edges, 'categorical', alphabet);
numRepr = int32(discretize(y, edges));

symbolChange = [true; diff(numRepr) ~= 0];
compressedSymbols = symbRepr(symbolChange);
symbolLength = diff(find([symbolChange; 1]));

returnObject = SymbRepObject(symbolLength, compressedSymbols);

end

