function SCM_wrapper(fpath,J,n_tasks_per_node,zeta_min,zeta_max,n_zeta,a_max,n_a,f0_min,f0_max,n_f0,f_stim,n_tr,N)

%%% Wrapper for computing the rotation number in the sine circle map with
%%% and without dithering. Designed to be used on a supercomputer - build
%%% using "make.txt", and see example batch file for slurm "1.sh". The code can
%%% be tested locally using "testCall.m".


%%% 26-01-23    first commit

%%% fpath                   %output folder
%%% J                       %task index
%%% n_tasks_per_node        %number of tasks per node
%%% zeta_min                %minimum dithering value
%%% zeta_max                %maximum dithering value
%%% n_zeta                  %number of dithering values to consider between min and max (linearly spaced)
%%% a_max                   %maximum stimulation amplitude value
%%% n_a                     %number of stimulation amplitude values to consider
%%% f0_min                  %minimum natural frequency value
%%% f0_max                  %maximum natural frequency value
%%% n_f0                    %number of natural frequency values to consider
%%% f_stim                  %stimulation frequency
%%% n_tr                    %number of trials to average over for a given value of natural frequency, stimulation amplitude, and dithering
%%% N                       %number of stimulation pulses in a given trial



if isdeployed
    J = str2double(J);
    n_tasks_per_node = str2double(n_tasks_per_node);
    zeta_min = str2double(zeta_min);
    zeta_max = str2double(zeta_max);
    n_zeta = str2double(n_zeta);
    a_max = str2double(a_max);
    n_a = str2double(n_a);
    f0_min = str2double(f0_min);
    f0_max = str2double(f0_max);
    n_f0 = str2double(n_f0);
    f_stim = str2double(f_stim);
    n_tr = str2double(n_tr);
    N = str2double(N);
end

i_z = floor(J/n_tasks_per_node) + 1;

simPar.fpath = fpath;
simPar.f_stim = f_stim;
simPar.n_tr = n_tr;
simPar.N = N;
simPar.a_min = 0;
simPar.a_max = a_max;
simPar.n_a = n_a;
simPar.f0_min = f0_min;
simPar.f0_max = f0_max;
simPar.n_f0 = n_f0;
simPar.zeta_min = zeta_min;
simPar.zeta_max = zeta_max;
simPar.n_zeta = n_zeta;

SCM_rotationNumber(i_z,simPar);

if isdeployed
    exit
end

end
