function mdtsObjOut = TSconv(mdtsObjIn, inputTag, mdtsObjOut, outputTag, convMatrix)
% convolution, objects
%
% Purpose : Run a convolution on given inputs
%
% Syntax :
%   mdtsObjOut = TSconv(mdtsObjIn, inputTag, mdtsObjOut, outputTag, matrix)
%
% Input Parameters :
%   mdtsObjIn : mdtsObject with input channel
%   inputTag : name of input channel
%   mdtsObjOut : mdtsObject on which the result shall be stored
%   outputTag : namje of result channel
%   convMatrix : convolution matrix
%   
% Return Parameters :
%   mdtsObjOut : mdtsObject with the result
%   
% Description : 
%   Receives two mdtsObjects. Extracts the data of the according mdtsObject
%   and the according tag as input data, passes it to the convolution
%   function together with the convolution matrix and stores the result
%   in the given mdtsObject.
%
% Author :
%   Paul O'Leary
%   Roland Ritt
%   Thomas Grandl
%
% History :
% \change{1.0}{16-Nov-2017}{Original version}
%
% --------------------------------------------------------
% (c) 2017 Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
% --------------------------------------------------------
%
%%

tagIndex = getTagIndices(mdtsObjIn, inputTag);

dataVec = mdtsObjIn.data(:, tagIndex);

outputVector = convCalcFct(dataVec, convMatrix);

mdtsObjOut.expandDataSet(outputVector, outputTag);

end

