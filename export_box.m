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

  
 $URL: https://intrarad.ucsf.edu/svn/rad_software/surbeck/brain/sat_placement/trunk/export_box.m $
 $Rev: 26148 $
 $Author: ozh@RADIOLOGY.UCSF.EDU $
 $Date: 2012-09-18 17:36:15 -0700 (Tue, 18 Sep 2012) $

outputs calculated PRESS box prescription to file

%}

function export_box(x0, fileName)

f = fopen(fileName,'w');

% loc_l, loc_p, loc_s

alpha = x0(2,4)-pi;

x1 = x0(3,5);
x2 = x0(3,6);

y1 = x0(3,2); % reversed since the positive location - P - back is the second one
y2 = x0(3,1);

z1 = x0(3,3);
z2 = x0(3,4);

dy = (y1+(-y2))/2;
dz = (z1+(-z2))/2;

loc_l = (x1+(-x2))/2;

loc_p = dy*cos(alpha)+dz*sin(alpha);

loc_s = -dy*sin(alpha)+dz*cos(alpha);

fprintf(f,'%f %f %f\n',loc_l, loc_p, loc_s);

% len_x, len_y, len_z
len_x = x1 + x2;
len_y = y1 + y2;
len_z = z1 + z2;

fprintf(f,'%f %f %f\n',len_x, len_y, len_z);

% alpha, beta, gamma
fprintf(f,'%f %f %f\n',alpha, 0, 0);

fclose(f);
