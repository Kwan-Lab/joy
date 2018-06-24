clear all;
close all;

load('data.mat');

%make movie using frame 100 to 1000
plot_joy(dat, [100 1000]);