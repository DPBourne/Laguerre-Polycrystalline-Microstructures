function [polys,cellids] = intersect_cells_on_boundary_periodic(bx,vfn)

% [polys,cellids] = intersect_cells_on_boundary_periodic(bx,vfn)
%
% periodic version
%
% Inputs are the box and a cell array containing the vertices of each cell
% the faces of each cell and the neighbours of each cell

% Outputs are 3d polygons and cell IDs
    
Lx=bx(1);Ly=bx(2);Lz=bx(3);

% The planes that represent the faces of the box, with outward pointing normals and inward pointing normals

pl_x0=createPlane([0 0 0],[-1 0 0]);
pl_x0m=createPlane([0 0 0],[1 0 0]);

pl_xL=createPlane([Lx 0 0],[1 0 0]);
pl_xLm=createPlane([Lx 0 0],[-1 0 0]);

pl_y0=createPlane([0 0 0],[0 -1 0]);
pl_y0m=createPlane([0 0 0],[0 1 0]);

pl_yL=createPlane([0 Ly 0],[0 1 0]);
pl_yLm=createPlane([0 Ly 0],[0 -1 0]);

pl_z0=createPlane([0 0 0],[0 0 -1]);
pl_z0m=createPlane([0 0 0],[0 0 1]);

pl_zL=createPlane([0 0 Lz],[0 0 1]);
pl_zLm=createPlane([0 0 Lz],[0 0 -1]);

shift_x0=[Lx 0 0];
shift_xL=[-Lx 0 0];

shift_y0=[0 Ly 0];
shift_yL=[0 -Ly 0];

shift_z0=[0 0 Lz];
shift_zL=[0 0 -Lz];

%disp('Created planes and shifts');

%% Obtain the polygons from the x=0 plane

[poly_x0,cid_x0]=cells_intersect_plane(pl_x0,vfn);
%disp('Found cell intersections with x=0 plane');
[out_poly_x0,out_cid_x0]=clip_with_planes(poly_x0,cid_x0,{pl_y0,pl_y0m,pl_yL,pl_yLm,pl_z0,pl_z0m,pl_zL,pl_zLm},[shift_y0;shift_yL;shift_z0;shift_zL]);

% Copy each polygon to the x=Lx face

copy_out_poly_x0={};

for i=1:length(out_poly_x0)
    copy_out_poly_x0=[copy_out_poly_x0;out_poly_x0{i}+shift_x0];
end

%% Obtain the polygons from the x=Lx plane

[poly_xL,cid_xL]=cells_intersect_plane(pl_xL,vfn);
[out_poly_xL,out_cid_xL] = clip_with_planes(poly_xL,cid_xL,{pl_y0,pl_y0m,pl_yL,pl_yLm,pl_z0,pl_z0m,pl_zL,pl_zLm},[shift_y0;shift_yL;shift_z0;shift_zL]);

% Copy each polygon to the x=0 face

copy_out_poly_xL={};

for i=1:length(out_poly_xL)
    copy_out_poly_xL=[copy_out_poly_xL;out_poly_xL{i}+shift_xL];
end

%% Obtain the polygons from the y=0 plane

[poly_y0,cid_y0]=cells_intersect_plane(pl_y0,vfn);
[out_poly_y0,out_cid_y0] = clip_with_planes(poly_y0,cid_y0,{pl_x0,pl_x0m,pl_xL,pl_xLm,pl_z0,pl_z0m,pl_zL,pl_zLm},[shift_x0;shift_xL;shift_z0;shift_zL]);

% Copy each polygon to the y=Ly face

copy_out_poly_y0={};

for i=1:length(out_poly_y0)
    copy_out_poly_y0=[copy_out_poly_y0;out_poly_y0{i}+shift_y0];
end

%% Obtain the polygons from the y=Ly plane

[poly_yL,cid_yL]=cells_intersect_plane(pl_yL,vfn);
[out_poly_yL,out_cid_yL] = clip_with_planes(poly_yL,cid_yL,{pl_x0,pl_x0m,pl_xL,pl_xLm,pl_z0,pl_z0m,pl_zL,pl_zLm},[shift_x0;shift_xL;shift_z0;shift_zL]);

% Copy each polygon to the y=0 face

copy_out_poly_yL={};

for i=1:length(out_poly_yL)
    copy_out_poly_yL=[copy_out_poly_yL;out_poly_yL{i}+shift_yL];
end

%% Obtain the polygons from the z=0 plane

[poly_z0,cid_z0]=cells_intersect_plane(pl_z0,vfn);
[out_poly_z0,out_cid_z0] = clip_with_planes(poly_z0,cid_z0,{pl_x0,pl_x0m,pl_xL,pl_xLm,pl_y0,pl_y0m,pl_yL,pl_yLm},[shift_x0;shift_xL;shift_y0;shift_yL]);

% Copy each polygon to the z=Lz face

copy_out_poly_z0={};

for i=1:length(out_poly_z0)
    copy_out_poly_z0=[copy_out_poly_z0;out_poly_z0{i}+shift_z0];
end

%% Obtain the polygons from the z=Lz plane

[poly_zL,cid_zL]=cells_intersect_plane(pl_zL,vfn);
[out_poly_zL,out_cid_zL] = clip_with_planes(poly_zL,cid_zL,{pl_x0,pl_x0m,pl_xL,pl_xLm,pl_y0,pl_y0m,pl_yL,pl_yLm},[shift_x0;shift_xL;shift_y0;shift_yL]);

% Copy each polygon to the z=0 face

copy_out_poly_zL={};

for i=1:length(out_poly_zL)
    copy_out_poly_zL=[copy_out_poly_zL;out_poly_zL{i}+shift_zL];
end

polys=[out_poly_x0;
       copy_out_poly_x0;
       out_poly_xL;
       copy_out_poly_xL;
       out_poly_y0;
       copy_out_poly_y0;
       out_poly_yL;
       copy_out_poly_yL;
       out_poly_z0;
       copy_out_poly_z0;
       out_poly_zL;
       copy_out_poly_zL
      ];

cellids=[out_cid_x0;
         out_cid_x0;
         out_cid_xL;
         out_cid_xL;
         out_cid_y0;
         out_cid_y0;
         out_cid_yL;
         out_cid_yL;
         out_cid_z0;
         out_cid_z0;
         out_cid_zL;
         out_cid_zL;
        ];

end

