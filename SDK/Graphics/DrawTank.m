function DrawTank(x,y,theta,scale,col)

%DRAWTANK Draws a tank object on the plot
%
%   DRAWTANK(X,Y,THETA,SCALE,COL) Draws the a tank at the given X, Y
%   position with the angle THETA.
%
%INPUT:     -X:         x position
%           -Y:         y position
%           -THETA:     angle
%           -SCALE:     scaling factor
%           -COL:       string denoting color, ie 'r'
%
%OUTPUT:    -None

%Version History
%12/04/23: Minor update to documentation

was_hold = ishold;

if ~was_hold
    hold on
end

%Left Track
pts=scale*[	[-.5 -.5 .5 .5 -.5 -.5];
    [0 .1 .1 -.1 -.1 0]+.3];
pts = [cos(-theta) sin(-theta); -sin(-theta) cos(-theta)]*pts+[x;y]*ones(1,length(pts));
patch(	pts(1,:),	pts(2,:),'k');
hold on;

%Right Track
pts=scale*[	[-.5 -.5 .5 .5 -.5 -.5];
    [0 .1 .1 -.1 -.1 0]-.3];
pts = [cos(-theta) sin(-theta); -sin(-theta) cos(-theta)]*pts+[x;y]*ones(1,length(pts));
patch(	pts(1,:),	pts(2,:),'k');

%Body
pts=scale*[	[-.4 -.4 .4 .4 -.4 -.4];
    [0 .32 .32 -.32 -.32 0]];
pts = [cos(-theta) sin(-theta); -sin(-theta) cos(-theta)]*pts+[x;y]*ones(1,length(pts));
patch(	pts(1,:),	pts(2,:),col);

% Dot
% plot(x,y,'k.','MarkerSize',15*scale);
pts=scale*[	-.1 -.1 .1 .1;
    -.1 .1 .1 -.1];
pts = [cos(-theta) sin(-theta); -sin(-theta) cos(-theta)]*pts+[x;y]*ones(1,length(pts));
patch(	pts(1,:),	pts(2,:),'k');

%Turret
pts=scale*[	[0 0 .6 .6 0 0];
    [0 .025 .025 -.025 -.025 0]];
pts = [cos(-theta) sin(-theta); -sin(-theta) cos(-theta)]*pts+[x;y]*ones(1,length(pts));
patch(	pts(1,:),	pts(2,:),'k');

%Return the hold state on the figure
if ~was_hold
    hold off
end