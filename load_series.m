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

  
 $URL: https://intrarad.ucsf.edu/svn/rad_software/surbeck/brain/sat_placement/trunk/load_series.m $
 $Rev: 26148 $
 $Author: ozh@RADIOLOGY.UCSF.EDU $
 $Date: 2012-09-18 17:36:15 -0700 (Tue, 18 Sep 2012) $

loads a directory with dicom files. files are expected to have .dcm or .DCM
extension.

max_slices - limit the number of slices to load

output:

v - 3D pixel volume

x_axis, etc. - positions of pixels in the volume in mm.

%}

function [v,x_axis,y_axis,z_axis] = load_series(directory, max_slices)
%assuming image is axial and x and y axis are positive

if(nargin == 1)
    max_slices = 65536;
end;

files = dir(strcat(directory,'/*.DCM'));

if(length(files)==0)
    files = dir(strcat(directory,'/*.dcm'));
end;

if(length(files)==0)
    error('cannot find any dicom images');
end;


for i=1:length(files)
    filename = strcat(directory,'/',files(i,1).name);
    di = dicominfo(filename);
    in = di.InstanceNumber;
    fprintf('slice %d ',in);
    if(in<=max_slices || max_slices==0)
        fprintf('reading... \n');
        v(:,:,in) = double(dicomread(di));
        z_axis(in) = di.ImagePositionPatient(3);
    else
        fprintf('skipping\n');
    end;
end;

delta_x = di.PixelSpacing(1);
delta_y = di.PixelSpacing(2);

x_axis = zeros(1,di.Columns);
y_axis = zeros(1,di.Rows);

for i=1:di.Columns
    x_axis(i) = double(di.ImagePositionPatient(1))+double(i-1)*delta_x;
end;    

for i=1:di.Rows
    y_axis(i) = double(di.ImagePositionPatient(2))+double(i-1)*delta_y;
end;    



