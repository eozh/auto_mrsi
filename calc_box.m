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
 $Rev: 26148 $
 $Author: ozh@RADIOLOGY.UCSF.EDU $
 $Date: 2012-09-18 17:36:15 -0700 (Tue, 18 Sep 2012) $

This file contains the code for PRESS box placement. It is invoked
called from main.m. All variables are global.

%}

% tic and toc measure the time to run a piece of code
tic;
%%

% axial, sagittal and coronal slices for 3D visualization
X_slices = x_axis(128);
Y_slices = [y_axis(128)];
Z_slices = [z_axis(45)];

x_min = min(x_axis); 
x_max = max(x_axis);
y_min = min(y_axis);
y_max = max(y_axis); 
z_min = min(z_axis); 
z_max = max(z_axis);

[ny, nx, nz] = size(brain_mask);
pixel_size = [(x_max-x_min)/nx, (y_max-y_min)/ny, (z_max-z_min)/nz];

display_max = centers1(2)*2

%% calculate cutoff level (experimental)
% everything below this level is discarded. the bottom slices of the image
% cannot be reliably segmented
% finds the level where the brain occupies less than 10% of the area of the
% slice

level = 0;

total_area = nx*ny/2;
for k=nz/2:-1:1
    area = 0;
    for i=1:ny/2
    for j=1:nx
        if(brain_mask(i,j,k)~=0)
            area = area+1;
        end;
    end;
    end;
    %fprintf('slice: %d area: %d total area: %f\n', k, area, total_area);
    if(level==0 && area/total_area<0.1)
        level = k;
    end;
end;

level


%% sample masks
% generates arays of 3D points, representing brain and fat surfaces

dx = 10;
dy = 10;
dz = 10;

[ Xb,Yb,Zb ] = sample_mask( brain_mask, dx,dy,dz, x_axis, y_axis, z_axis, 15 ); %15 instead of level
[ Xf,Yf,Zf ] = sample_mask( fat_mask, dx,dy,dz, x_axis, y_axis, z_axis, 15 ); %15 instead of level

% visualization
if(debug)
    %set(0,'DefaultFigureWindowStyle','docked');    
%    display_volume(v,x_axis, y_axis, z_axis,X_slices,Y_slices,Z_slices, 5000);
%    display_volume(v,x_axis, y_axis, z_axis,[1000],[],[], 5000);
%    view(90,0);
    figure;
    axis equal;
    axis vis3d;
    whitebg('k');
    grid on;
    hold on;
    plot3(Xb,Yb,Zb,'o', 'MarkerEdgeColor', [.49 1 .63],'MarkerFaceColor',[.49 1 .63], 'MarkerSize',9);
    plot3(Xf,Yf,Zf,'o', 'MarkerEdgeColor', [1 0.6 0.2],'MarkerFaceColor',[1 0.6 0.2], 'MarkerSize',9);
    drawnow;
    hold off;
end;

% move the origin of the corrdinate system to the center of the brain

% calculate center of points
xc = mean(Xb);
yc = mean(Yb);
zc = mean(Zb);

zc = zc + 20; % to avoid the problems when moving the bottom plane up 

fprintf('center of points: %f %f %f\n',xc,yc,zc);

Xb0 = Xb - xc;
Yb0 = Yb - yc;
Zb0 = Zb - zc;

Xf0 = Xf - xc;
Yf0 = Yf - yc;
Zf0 = Zf - zc;


x_axis_0 = x_axis - xc; 
y_axis_0 = y_axis - yc;
z_axis_0 = z_axis - zc;

X_slices_0 = X_slices - xc; 
Y_slices_0 = Y_slices - yc; 
Z_slices_0 = Z_slices - zc; 

x_min_0 = x_min - xc;
x_max_0 = x_max - xc;
y_min_0 = y_min - yc;
y_max_0 = y_max - yc;
z_min_0 = z_min - zc;
z_max_0 = z_max - zc;

%% find landmarks
% the lower plane is defined by two landmarks:
% the most inferior brain point of the most anterior slice that has brain
% the same of the most posterior slice

[ny, nx, nz] = size(brain_mask);

min_y = min(Yb0(Zb0>0));
max_y = max(Yb0);

found = false;

for k=level:nz
for i=1:ny
for j=1:nx
    if(brain_mask(i,j,k)~=0 && ~found)
        ax = x_axis_0(2*j); %assuming mask is undersampled 2x
        ay = y_axis_0(2*i);
        az = z_axis_0(k);
        
        if(abs(ay-min_y)<5)
            found = true;
        end;
    end;
end;
end;
end;

fprintf('anterior landmark: %f %f %f\n',ax,ay,az);

found = false;

for k=15:nz %starting from 15th slice. maybe later determine the back cutoff slice more flexibly...
for i=ny:-1:1
for j=1:nx
    if(brain_mask(i,j,k)~=0 && ~found)
        px = x_axis_0(2*j); %assuming mask is undersampled 2x
        py = y_axis_0(2*i);
        pz = z_axis_0(k);
        
        if(abs(py-max_y)<5)
            found = true;
        end;
    end;
end;
end;
end;


fprintf('posterior landmark: %f %f %f\n',px,py,pz);

%% raise landmarks by 10
% a fudge factor...

az = az + 10;
pz = pz + 10;

%% find bottom plane parameters

% oblique angle

alpha0 = atan2(az-pz,py-ay)

% distance

lower_d = sin(alpha0)*ay+cos(alpha0)*az


%% optimize box position
% x00 is the initial placement of the faces of the press box
% first row - alpha, then beta, then distance, then thickness (not used,
% for compatibility with sat band routines)


%alpha0 = 0;
%       front       back        top       bottom    left right
x00 = [ pi/2        pi/2        pi/2      pi/2      0    pi
       -pi/2+alpha0 pi/2+alpha0 0+alpha0  pi+alpha0 pi/2 pi/2
        std(Yb0)    std(Yb0)    std(Zb0)  -lower_d  std(Xb0) std(Xb0)
        0           0           0         0         0    0
       ];
 
%front
%back
%top
%bottom
%sides (left, right)

% remove points below bottom band
c = cos(x00(2,4));
a = sin(x00(2,4)).*cos(x00(1,4));
b = sin(x00(2,4)).*sin(x00(1,4));
d = x00(3,4);

%new arrays
Xf1 = 0;
Yf1 = 0;
Zf1 = 0;
Xb1 = 0;
Yb1 = 0;
Zb1 = 0;

n = 1;
for i=1:length(Xb)
    if(a*Xb0(i)+b*Yb0(i)+c*Zb0(i)-d < 0)
        Xb1(n) = Xb0(i);
        Yb1(n) = Yb0(i);
        Zb1(n) = Zb0(i);
        n = n + 1;
    end;
end;

n = 1;
for i=1:length(Xf)
    if(a*Xf0(i)+b*Yf0(i)+c*Zf0(i)-d < 0)
        Xf1(n) = Xf0(i);
        Yf1(n) = Yf0(i);
        Zf1(n) = Zf0(i);
        n = n + 1;
    end;
end;


if(graphics)
%    set(0,'DefaultFigureWindowStyle','docked');    
%    X_slices_0 = x_axis_0(116);
%    Y_slices_0 = [];
%    Z_slices_0 = [];
    display_volume(v,x_axis_0, y_axis_0, z_axis_0,X_slices_0,Y_slices_0,Z_slices_0, display_max);

    edge_handles = display_bands_3d(...
        x00(1,:),...
        x00(2,:),...
        x00(3,:),...
        x00(4,:),...
        X_slices_0, Y_slices_0, Z_slices_0,...
        x_min_0, x_max_0, y_min_0, y_max_0, z_min_0, z_max_0);

    view(90,0);
    hold on;
    %plot3(Xb1,Yb1,Zb1,'o', 'MarkerEdgeColor', [.49 1 .63],'MarkerFaceColor',[.49 1 .63], 'MarkerSize',9);
    %plot3(Xf1,Yf1,Zf1,'o', 'MarkerEdgeColor', [1 0.6 0.2],'MarkerFaceColor',[1 0.6 0.2], 'MarkerSize',5);
    drawnow;
    hold off;
end;


%% optimize distances only
x0 = x00;
 

%pause();

options = optimset();


options = optimset('Display', 'iter',...
        'TolX',1e-3, 'TolFun',1e-3, 'LargeScale','off'...
);

% fmincon - matlabs optimization function. it takes a function to be
% optimized and initial values. Here the function is an anonymous function
% of x, which is a wrapper over cost_function_inner that passes some of the
% unknowns to it, while keeping the others fixed
% cost_function_inner takes alpha, beta, distance of the faces of the press
% box, 3D points of the fat surface (Xf1, Yf1, Zf1) and weights.
% the returned values are vector x, containing the calculated optimal
% values of the unknowns and the value of the cost function for those
% parameters

[x,fval] = fmincon(@(x) cost_function_inner(...
        x0(1,:)*180/pi,...
        x0(2,:)*180/pi,...
        [x(1) x(2) x(3) x0(3,4) x(4) x(5)],...
        Xf1,Yf1,Zf1, 1,15),...
        [x0(3,1) x0(3,2) x0(3,3) x0(3,5) x0(3,6)],...
        [],[],[],[],...
        zeros(5,1),[max(abs(Yf1)) max(abs(Yf1)) max(abs(Zf1)) max(abs(Xf1)) max(abs(Xf1))],...`
        [],...
        options);
    
% display x
    
x    
    
% copy optimal values to the x0 array that defines current prescription

x0(3,1:3) = x(1:3);
x0(3,5:6) = x(4:5);

% almost cheating: reduce distances
% just being more conservative...
x0(3,1:2) = x0(3,1:2) - 5;
x0(3,5:6) = x0(3,5:6) - 5;


% update the 3D figure with prescription

if(graphics)
    view(90,0);
    outfun_3d(...
        x0(1,:), x0(2,:), x0(3,:), x0(4,:),...
        [],'done',...
        x_min_0, x_max_0, y_min_0, y_max_0, z_min_0, z_max_0,...
        X_slices_0, Y_slices_0, Z_slices_0, edge_handles);
    
    drawnow;
end;




%% reusing lower band
% saving the values to be used for sat bands

theta = x0(2,4)-pi;
lower_d = x0(3,4);

%% move box back to the patient coordinate system
ALPHA = x0(1,:);
BETA  = x0(2,:);
C = cos(BETA);
A = sin(BETA).*cos(ALPHA);
B = sin(BETA).*sin(ALPHA);
D = x0(3,:);
D = D + A*xc+B*yc+C*zc;
x0(3,:) = D

% re-visualize in patient coordinates for testing
if(false)
%    set(0,'DefaultFigureWindowStyle','docked');    
    display_volume(v,x_axis, y_axis, z_axis,X_slices,Y_slices,Z_slices, display_max);
    
    edge_handles = display_bands_3d(...
        x0(1,:),...
        x0(2,:),...
        x0(3,:),...
        x0(4,:),...
        X_slices, Y_slices, Z_slices,...
        x_min, x_max, y_min, y_max, z_min, z_max);
    
    view(90,0);
    hold on;
    %plot3(Xf,Yf,Zf,'c.');
    plot3(Xb,Yb,Zb,'o', 'MarkerEdgeColor', [.49 1 .63],'MarkerFaceColor',[.49 1 .63], 'MarkerSize',9);
    drawnow;
    hold off;
end;
    

x0_box = x0;

x0_box

%%
toc;    
