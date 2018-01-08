function output = compute1(matrix, input)
% vector operations, convolution
%
% Purpose : execute convolution operation
%
% Syntax : output = compute1(matrix, input)
%
% Input Parameters :
%   matrix : Convolution matrix, dense or sparse, or convolution vector
%
%   input : Input for the computation. This can be given as:
%
%       Vector := Double vector holding the data
%
%       Struct := Struct which holds the handle to the mdtsObject as
%       input.object and the required tag as input.tag
%
% Return Parameters :
%   output : result as vector
%
% Description : 
%   Apply a convolution with the matrix given in 'matrix' on the specified
%   input
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
%% Extract input data

if(isa(input, 'double'))
    
    inputVector = input;
    
elseif(isa(input, 'struct'))
    
    object = input.object;
    tag = input.tag;
    inputVector = object.data(:, object.getTagIndices(tag));
    
else
    
    errID = 'compute1:IllegalInputFormat';
    errMsg = 'Illegal input format! Input must be either a double vector or a struct!';
    error(errID, errMsg);    
    
end

if(~isa(matrix, 'double'))
    
    errID = 'compute1:IllegalMatrixFormat';
    errMsg = 'Illegal matrix format! Matrix must be a n x n matrix, where n is an odd number!';
    error(errID, errMsg);  
    
end

%% Compute

y = inputVector;
M = matrix;

[m, n] = size(M);

if(issparse(M))
    
    if~(numel(y) == m && numel(y) == n)
        
        errID = 'compute1:IncorrectMatrixDimensions';
        errMsg = 'Sparse matrix must be of dimension n x n, where n is the length of the given data vector!';
        error(errID, errMsg);
        
    end
    
    output = M * y;
    
elseif(m == n)
    
    if ~isOdd(n)
        
        errID = 'compute1:EvenSupportLength';
        errMsg = 'LDO is only implemented for odd support length!';
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
    
    output = yL;
    
elseif(m == 1 || n == 1)
    
    output = conv(y, matrix, 'same');
    
else
    
    errID = 'compute1:InvalidOperator';
    errMsg = 'Operator must be a n x n matrix (dense or sparse) or a vector!';
    error(errID, errMsg);
    
end

end

