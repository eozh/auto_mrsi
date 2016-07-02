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

  
 $URL: https://intrarad.ucsf.edu/svn/rad_software/surbeck/brain/sat_placement/trunk/calc_bands.m $
 $Rev: 26148 $
 $Author: ozh@RADIOLOGY.UCSF.EDU $
 $Date: 2012-09-18 17:36:15 -0700 (Tue, 18 Sep 2012) $

This file contains the code for auto sat band placement. It is invoked
called from main.m. All variables are global.

%}


tic;
%% optimize bands

% this is the initial configuration of bands.
% first row - alphas of all bands
% second - betas
% third - distance
% fourth - thickness

x00 = [ pi/2         pi/2         pi/2    pi/2  pi/6 -pi/6 pi-pi/6 -pi+pi/6 pi/2
       -pi/2+theta pi/2+theta pi/6+theta  -pi/6+theta pi/2 pi/2 pi/2 pi/2 pi+theta
       200    200  200   200   200  200  200  200  lower_d
       0      0    0     0     0    0    0    0    0
     ];

% 1 - front 
% 2 - back
% 3 - top-back
% 4 - top-front
%     aplha = pi/2 -> direction back 

% initialize visualization. the subsequent visualizations will update this
% figure
if(graphics)
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
%    plot3(Xb1,Yb1,Zb1,'o', 'MarkerEdgeColor', [.49 1 .63],'MarkerFaceColor',[.49 1 .63], 'MarkerSize',9);
%    plot3(Xf1,Yf1,Zf1,'o', 'MarkerEdgeColor', [1 0.6 0.2],'MarkerFaceColor',[1 0.6 0.2], 'MarkerSize',9);
    drawnow;
    hold off;
end;

%% first - optimize distances only while keeping angles fixed
x0 = x00;
 
options = optimset();
options = optimset('Display', 'iter',...
        'TolX',1e-3, 'TolFun',1e-3, 'LargeScale','off'...
);

% for now optimizing distances only
% fminunc takes a function to be optimized and initial values
% here function to be optimized is an anonymous function of x that passes some
% unknowns to cost_function_lsq, while keeping the rest of the parameters
% fixed
% the returned value of x is those parameters that minimized the function
[x,fval] = fminunc(@(x) cost_function_lsq(...
        x0(1,:)*180/pi,...
        x0(2,:)*180/pi,...
        [x(1:4) x(5) x(6) x(5) x(6) x0(3,9)],...
        Xf1,Yf1,Zf1, 100,10),...
        x0(3,1:8),options);

% print them
x    
    
% update the x0 matrix with the optimized parameters
x0(3,1:4) = x(1:4);    
x0(3,5:6) = x(5:6); 
x0(3,7:8) = x(5:6); % not a typo

% visualize
if(graphics)
    outfun_3d(...
        x0(1,:), x0(2,:), x0(3,:), x0(4,:),...
        [],'done',...
        x_min_0, x_max_0, y_min_0, y_max_0, z_min_0, z_max_0,...
        X_slices_0, Y_slices_0, Z_slices_0, edge_handles);

    drawnow;
end;

%pause();


%% optimize bands sagittaly
% current x0 is used as initial conditions

[x,fval] = fminunc(@(x) cost_function_lsq(...
        [x0(1,:)*180/pi],...
        [x(1:4) x0(2,5:9)*180/pi],...
        [x(5:8) x0(3,5:9)],...
        Xf1,Yf1,Zf1,0,20),...
        [x0(2,1:4)*180/pi x0(3,1:4)],options);

x    

x0(2,1:4) = x(1:4)/180*pi;
x0(3,1:4) = x(5:8);

x0

if(graphics)
    view(90,0);
    outfun_3d(...
        x0(1,:), x0(2,:), x0(3,:), x0(4,:),...
        [],'done',...
        x_min_0, x_max_0, y_min_0, y_max_0, z_min_0, z_max_0,...
        X_slices_0, Y_slices_0, Z_slices_0, edge_handles);

    drawnow;
end;


%% axial optimization
[x,fval] = fminunc(@(x) cost_function_lsq(...
        [x0(1,1:4)*180/pi x(1) x(2) 180-x(1) 180-x(2) x0(1,9)*180/pi],...
        x0(2,:)*180/pi,...
        [x(3) x(4) x0(3,3) x0(3,4) x(5) x(6) x(5) x(6) x0(3,9)],...
        Xf1,Yf1,Zf1, 0, 10),...
        [x0(1,5:6)*180/pi x0(3,1:2) x0(3,5:6)],options);

x    

x0(1,5:6) = x(1:2)/180*pi;
x0(1,7:8) = pi - x(1:2)/180*pi;
x0(3,1:2) = x(3:4);
x0(3,5:6) = x(5:6);
x0(3,7:8) = x(5:6);

x0

%

if(graphics)
    view(90,0);
    outfun_3d(...
        x0(1,:), x0(2,:), x0(3,:), x0(4,:),...
        [],'done',...
        x_min_0, x_max_0, y_min_0, y_max_0, z_min_0, z_max_0,...
        X_slices_0, Y_slices_0, Z_slices_0, edge_handles);

    drawnow;
end;




%% make more aggessive & add thickness

% make placement more aggressive by reducing the distances.
x0(3,1:2) = x0(3,1:2)-15;
x0(3,3:4) = x0(3,3:4)-15; %additionally for top bands
x0(3,5:8) = x0(3,5:8)-15;


% setting the fixed thickness of 45 mm
x0(4,:) = [45 45 45 45 45 45 45 45 45];


if(graphics)

    outfun_3d(...
        x0(1,:), x0(2,:), x0(3,:), x0(4,:),...
        [],'done',...
        x_min_0, x_max_0, y_min_0, y_max_0, z_min_0, z_max_0,...
        X_slices_0, Y_slices_0, Z_slices_0, edge_handles);

    drawnow;
end;



%% move box back to the patient coordinate system
ALPHA = x0(1,:);
BETA  = x0(2,:);
C = cos(BETA);
A = sin(BETA).*cos(ALPHA);
B = sin(BETA).*sin(ALPHA);
D = x0(3,:);
D = D + A*xc+B*yc+C*zc;
x0(3,:) = D

%% mask bands
% generates an image volume with sat bands burnt into the pixel data and 
% visualizes it in 3 planes using orthogonalslicer

if(graphics)
%set(0,'DefaultFigureWindowStyle','docked');
pixel_size = [abs(x_axis(2)-x_axis(1)), abs(y_axis(2)-y_axis(1)), abs(z_axis(2)-z_axis(1))]
v1 = mask_bands(v, x0(1,:), x0(2,:), x0(3,:), x0(4,:),x_axis, y_axis, z_axis, true, display_max);
v2 = mask_bands(v1, x0_box(1,:), x0_box(2,:), x0_box(3,:), [5 5 5 5 5 5] ,x_axis, y_axis, z_axis, false, 50);
orthogonalslicer(v2, pixel_size,'gray',0, display_max);
end;

%%

toc;    