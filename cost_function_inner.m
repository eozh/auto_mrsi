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

  
 $URL: https://intrarad.ucsf.edu/svn/rad_software/surbeck/brain/sat_placement/trunk/cost_function_inner.m $
 $Rev: 26148 $
 $Author: ozh@RADIOLOGY.UCSF.EDU $
 $Date: 2012-09-18 17:36:15 -0700 (Tue, 18 Sep 2012) $

cost function for press box optimization
ALPHA - alpha angles of box faces
BETA - beta...
D - distances to box faces
Xf, Yf, Zf - 3d points on the fat surface
wd - distance weight
wp - penalty weight

The cost function measures how "good" the prescription is. The less the
cost function, the better the prescription. It has two terms.
The distance term estimates the volume of the box. The bigger the volume -
the better the prescription.
The penalty term adds penalty, proportional to sum of squares of the
distances of all the fat points on the "wrong" side of the box. So the
bigger the box grows, the bigger the penalty.
weight constants allow to fine-tune the balance of those factors.

%}


function r = cost_function_inner(ALPHA, BETA, D, Xf, Yf, Zf, wd, wp)

% experimental
% constrain the box within the head

%note: alpha, beta in degrees!

% calculate plane parameters
C = cos(BETA*pi/180);
A = sin(BETA*pi/180).*cos(ALPHA*pi/180);
B = sin(BETA*pi/180).*sin(ALPHA*pi/180);

%A
%B
%C
%X
%Y
%Z


% convert A, B, C, X, Y, Z into matrices of appropriate dimensions

AA = full(A(:)).'; 
BB = full(B(:)).'; 
CC = full(C(:)).'; 
DD = full(D(:)).'; 

XX = full(Xf(:));
YY = full(Yf(:));
ZZ = full(Zf(:));


nx = length(AA); ny = length(XX);

AA = AA(ones(ny, 1),:);
BB = BB(ones(ny, 1),:);
CC = CC(ones(ny, 1),:);
DD = DD(ones(ny, 1),:);


XX = XX(:,ones(1, nx));
YY = YY(:,ones(1, nx));
ZZ = ZZ(:,ones(1, nx));

DP = AA.*XX+BB.*YY+CC.*ZZ-DD;


% DP < 0 means that a point is inside a band

MIND = min(abs(DP),[],2).*prod(double(DP<0),2); %vector only rows where all DP<0, the smallest distances


penalty = sum(MIND.*MIND);

%logic: d_mesure should approximate volume - so it should be ~x^3
root = length(D)/3; 

d_measure = prod(D)^(1/root); % estimates volume, since distances are there twice...

r = -d_measure*wd + penalty*wp;

