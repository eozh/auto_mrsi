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

function to update the visualization of the prescription. 
can be passed to the optimization function to update the view while
iterating

%}

function stop = outfun_3d(A,B,D,T,optimValues,state,...
    xmin, xmax, ymin, ymax, zmin, zmax,...
    X_slices, Y_slices, Z_slices, edge_handles)
    
    persistent t0;
    
    if(isempty(t0))
        t0 = clock();
    end;

    t = clock;
    if(etime(t,t0)>10 || strcmp(state,'done'))
        for i=1:length(A)
            for j=1:2
                d = D(i)+(j-1)*T(i);

                for k=1:length(X_slices)
                    [XData,YData,ZData] = calc_edge(A(i), B(i), d,...
                        'X',X_slices(k),...
                        xmin, xmax, ymin, ymax, zmin, zmax);
                    h = edge_handles(i,j,1,k);
                    set(h, 'XData', XData);
                    set(h, 'YData', YData);
                    set(h, 'ZData', ZData);
                end;

                for k=1:length(Y_slices)
                    [XData,YData,ZData] = calc_edge(A(i), B(i), d,...
                        'Y',Y_slices(k),...
                        xmin, xmax, ymin, ymax, zmin, zmax);
                    h = edge_handles(i,j,2,k);
                    set(h, 'XData', XData);
                    set(h, 'YData', YData);
                    set(h, 'ZData', ZData);
                end;

                for k=1:length(Z_slices)
                    [XData,YData,ZData] = calc_edge(A(i), B(i), d,...
                        'Z',Z_slices(k),...
                        xmin, xmax, ymin, ymax, zmin, zmax);
                    h = edge_handles(i,j,3,k);
                    set(h, 'XData', XData);
                    set(h, 'YData', YData);
                    set(h, 'ZData', ZData);
                end;
            end;
        end;
%        pause(0.5);
        drawnow;
        t0 = clock;
    end;
    
    stop = false;

    switch state
        case 'init'
            hold on
        case 'iter'
%            x
        case 'done'
            hold off
        otherwise
    end
end