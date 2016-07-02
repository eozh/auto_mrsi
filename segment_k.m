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

routine to segment the image volume into brain and fat masks using k-means
clustering and morphological opening and closing for post-processing.

all variables are global.

%}

% alternative segmentation using kmeans clustering

fprintf('segmenting...\n');
tic;
[ymax, xmax, zmax] = size(v);

%% 3d kmeans

% downsample v for kmeans clustering
% only using "good" slices in the middle
v1 = v(1:2:ymax,1:2:xmax,30:90);


% for t1v images
fprintf('kmeans clustering...\n');
[idx,centers] = kmeans(v1(:),3, 'emptyaction', 'singleton','display','iter','start','uniform'); 
% sort groups
[centers1,idx1] = sort(centers);
% centers1(j) = centers(idx1(j));
fprintf('cluster centers: %f %f %f\n',centers1(1),centers1(2),centers1(3));
boundary1 = 0.5*(centers1(1)+centers1(2));
boundary2 = 0.5*(centers1(2)+centers1(3));
fprintf('boundaries: %f %f\n',boundary1, boundary2);

%%

% now using all slices
v1 = v(1:2:ymax,1:2:xmax,1:zmax);
[ymax, xmax, zmax] = size(v1);

fprintf('generating masks...\n');
brain_mask = v1>boundary1 & v1<boundary2;
fat_mask = v1>boundary2;
%%
fprintf('post-processing masks...\n');

sel_mask = zeros(5,5,5);
sel_mask(:,:,1) = ...
          [0 0 0 0 0; 
           0 1 1 1 0; 
           0 1 1 1 0;
           0 1 1 1 0;
           0 0 0 0 0;];
sel_mask(:,:,2) = ...
          [0 1 1 1 0; 
           1 1 1 1 1; 
           1 1 1 1 1;
           1 1 1 1 1;
           0 1 1 1 0;];
sel_mask(:,:,3) = ...
          [0 1 1 1 0; 
           1 1 1 1 1; 
           1 1 1 1 1;
           1 1 1 1 1;
           0 1 1 1 0;];
sel_mask(:,:,4) = ...
          [0 1 1 1 0; 
           1 1 1 1 1; 
           1 1 1 1 1;
           1 1 1 1 1;
           0 1 1 1 0;];
sel_mask(:,:,5) = ...
          [0 0 0 0 0; 
           0 1 1 1 0; 
           0 1 1 1 0;
           0 1 1 1 0;
           0 0 0 0 0;];
       
       
%se = strel('disk',5);
se=strel(sel_mask);
      
fat_mask = imclose(fat_mask,se);
brain_mask = imopen(brain_mask,se);
%brain_mask = imerode(brain_mask,se);
%brain_mask = imdilate(brain_mask,se);


%% display segmented mask
if(debug)
    pixel_size = [abs(x_axis(2)-x_axis(1)), abs(y_axis(2)-y_axis(1)), abs(z_axis(2)-z_axis(1))]
    orthogonalslicer(v, pixel_size, 'gray',0);
%    figure('Position', [1,1,ymax*2*2,2*zmax*pixel_size(3)/pixel_size(2)]);
%    colormap(gray);
%    imagesc(rot90(squeeze(v(:,58*2,:))));
%    axis off;

    pixel_size = [abs(x_axis(2)-x_axis(1))*2, abs(y_axis(2)-y_axis(1))*2, abs(z_axis(2)-z_axis(1))]
    orthogonalslicer(double(brain_mask), pixel_size, 'gray',0);
    orthogonalslicer(double(fat_mask), pixel_size, 'gray',0);

% generate color image
    vol = uint8(zeros(xmax,ymax,zmax,3));
    for i=1:xmax
    for j=1:ymax
    for k=1:zmax
        if(brain_mask(i,j,k)~=0)
            vol(i,j,k,2)=255;
        end;
        if(fat_mask(i,j,k)~=0)
            vol(i,j,k,1)=255;
        end;
    end;
    end;
    end;

    figure('Position', [1,1,4*ymax,4*zmax*pixel_size(3)/pixel_size(2)]);
    imagesc(flipdim(permute( squeeze(vol(:,58,:,:)), [2 1 3] ),1));
    axis off;
    
end;
%%

toc;
