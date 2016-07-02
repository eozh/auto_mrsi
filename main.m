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

  
 $URL: https://intrarad.ucsf.edu/svn/rad_software/surbeck/brain/sat_placement/trunk/main.m $
 $Rev: 26148 $
 $Author: ozh@RADIOLOGY.UCSF.EDU $
 $Date: 2012-09-18 17:36:15 -0700 (Tue, 18 Sep 2012) $

main program
directory - directory with dicom files to use
graphics ('0' or '1') - whether to create any visualization windows
output_path - directory where the files with calculated prescription will
be written.

%}

function main(directory, graphics, output_path)

if(nargin < 3)
    output_path = 'output';
end;
output_path 

if(nargin < 2)
    graphics = true;
else
    graphics = str2num(graphics);
end;
graphics

if(nargin < 1)
    directory = '.';
end;
directory

debug=0;

%[v,x_axis,y_axis,z_axis] = load_series(directory,64);
%[v,x_axis,y_axis,z_axis] = load_series(directory,75);
%segment;
[v,x_axis,y_axis,z_axis] = load_series(directory);
segment_k;
%calc_3d;
%calc_3d_phantom;
calc_box;
export_box(x0_box, strcat(output_path,'/press_box.dat'));
calc_bands;
export_bands(x0, strcat(output_path,'/sat_bands.dat'));
%coverage;
pause(15);
%to make the stupid compiler not miss that function:
if(0)
mia_Stop3dCursor();
end;

