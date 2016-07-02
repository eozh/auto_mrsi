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

burns the bands into the pixel data

v - image volume
A, B, D, T - vectors of alpha, beta, distance, thickness of bands
x_axis, etc. - vectors defining pixel positions of the volume on the axis
in mm
use_pattern - whether to use cross-hatched patern for sat bands
max_val - maximum pixel value


%}

function v1 = mask_bands(v, A, B, D, T, x_axis, y_axis, z_axis, use_pattern, max_val)

if(nargin < 9)
    use_pattern = false;
end;
if(nargin < 10)
    max_val = 5000;
end;

v1 = v;

n_bands = length(A);

c = cos(B);
a = sin(B).*cos(A);
b = sin(B).*sin(A);

d1 = D;
d2 = D+T;

[ymax, xmax, zmax] = size(v);


for k=1:1:zmax
    for i=1:1:ymax
        for j=1:1:xmax
            if(~use_pattern || (mod(i+k,2)==0 && mod(j+k,2)==0))
                x = x_axis(j);
                y = y_axis(i);
                z = z_axis(k);

                w = 0;
                for(l=1:n_bands)
                    s = a(l)*x+b(l)*y+c(l)*z; 
                    if(s>d1(l) && s<d2(l))
                        w=1;
                    end;
                end

                if(w>0)
                    if(use_pattern)
                        v1(i,j,k) = max(max_val-v1(i,j,k),0);
                    else
                        v1(i,j,k) = max_val;
                    end;
                end
            end
        end
    end
end

