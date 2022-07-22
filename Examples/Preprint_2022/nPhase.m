function [X,target_vols]=nPhase(n,relative_vols,bx)
%
% [X,target_v]=nPhase(n,relative_vols,bx)
%
% Inputs : n             - a list of numbers of seeds of each phase, 1-by-np array of integers
%        : relative_vols - a list of relative volumes of each phase, 1-by-np array of positive reals
%        : bx            - a list of box dimensions, 1-by-d array of positive reals
%
% This function produces random seed locations and target volumes

[np,mp]=size(n);
[nv,mv]=size(relative_vols);

if(~(np==nv && mp==mv && np==1 && nv==1))
    error('The two inputs must both be 1-by-np arrays where np is the number of phases')
end

% Obtain dimension
[~,d]=size(bx);

% The total number of seeds
N=sum(n);

% Array to store the seeds
X=rand(N,d)*diag(bx);

% Array to store the target_volumes
target_vols=zeros(N,1);

idx=1;
for j=1:mp,
    tv=relative_vols(j)*ones(n(j),1);
    target_vols(idx:idx+n(j)-1,:)=tv;
    idx=idx+n(j);
end

% Rescale so target volumes add up to size of box
target_vols=target_vols*prod(bx)/sum(target_vols);

end