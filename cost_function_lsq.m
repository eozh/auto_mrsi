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

  
 $URL: https://intrarad.ucsf.edu/svn/rad_software/surbeck/brain/sat_placement/trunk/cost_function_lsq.m $
 $Rev: 26148 $
 $Author: ozh@RADIOLOGY.UCSF.EDU $
 $Date: 2012-09-18 17:36:15 -0700 (Tue, 18 Sep 2012) $

cost function for sat band optimization
ALPHA - alpha angles of sat bands
BETA - beta...
D - distances to sat bands
Xb, Yb, Zb - 3d points on the brain surface
wd - distance weight
wp - penalty weight

The cost function measures how "good" the prescription is. The less the
cost function, the better the prescription. It has three terms.

The first term is sum of squares of distances from brain point to the
closest bands. The closer the bands are to the surface, the smaller this
term is.

The second term is a measure of all distances of sat bands from origin. If
the distances get too big - the cost function gets bigger.

The third term - penalty - is a sum of square of the distances of the brain
points outside the sat bands. It penalizes the configurations where the sat
bands encroach on the brain too much.

Weights are used to fine-tune the balance of those factors.

%}

function r = cost_function_lsq(ALPHA, BETA, D, Xb, Yb, Zb, wd, wp)

%note: alpha, beta in degrees!

% claculate plane parameters
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

XX = full(Xb(:));
YY = full(Yb(:));
ZZ = full(Zb(:));


nx = length(AA); ny = length(XX);

AA = AA(ones(ny, 1),:);
BB = BB(ones(ny, 1),:);
CC = CC(ones(ny, 1),:);
DD = DD(ones(ny, 1),:);


XX = XX(:,ones(1, nx));
YY = YY(:,ones(1, nx));
ZZ = ZZ(:,ones(1, nx));

% calculate distance matrix DP

DP = abs(AA.*XX+BB.*YY+CC.*ZZ-DD);


% calculate D_min - minimum-distance vector for all points
D_min = min(DP,[],2);

% calculate sum of squares of D_min

r = sum(D_min(:).^2);


%% add penalty for positive distances (brain pixels outside)
penalty_weight = wp;

% calculate distance matrix DP

DP = AA.*XX+BB.*YY+CC.*ZZ-DD;


penalty = sum(DP(DP>0));

r = r + norm(D)*wd+penalty*penalty_weight;

%disp(D);
%disp(ALPHA);
%disp(BETA);
%disp(penalty);
