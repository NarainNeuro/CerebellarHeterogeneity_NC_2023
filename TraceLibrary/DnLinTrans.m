
function [A] = DnLinTrans(B,param)

% Works for vectors
% For arrays use the DnBSXLin

A = B.*param(1) + param(2);
