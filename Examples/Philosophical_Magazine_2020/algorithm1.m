function [w,vol_error,actual_vols]=algorithm1(bx,X,w_init,target_vols,periodic,tol,varargin)
% [w,vol_error,actual_vols]=algorithm1(bx,X,w_init,target_vols,periodic,tol,varargin)
%
% This function performs Algorithm 1 from the paper 'Laguerre tessellations
% and polycrystalline microstructures: A fast algorithm for generating 
% grains of given volumes' by D.P. Bourne, P.J.J. Kok, S.M. Roper, 
% W.D.T. Spanjer (Philosophical Magazine 100, 2677-2707, 2020). It computes
% a Laguerre diagram with seeds X and with grains of volume target_vols (up
% to tol percentage error).
%
% Input arguments:
%
% bx=[L1,L2,L3] is a 1-by-3 array containing the dimensions of a 
% rectangular box with vertices (0,0,0), (L1,0,0), (0,L2,0), (0,0,L3), 
% (L1,L2,0), (L1,0,L3), (0,L2,L3), (L1,L2,L3).
%
% X is an Nx3 array containing the x-, y- and z-coordinates of the seeds.
%
% w_init is an Nx1 array containing the initial guess for the weights.
%
% target_vols is an Nx1 array containing the desired volumes of the grains.
%
% periodic is a logical argument: If periodic=true, then the Laguerre
% diagram is periodic. If periodic=false, then the Laguerre diagram is 
% non-periodic.
%
% tol is the tolerance for the convex optimization algorithm. This function
% produces a Laguerre diagram with grains of given volumes (target_vols) up 
% to tol percent error.
%
% OPTsolver is an optional argument. This specifies the optimal transport
% solver. The options are 'dampedNewton' (default) or 'fminunc'.
%
% Output arguments:
%
% w is a column vector containing the weights of the Laguerre diagram.
%
% vol_error is the maximum percentage error of the volumes of the grains.
%
% actual_vols is a Nx1 array containing the actual volumes of the grains 
% in the Laguerre diagram generated by (X,w). These volumes agree with the
% desired volumes (target_vols) up to tol percentage error.
%
% Last updated: 1 August 2022

% Check the optional input argument
if(nargin==7)
    solver=varargin{1};
else
    solver='dampedNewton'; % default solver
end

% Optimization step: Compute the weights so that the grains have the 
% correct volumes
switch solver
    case 'dampedNewton'
        [w,vol_error,actual_vols]=...
            SDOT_damped_Newton(w_init,X,target_vols,bx,periodic,tol);
    case 'fminunc'
        [w,vol_error,actual_vols]=...
            SDOT_fminunc(w_init,X,target_vols,bx,periodic,tol);
    otherwise
        error('The solver you entered is not valid.')
end

% Normalise the weights to that they are all non-negative
w=w-min(w);