function [allpolys,cellids]=cells_intersect_plane(pl,vfn)

% Calculates the intersection of the voronoi cells with a plane
% Usage
%
%    [allpolys,cellids]=plot_cells_intersect_plane(pl,vfn)
%
% where pl is a plane (see createPlane) and vfn is a cell array
% containing the vertices, faces and neighbours for each cell
% 
% the output is a cell array of polygons in allpolys and a
% corresponding list of cell ids for each polygon (this can later
% be used to plot the polygons with a style derived from the
% corresponding cell
    
% Obtain the number of cells 
    [Nc,~]=size(vfn);

    % Empty the arrays
    allpolys=[];
    cellids=[];

    % Iterate over the list of cells
    for i=1:Nc

        % Only if a cell is not empty do we attempt to plot
        if(~isempty(vfn{i,1}))
            
            vmesh=vfn{i,1};
            fmesh=vfn{i,2};
            
            %            disp(sprintf("Cell %d\n",i));
            % We now have a mesh in v2 and f2
            polys = intersectPlaneMesh(pl, vmesh, fmesh);

            % Provided the list of polygons is not empty we add the
            % appropriate polygons and cell ids
            if(~isempty(polys))
                allpolys=[allpolys;polys];
                cellids=[cellids;i*ones(length(polys))];
            end
            
        end
    end
    
end

