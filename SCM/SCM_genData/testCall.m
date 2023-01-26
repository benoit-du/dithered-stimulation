%%% Although the code should be run on a supercomputer to get Arnold tongues with a 
%%% good resolution, this is a test call that can be used on a local machine.
%%% The predefined parameters below will generate the data for a dithering level
%%% zeta = 0.047

%%% 26-01-23    first commit

clearvars
close all

fpath                   = 'test';   %output folder
J                       = 1;        %task index
n_tasks_per_node        = 16;       %number of tasks per node
zeta_min                = 0.047;    %minimum dithering value
zeta_max                = 0.047;    %maximum dithering value
n_zeta                  = 1;        %number of dithering values to consider between min and max (linearly spaced)
a_max                   = 2;        %maximum stimulation amplitude value
n_a                     = 300;      %number of stimulation amplitude values to consider
f0_min                  = 1;        %minimum natural frequency value
f0_max                  = 300;      %maximum natural frequency value
n_f0                    = 200;      %number of natural frequency values to consider
f_stim                  = 130;      %stimulation frequency
n_tr                    = 10;       %number of trials to average over for a given value of natural frequency, stimulation amplitude, and dithering
N                       = 1E4;      %number of stimulation pulses in a given trial


tic
SCM_wrapper(fpath,J,n_tasks_per_node,zeta_min,zeta_max,n_zeta,a_max,n_a,f0_min,f0_max,n_f0,f_stim,n_tr,N)
toc
% ~ 2min