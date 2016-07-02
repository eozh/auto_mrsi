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

  
 $URL: https://intrarad.ucsf.edu/svn/rad_software/surbeck/brain/sat_placement/trunk/calc_box.m $
 $Rev: 26144 $
 $Author: ozh@RADIOLOGY.UCSF.EDU $
 $Date: 2012-09-18 15:21:50 -0700 (Tue, 18 Sep 2012) $

generate a set of 3D points from a 3D mask volume by casting rays from six
directions

dx, dy, dz - how sparse are the rays
level - z cut-off level

%}

function [ X,Y,Z ] = sample_mask( mask, dx,dy,dz, x_axis, y_axis, z_axis, level )


X = 0; % will grow as arrays
Y = 0;
Z = 0;

[ny, nx, nz] = size(mask);


n = 1;

% top

for i=1:dy:ny
for j=1:dx:nx
flag = false;
for k=nz:-1:level
    if(mask(i,j,k)~=0 && ~flag)
        x = x_axis(2*j); %assuming mask is undersampled 2x
        y = y_axis(2*i);
        z = z_axis(k);

        X(n) = x;
        Y(n) = y;
        Z(n) = z;

        n = n+1;
        flag = true;
    end;
end;
end;
end;

% bottom

for i=1:dy:ny
for j=1:dx:nx

    flag=false;
for k=level:1:nz
    if(mask(i,j,k)~=0 && ~flag)
        x = x_axis(2*j);
        y = y_axis(2*i);
        z = z_axis(k);

        X(n) = x;
        Y(n) = y;
        Z(n) = z;

        n = n+1;
        flag = true;
    end;
end;
end;
end;



% front

for k=level:dz:nz
for j=1:dx:nx
flag = false;
for i=1:ny
    if(mask(i,j,k)~=0 && ~flag)
        x = x_axis(2*j);
        y = y_axis(2*i);
        z = z_axis(k);

        X(n) = x;
        Y(n) = y;
        Z(n) = z;

        n = n+1;
        flag = true;
    end;
end;
end;
end;

% back 

for k=level:dz:nz
for j=1:dx:nx
flag = false;
for i=ny:-1:1
    if(mask(i,j,k)~=0 && ~flag)
        x = x_axis(2*j);
        y = y_axis(2*i);
        z = z_axis(k);

        X(n) = x;
        Y(n) = y;
        Z(n) = z;

        n = n+1;
        flag = true;
    end;
end;
end;
end;

% right

for k=level:dz:nz
for i=1:dy:ny
flag = false;
for j=1:nx
    if(mask(i,j,k)~=0 && ~flag)
        x = x_axis(2*j);
        y = y_axis(2*i);
        z = z_axis(k);

        X(n) = x;
        Y(n) = y;
        Z(n) = z;

        n = n+1;
        flag = true;
    end;
end;
end;
end;

% left 

for k=level:dz:nz
for i=1:dy:ny
flag = false;
for j=nx:-1:1
    if(mask(i,j,k)~=0 && ~flag)
        x = x_axis(2*j);
        y = y_axis(2*i);
        z = z_axis(k);

        X(n) = x;
        Y(n) = y;
        Z(n) = z;

        n = n+1;
        flag = true;
    end;
end;
end;
end;
