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

  
 $URL: https://intrarad.ucsf.edu/svn/rad_software/surbeck/brain/sat_placement/trunk/calc_edge.m $
 $Rev: 26148 $
 $Author: ozh@RADIOLOGY.UCSF.EDU $
 $Date: 2012-09-18 17:36:15 -0700 (Tue, 18 Sep 2012) $

Function to calculate the coordinates of a plane edge as intersected by
an axial, sagitta or coronal slice at position slice_pos within a volume,
defined by xmin, xmax, etc.

axis can be 'X', 'Y' or 'Z'

This function is used for 3D visualization of sat bands and press box faces

%}


function [XData,YData,ZData] = calc_edge(alpha, beta, distance,axis,slice_pos,...
                                xmin, xmax, ymin, ymax, zmin, zmax)
                            
c = cos(beta);
a = sin(beta)*cos(alpha);
b = sin(beta)*sin(alpha);
d = -distance;

P = zeros(2,3);

if(axis=='Z')
    z = slice_pos;
    n = 1;
    for k=0:1
       x = xmin*(1-k) + xmax*k;
       y = - (a*x+c*z+d)/b;
       if y>=ymin && y<=ymax
           P(n,:) = [x y z];
           n = n+1;
       end;
    end
    for j=0:1
       y = ymin*(1-j) + ymax*j;
       x = - (b*y+c*z+d)/a;
       if x>=xmin && x<=xmax
           P(n,:) = [x y z];
           n = n+1;
       end;
    end;
end;

if(axis=='X')
   x = slice_pos;
   n = 1;
   for i=0:1
       z = zmin*(1-i) + zmax*i;
       y = - (a*x+c*z+d)/b;
       if y>=ymin && y<=ymax
           P(n,:) = [x y z];
           n = n+1;
       end;
   end
   for j=0:1
       y = ymin*(1-j) + ymax*j;
       z = - (a*x+b*y+d)/c;
       if z>=zmin && z<=zmax
           P(n,:) = [x y z];
           n = n+1;
       end;
   end
end;

if(axis=='Y')
   y = slice_pos;
   n = 1;
   for i=0:1
       z = zmin*(1-i) + zmax*i;
       x = - (b*y+c*z+d)/a;
       if x>=xmin && x<=xmax
           P(n,:) = [x y z];
           n = n+1;
       end;
   end
   for k=0:1
       x = xmin*(1-k) + xmax*k;
       z = - (a*x+b*y+d)/c;
       if z>=zmin && z<=zmax
           P(n,:) = [x y z];
           n = n+1;
       end;
   end
end;

XData = P(:,1)';
YData = P(:,2)';
ZData = P(:,3)';
