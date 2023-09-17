% Satellite Example
%
%--- Copyright notice ---%
% Copyright (C) 2021 The University of Manchester
% Written by David Mostaza Prieto,  Nicholas H. Crisp, Luciana Sinpetru and Sabrina Livadiotti
%
% This file is part of the ADBSat toolkit.
%
% This program is free software: you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or (at
% your option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.
%
% You should have received a copy of the GNU General Public License along
% with this program. If not, see <http://www.gnu.org/licenses/>.
%------------ BEGIN CODE ----------%

clear

modName = 'satellite';
% Path to model file
ADBSat_path = ADBSat_dynpath;
modIn = fullfile(ADBSat_path,'inou','obj_files',[modName,'.obj']);
modOut = fullfile(ADBSat_path,'inou','models');
resOut = fullfile(ADBSat_path,'inou','results',modName);

% Download Space Weather Data
dl_SWData
matfile = aeroReadSpaceWeatherData("SW-All.csv", FolderName=fullfile(ADBSat_path,'toolbox','sw_data'));

%Input conditions
alt = 370; %km
inc = 89; %deg
lon = 0; % deg
year = 2016;
dayOfYear = 91; 
UTseconds = 0;
AnO = 0;
[f107average,f107daily,magneticIndex] = fluxSolarAndGeomagnetic(year,dayOfYear,UTseconds,matfile);

env = [alt*1e3, inc/2, lon, year, dayOfYear, UTseconds, f107average, f107daily, magneticIndex, AnO]; % Environment variables

aoa_deg = 0; % Angle of attack [deg]
aos_deg = 0; % Angle of sideslip [deg]

% Model parameters
shadow = 1;
inparam.gsi_model = 'DRIA';
inparam.alpha = 0.85; % Accommodation (altitude dependent)
inparam.Tw = 300; % Wall Temperature [K]
% inparam.alphaN = 

solar = 1;
inparam.sol_cR = 0.15; % Specular Reflectivity
inparam.sol_cD = 0.25; % Diffuse Reflectivity

verb = 1;
del = 0;

% Import model
[modOut] = ADBSatImport(modIn, modOut, verb);

% Environment Calculations
inparam = environment(inparam, env(1),env(2),env(3),env(4),env(5),env(6),env(7),env(8),env(9:15),env(16));

% Coefficient Calculation
fileOut = calc_coeff(modOut, resOut, deg2rad(aoa_deg), deg2rad(aos_deg), inparam, shadow, solar, 1, 0); 

% Plot surface distribution
if verb && ~del
    plot_surfq(fileOut, modOut, aoa_deg(1), aos_deg(1), 'cp');
end
%------------ END CODE -----------%
