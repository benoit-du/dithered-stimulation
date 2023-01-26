function KM_wrapper(fpath,k,delta_f_0,xi,a_max,n_a,f0_min,f0_max,n_f0,...
    zeta,PRCfName,N,n_tr,n_pulses,dt,f_stim,freqSet,n_same,rndCycling)

%%% Wrapper for computing the rotation number, mean instantaneous frequency, and PLV
%%% in the Kuramoto model with and without dithering/frequency toggling.
%%% Designed to be used on a supercomputer - build using "make.txt", and see 
%%% example batch file for slurm "1.sh". The code can be tested locally using "testCall.m".

%%% 26-01-23    first commit

%%% fpath       %path to save output
%%% k           %coupling strength
%%% delta_f_0   %width of the Lorentzian distribution of natural frequencies
%%% xi          %model noie standard deviation
%%% a_max       %maximum stimulation amplitude value
%%% n_a         %number of stimulation amplitude values to consider
%%% f0_min      %minimum natural frequency value
%%% f0_max      %maximum natural frequency value
%%% n_f0        %number of natural frequency values to consider
%%% zeta        %dithering level
%%% PRCfName    %name of the PRC file
%%% N           %number of oscillators
%%% n_tr        %number of trials to average over for a given value of natural frequency, stimulation amplitude, and dithering
%%% n_pulses    %number of stimulation pulses in a given trial
%%% dt          %integration time step
%%% f_stim      %stimulation frequency
%%% freqSet     %set of frequencies to toggle from (leave as "[]" for dithering) - see use cases in KM_wrapper.m    
%%% n_same      %number of consecutive stimulation periods at the same stimulation frequency (only works for toggling) - see use cases in KM_wrapper.m
%%% rndCycling  %set to true for random cycling in the toggling approach (only works for toggling) - see use cases in KM_wrapper.m  

%%% Below are various use cases to clarify the dithering/toggling inputs

%%% no dithering
% n_same = [];
% freqSet = give the stimulation frequency value, e.g. 130;
% zeta_freq = 0;
% rndCycling = [];

%%%% dithering with random periods, normally distributed around a central value
% n_same = [];
% freqSet = give the central stimulation frequency value, e.g. 130;
% zeta_freq = give the dithering level, e.g. 0.15;
% rndCycling = [];

%%%% toggling: deterministic cycling from a finite set of freqs, with n_same repeats 
% n_same = give an integer;
% freqSet = list frequencies in a vector within a string, e.g. "[120 130 141.8]"
% zeta_freq = 0;
% rndCycling = false;

%%%% toggling: randomly cycling from a finite set of freqs
% n_same = 1;
% freqSet = list frequencies in a vector within a string, e.g. "[120 130 141.8]"
% zeta_freq = 0;
% rndCycling = true;


freqSet = str2num(freqSet);
if isdeployed
    k = str2double(k);
    delta_f_0 = str2double(delta_f_0);
    a_max = str2double(a_max);
    n_a = str2double(n_a);
    f0_min = str2double(f0_min);
    f0_max = str2double(f0_max);
    n_f0 = str2double(n_f0);
    zeta = str2num(zeta);
    N = str2double(N);
    n_tr = str2double(n_tr);
    n_pulses = str2double(n_pulses);
    xi = str2double(xi);
    dt = str2double(dt);
    f_stim = str2double(f_stim);
    n_same = str2double(n_same);
    rndCycling = strcmp(rndCycling,'true');
end

modPar.Delta_f_0 = delta_f_0;
modPar.k = k;
modPar.theta_0_mean = pi/2;
modPar.theta_0_std = pi/3;
modPar.xi = xi;
modPar.PRCfName = PRCfName;
modPar.f_stim = f_stim;

simPar.N = N;
simPar.dt = dt;
simPar.n_tr = n_tr;
simPar.nTransPeriodf0 = 1;
simPar.n_pulses = n_pulses;

simPar.a_min = 0;
simPar.a_max = a_max;
simPar.n_a = n_a;
simPar.f0_min = f0_min;
simPar.f0_max = f0_max;
simPar.n_f0 = n_f0;

simPar.freqSet = freqSet;
simPar.n_same = n_same;
simPar.rndCycling = rndCycling;

n_zf = length(zeta);

for i_zf = 1:n_zf
    simPar.zeta_freq = zeta(i_zf);
    KM_rotationNumber(fpath,simPar,modPar)
end
   
if isdeployed
    exit
end

end
