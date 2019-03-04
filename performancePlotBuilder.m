% version 1.0

% clears previous calculation and figures
clear; close all

% user input
path = 'D:\tools\cpdl\sessions\';   % path to cpdl sessions folder
session = 'test';                   % cpdl session name
g = 720;                            % smoothing window
startyear = 2200;                   % starting year
endyear = 2700;                     % X axis max value
min_delta = 150;                    % Y axis min value
max_delta = 1000;                   % Y axis max value
fps_offset = 800;                   % raises FPS plot above timestamps
observing = 'Galaxy view';          % remarks on how the game was played
crisis = 'contingency';             % encountered in-game crisis
speed = '4';                        % speed the game was played on

% set file to read from
input_filename = strcat(path, session, '\', session,'_performance.csv');

% reading from delimiter-separated file
file_data = dlmread(input_filename, ',', 1, 0);

% set specific columns
timestamp_column = 1;
ticks_column = 2;
fps_column = 3;

% processing data
timestamps = file_data(:, timestamp_column);        % getting timestamps
timestamps = timestamps / 30 / 12 + startyear;      % to ingame date
delta = file_data(:, ticks_column);                 % getting delta
delta = delta / 10000;                              % to milliseconds
fps = file_data(:, fps_column);                     % getting FPS
smooth_delta = smoothdata(delta, 'gaussian', g);    % smoothening delta
smooth_fps = smoothdata(fps, 'gaussian', g);        % smoothening FPS
smooth_fps = smooth_fps + fps_offset;               % offsetting FPS
zero_fps = ones(size(timestamps)) + fps_offset - 1; % 0 FPS plot data
max_fps = ones(size(timestamps)) * 60 + fps_offset; % 60 FPS plot data

figure('Name', 'performance', 'NumberTitle', 'off')
set(gcf,'color',[49/255 82/255 103/255]);           % background color

% plots
hold on
plot(timestamps, smooth_delta, '-g')                % plotting delta
plot(timestamps, smooth_fps, '-r')                  % plotting FPS
plot(timestamps, zero_fps, '-.r')                   % plotting 0 FPS
plot(timestamps, max_fps, '--r')                    % plotting 60 FPS

% legend setup
set(gca, 'Color', [6/255 41/255 56/255])            % legend box color

legend_color_string = '\color[rgb]{0.64, 0.79, 0.88}';

legend(strcat(legend_color_string, 'smoothed signal'), ...
       strcat(legend_color_string, 'smoothed FPS'), ...
       strcat(legend_color_string, '60 FPS'), ...
       strcat(legend_color_string, '0 FPS'))

% axis setup
ax = gca;
c = ax.XAxis.Color;
ax.XAxis.Color = [165/255 202/255 228/255];         % X axis color
ax.YAxis(1).Color = [165/255 202/255 228/255];      % Y axis color
ax.XAxis.Limits = [min(timestamps), endyear];       % X axis limits
ax.YAxis(1).Limits = [min_delta max_delta];         % Y axis limits

% title setup
title_string = strcat(observing, ...
                      ' performance @ speed', {' '}, ...
                      speed, {' '}, ...
                      '-', {' '}, ...
                      session, ...
                      ' -', {' '}, ...
                      crisis);
title(title_string, 'Color', [165/255 202/255 228/255])

% axis labels setup
xlabel('years')
ylabel('milliseconds')

% grid setup
grid on

set(gca,'Color',[6/255 41/255 56/255])              % grid color