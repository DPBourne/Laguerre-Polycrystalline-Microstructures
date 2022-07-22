function h=patchpolygons(polys,cellids,cell_colours)
% h=patchpolygons(polys,cellids,cell_colours)
% This function takes a list of polygons and plots them using a patch
% The colour of the patch is derived from the cell the polygon
% belongs to and a list of cell colours. The style of the patchwork
% of polygons can be set in this function
%
% Input arguments
%
% polys         : an Np x 1 cell array of polygons
% cellids       : an Np x 1 array of cell ids
% cell_colours  : an Nc x 3 array of RGB values for the cell
% colours
%
% Output arguments
% h             : a vector of handles to the patches
    
Np=length(polys);

%h=patchPolygon3d(polys,'LineWidth',0.25);
h=fillPolygon3d(polys,'r','LineWidth',0.25);

if(nargin==3)
    for i=1:Np
        set(h(i),'FaceColor',cell_colours(cellids(i),:));
    end
end

end