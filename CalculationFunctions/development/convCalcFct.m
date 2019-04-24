function outputVector = convCalcFct(inputVector, convMatrix)
% convolution
%
% Purpose : execute convolution calculation
%
% Syntax : outputVector = convCalcFct(inputVector, convMatrix)
%
% Input Parameters :
%   inputVector : column vector as input
%   convMatrix : matrix for convolution
%
% Return Parameters :
%   outputVector : result of convolution
%
% Description : 
%   Apply convolution matrix on the given vector
%
% Author : 
%   Paul O'Leary
%   Roland Ritt
%   Thomas Grandl
%
% History :
% \change{1.0}{09 October 2017}{Original}
%
% --------------------------------------------------------
% (c) 2017 Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
% --------------------------------------------------------

y = inputVector;
M = convMatrix;

[m, n] = size(M);

if(m == n)
    
    if ~isOdd(n)
        
        errID = 'convCalcFct:EvenSupportLength';
        errMsg = 'LDO is only implemented odd support length!';
        error(errID, errMsg);
        
    end
    
    ls = n;
    mid = (n + 1) / 2; %middle row index
    lc = M(mid, :); %ectract middl row
    lc_conv = fliplr(lc); %ectract middl row
    T = M(1 : mid - 1, :);
    B = M(mid + 1 : end, :);
    
    yL = conv(y, lc_conv, 'same'); %convolution with central row of LDO Matrix
    yL(1 : mid - 1) = T * y(1 : ls);
    yL(end - mid + 2 : end) = B * y(end - ls + 1 : end);
    
    outputVector = yL;
    
else
    
    errID = 'convCalcFct:NonSquareOperator';
    errMsg = 'LDO is only implemented for squared Operators!';
    error(errID, errMsg);
    
end

end

