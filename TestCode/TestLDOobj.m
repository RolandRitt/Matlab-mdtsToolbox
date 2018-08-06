%% Test LDO object
% 
% Description : 
%
%
% Author : 
%    Roland Ritt
%
% History :
% \change{1.0}{11 May 2017}{Original}
%
% --------------------------------------------------
% (c) 2017, Roland Ritt
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------

clear
close all hidden
clc;


x= linspace(-100,100, 100)';
y = 1/2*x.^3 - 50.*x.^2 + 3*x;

yn = y +  randn(size(y))*50000;

ls = 11;
noBfs = 3;
D3 = dopDiffLocal( x, ls, noBfs, true, true);
D = dopDiffLocal(x(1:ls), ls, 3);
D2 = dopDiffLocal(x, ls, noBfs);

[Gt, dGt] = dop( x(1:ls), noBfs );

P = dGt*Gt';


LDOobj = LDO(P);

dyD = D3*yn;

dyLDO = LDOobj.apply(yn)

if max(abs(dyD - dyLDO))>1e-10
    error('solutions are not equal');
end
figureGen;
plot(x, y);
hold on
plot(x,yn, 'r.')

