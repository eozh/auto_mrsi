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

  
 $URL: https://intrarad.ucsf.edu/svn/rad_software/surbeck/brain/sat_placement/trunk/display_bands_3d.m $
 $Rev: 26148 $
 $Author: ozh@RADIOLOGY.UCSF.EDU $
 $Date: 2012-09-18 17:36:15 -0700 (Tue, 18 Sep 2012) $

 visualizes the sat bands in 3d and returns the handles to the line
 segments to the edges. these can be updated later without creating a new
 figure.

%}

function edge_handles = display_bands_3d(A, B, D, T,...
    X_slices, Y_slices, Z_slices,...
    x_min, x_max, y_min, y_max, z_min, z_max, color)

if(nargin < 14)
    color = 'y';
end;


for i=1:length(A)

    for j=1:2
        d = D(i)+(j-1)*T(i);
        for k=1:length(X_slices)
            [XData,YData,ZData] = calc_edge(A(i), B(i), d,...
                'X',X_slices(k),...
                x_min, x_max, y_min, y_max, z_min, z_max);
            h = line(XData,YData,ZData,'Color',color, 'LineWidth', 3);
            edge_handles(i,j,1,k) = h;
        end;
        for k=1:length(Y_slices)
            [XData,YData,ZData] = calc_edge(A(i), B(i), d,...
                'Y',Y_slices(k),...
                x_min, x_max, y_min, y_max, z_min, z_max);
            h = line(XData,YData,ZData,'Color',color, 'LineWidth', 3);
            edge_handles(i,j,2,k) = h;
        end;
        for k=1:length(Z_slices)
            [XData,YData,ZData] = calc_edge(A(i), B(i), d,...
                'Z',Z_slices(k),...
                x_min, x_max, y_min, y_max, z_min, z_max);
            h = line(XData,YData,ZData,'Color',color, 'LineWidth', 3);
            edge_handles(i,j,3,k) = h;
        end;
    end;        
end;
