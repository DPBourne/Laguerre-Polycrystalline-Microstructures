function [w_0,max_percent_err,v_0,EXITFLAG,back_track_steps,newton_step_errors,w_steps] = SDOT_damped_Newton_diagnostic(w_0,X,target_vols,bx,periodic,percent_tol)
% [w_0,max_percent_err,v_0,EXITFLAG,report] = SDOT_damped_Newton(w_0,X,target_vols,bx,periodic,percent_tol)
%
% This function uses the damped Newton method of Kitagawa, Merigot and
% Thibert (2019) to solve the semi-discrete optimal transport problem 
% between the Lebesgue measure and a discrete measure, where the measures
% are supported on a 3D box, and the transport cost is the standard 
% quadratic cost or the periodic quadratic cost. In other words, this 
% function computes weights w_0 so that the (periodic or non-periodic) 
% Laguerre tessellation of the box bx generated by (X,w_0) has Laguerre 
% cells with volumes target_vols up to percent_tol percentage error.
%
% Algorithm: This function maximises the Kantorovich (dual) functional 
% using the damped Newton method.
%
% Input arguments:
%
% w_0 is an Nx1 array containing the initial guess for the weights (the 
% minimiser of the Kantorovich functional).
%
% X is an Nx3 array containing the x-, y- and z-coordinates of the seeds.
% This is the support of the discrete target measure.
%
% target_vols is an Nx1 array containing the desired volumes of the 
% Laguerre cells. In particular, target_vols(i) is the mass of the point
% X(i,:) with respect to the discrete target measure.
%
% bx=[L1,L2,L3] is a 1-by-3 array containing the dimensions of a 
% rectangular box with vertices (0,0,0), (L1,0,0), (0,L2,0), (0,0,L3), 
% (L1,L2,0), (L1,0,L3), (0,L2,L3), (L1,L2,L3). This is the support of the
% source measure (the Lebesgue measure).
%
% periodic is a logical argument: 
% If periodic=true, then the Laguerre diagram is periodic (periodic 
% quadratic transport cost). 
% If periodic=false, then the Laguerre diagram is non-periodic (quadratic 
% transport cost).
%
% percent_tol is the tolerance for the damped Newton method. This function
% produces a Laguerre diagram with cells of given volumes (target_vols) up 
% to percent_tol percent error.
%
% Output arguments:
%
% w_0 is an Nx1 array of weights so that the (periodic or non-periodic)
% Laguerre diagram generated by (X,w_0) in the box bx has Laguerre cells 
% with volumes target_vols up to percent_tol percentage error.
%
% max_percent_err is the maximum percentage error of the volumes of the cells
%
% v_0 is a Nx1 array containing the actual volumes of the cells in 
% the Laguerre diagram generated by (X,w_0). These volumes agree with the
% desired volumes (target_vols) up to percent_tol percentage error.
%
% EXITFLAG can take the value 0 or 1. 0 means that there is at least one 
% zero-volume cell. 1 means that the algorithm is successful.
%
% Last updated: 20 June 2022

[n,~] = size(X);

% To obtain a unique solution for the weights we impose the condition 
% that w_0(n)=0
w_0(n) = 0;

% Volumes corresponding to the initial weights, used to determine 
% epsilon below
[v_0,~,~] = mexPD(bx,X,w_0,periodic);

% epsilon2 is defined as the minimum initial volume (corresponding to w_0)
epsilon2 = min(v_0);

% Test for zero volumes
if(epsilon2<=0)
    warning('With the w_0 specified, there is at least one zero-volume cell')
    EXITFLAG=0;
    w_0=[]; max_percent_err=[]; v_0=[];
    return
end

% Compute the epsilon parameter from Kitagawa, Merigot & Thibert (2019),
% which is derived from the minimum of the target volumes and initial 
% volumes (corresponding to w_0)
epsilon1 = min(target_vols);
epsilon = 0.5*min([epsilon1,epsilon2]);

% Given the percentage tolerance for the target volumes we calculate the
% absolute tolerance for the volumes
tol=epsilon1*percent_tol/100;

% Error using the current weights (v_0 in this case)
err_0=max(abs(v_0-target_vols));

% Preallocation (for speed)
v_k=zeros(n,1);

%% For report
% Back-tracking
back_track_steps=[];

% Error after each Newton step
newton_step_errors=[];

% Weights after each Newton step
newton_step_w=[];

ns=1;

H_mod=sparse(n-1,n-1);

w_steps=w_0;

%% Start the while loop
while(err_0>tol)

    %    disp(sprintf('Newton step %d',ns));
    % Obtain the gradient and Hessian
    [~,Dg,H,~]=kantorovich(w_0,X,target_vols,bx,periodic);

    %disp('Calculated kantorovich');
    % The Hessian H is singular, with one-dimensional kernel (1,1,...,1).
    % Truncate H to produce the non-singular H_mod
    
    H_mod = H(1:n-1,1:n-1);
    clear H;
    %    disp('Solving linear system');
    % Solve the linear system
    v_k(1:n-1) = -H_mod\Dg(1:n-1);
    v_k(n) = 0;

    %disp(sprintf('\tSolved'));
    
    % Backtracking
    backtracking=true;
    % l controls length of proposed Newton step, which is 2^(-l)*v_k
    l=0;
            
    while(backtracking)
        %   disp(sprintf('\t\tBacktracking step %d',l));
        
        % Newton step: proposed new weights
        w_l=w_0+v_k*2^(-l);
        
        % Obtain the volumes corresponding to the proposed step
        [v_l,~,~]=mexPD(bx,X,w_l,periodic);
        
        % Find the minimum volume
        min_vol=min(v_l);
        
        % If the minimum volume is greater than epsilon we have a valid 
        % step (meaning not too close to a zero volume)
        if(min_vol>epsilon)
            
            % Check that there is a sufficient decrease in error
            % err_l is the error after the proposed step
            err_l=max(abs(v_l - target_vols));
            % Ratio of the error after proposed step compared to error 
            % before backtracking
            ratio=err_l/err_0;
            
            % Threshold
            threshold=1-2^(-(l+1));
            
            % If there is a sufficient decrease in error accept the Newton
            % step with given l
            if(ratio<threshold)                
                % Accept the proposed weights as the new weights
                w_0=w_l;
                v_0=v_l;
                % Stop backtracking
                backtracking=false;

                % If the ratio > threshold, then increment l 
                % (take a smaller Newton step)
            else
                l=l+1;
            end
            % If the minimum volume is too small (below epsilon), then 
            % take smaller Newton step increment l
        else
            l=l+1;
        end
    end

    ns=ns+1;
    % At this stage we have done a Newton-step
    back_track_steps=[back_track_steps,l];
    
    % Update the current error
    err_0=max(abs(v_0-target_vols));

    % Error after the Newton step
    newton_step_errors=[newton_step_errors,err_0];

    w_steps=[w_steps,w_0];
    
    % Weights after the Newton step
    %    newton_step_w=[newton_step_w,w_0];
    
end

%disp(sprintf('\t\t\tCompleted Newton steps'));

max_percent_err=max(abs(v_0-target_vols)./target_vols)*100;
EXITFLAG=1;

% Store the information about each Newton step in a structure 'report'
%report.weights=newton_step_w;
%report.error=newton_step_errors;
%report.backtracking=back_track_steps;

end