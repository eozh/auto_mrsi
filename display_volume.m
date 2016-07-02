%{
 Copyright © 2012 The Regents of the University of California.
 All Rights Reserved.

 Redistribution and use in source and binary forms, with or without 
 modification, are permitted provided that the following conditions are met:
 -   Redistributions of source code must retain the above copyright notice, 
     this list of conditions and the following disclaimer.
 -   Redistributions in binary form must reproduce the above copyright notice, 
     this list of conditions and the following disclaimer in the documentation 
     and/or other materials provided with the distribution.
 -   None of the names of any campus of the University of California, the name 
     "The Regents of the University of California," or the names of any of its 
     contributors may be used to endorse or promote products derived from this 
     software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
 OF SUCH DAMAGE.

  
 $URL: https://intrarad.ucsf.edu/svn/rad_software/surbeck/brain/sat_placement/trunk/display_volume.m $
 $Rev: 26148 $
 $Author: ozh@RADIOLOGY.UCSF.EDU $
 $Date: 2012-09-18 17:36:15 -0700 (Tue, 18 Sep 2012) $

Creates a 3d view of an image volume
v - volume to display
x_axis, etc. - positions of pixels of the volume in mm
X_slices, etc. - axial, sagittal and coronal slices to cut through the
volume
max_val - for intensity scaling

%}

function display_volume(v,x_axis, y_axis, z_axis,X_slices,Y_slices,Z_slices, max_val)

if(nargin < 8)
    max_val=0;
end;

figure;
%opengl verbose;
opengl quiet;
%set(gcf, 'Renderer', 'OpenGL');

ha = axes();
whitebg('k');

[x_mesh,y_mesh,z_mesh] = meshgrid(x_axis, y_axis, z_axis);

[ymax, xmax, zmax] = size(v);
v1 = v;
if(max_val>0)
    for k=1:zmax
    for j=1:xmax                                                                                                             
    for i=1:ymax
        if(v1(i,j,k) > max_val)                                                                                                     
            v1(i,j,k) = max_val;                                                                                
        end;                                                                                                                
    end;                                                                                                                    
    end;   
    end;
end;
h = slice(x_mesh,y_mesh,z_mesh,v1,...
    X_slices,Y_slices,Z_slices, 'nearest');
set(h,'EdgeColor','none');
set(h,'FaceAlpha', 'flat');
colormap(gray);
axis equal;
axis vis3d;

alpha('color');
%{
for i=1:length(h)
    set(h(i), 'FaceAlpha', 'interp');
end;
%}
set(ha, 'Alim', [max_val/10 max_val/5]);
