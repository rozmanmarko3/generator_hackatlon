function [new_lat,new_lon] = moveCoordinates(lat,lon)
% Initial GPS coordinates (example)
lat_letter = lat(end);
lat = str2double(lat(1:end-1));

lon_letter = lon(end);
lon = str2double(lon(1:end-1));

% Generate random distance between 1 and 13 km
distance_km = (randi([100, 13000]))/1000;

% Generate random angle between 0 and 360 degrees
angle_deg = rand * 360;

% Convert distance from km to degrees (approximately)
distance_deg = distance_km / 111; % 1 degree is approximately 111 km

% Convert angle from degrees to radians
angle_rad = deg2rad(angle_deg);

% Calculate new latitude and longitude
new_lat = lat + distance_deg * cos(angle_rad);
new_lon = lon + distance_deg * sin(angle_rad);

new_lat = [num2str(new_lat),lat_letter];
new_lon = [num2str(new_lon),lon_letter];

end

