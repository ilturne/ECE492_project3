%
% This program is to put polar grid on the existing plot
%
rmax = max(460);
nrings = ceil( rmax/25 );	%each 25km 
nangles = 360/30;		%each 30 degree
npts = 100;			%# of points at each ring
theta = linspace(0,2*pi,npts);
RatMax = 25*nrings;		%max. radius for plot

hold on;
for i=1:nrings
    x = 25*i*sin( theta ); 
    y = 25*i*cos( theta ); 
    plot( x,y,'k-' );
end

for i=1:nangles
    x1 = RatMax*sin( (i-1)*30*pi/180 );
    y1 = RatMax*cos( (i-1)*30*pi/180 );
    plot( [0 x1],[0 y1],'k-' );
end
