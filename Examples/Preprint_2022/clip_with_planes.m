function [out_poly_list,out_cellids] = clip_with_planes(poly_list,cellids,plane_list,shift_list)

% clip_with_planes.m
%
% [out_poly_list,out_cellids] = clip_with_planes(poly_list,cellids,plane_list,shift_list)
%
% Inputs:
% a list of 3D polygons in 'poly_list'
% a list of corresponding cell IDs 'cellids' which sa which cell the polygons belong to
% a list of planes, these should come in pairs, the only difference within the pair being
% the direction of the normal
% a list of shifts, if the plane cuts a polygon, part of it will be
% 'inside' and part of it will be 'outside', the outside part is shifted to
% the other side of the box to construct the periodic view of the cells
%
% The outputs are a list of polygons and cell ids.

% The list of planes contains pairs of identical planes, but with opposite
% normal directions

    if(isempty(plane_list))
        out_poly_list=poly_list;
        out_cellids=cellids;
    else 
        plane_p=plane_list{1};
        plane_m=plane_list{2};

        plane_list=plane_list(3:end);

        % The shift list is how the planes are shifted to cope with periodicity

        shift=shift_list(1,:);
        shift_list=shift_list(2:end,:);

        npolys=length(poly_list);

        tmp_poly_list={};
        tmp_cellids=[];
        
        for i=1:npolys

            poly=poly_list{i};
            cid=cellids(i);
            
            polyin=clipConvexPolygon3dHP(poly,plane_p);
            polyout=clipConvexPolygon3dHP(poly,plane_m);
            
            if(~isempty(polyin))
                tmp_poly_list=[tmp_poly_list;polyin];
                tmp_cellids=[tmp_cellids;cid];
            end
            
            if(~isempty(polyout))
                polyout=polyout+shift;
                tmp_poly_list=[tmp_poly_list;polyout];
                tmp_cellids=[tmp_cellids;cid];
            end
        end

        [out_poly_list,out_cellids]=clip_with_planes(tmp_poly_list,tmp_cellids,plane_list,shift_list);

    end
end

