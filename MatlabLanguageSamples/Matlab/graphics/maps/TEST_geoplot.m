%Test geoplotting
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/24/22: Created.  R2018b does not have street support

clear
clc
close all

tic

%Read in sample data
trk = gpxread('sample_mixed.gpx','FeatureType','track');
wpt = gpxread('sample_mixed.gpx');

%% Plot using variuos geoplotting functions
figure;
geodensityplot(trk.Latitude,trk.Longitude,trk.Elevation,'Radius',1000);
hold on         %need to turn hold on after using a geoplot
geoplot(trk.Latitude,trk.Longitude,'LineWidth',2);
geoscatter(wpt.Latitude,wpt.Longitude,'filled');

%% Base map and limits
%Change the base map
geobasemap('streets')
 
%Change the axis limits (zoom out a little bit)
geolimits([44.40 44.64],[-72.85 -72.42])

%% Annotations
text(wpt.Latitude,wpt.Longitude,wpt.Name);
legend('Flight Elevation','Flight Path','Waypoints')
title('Glide flight and waypoints')

toc
disp('DONE!')
