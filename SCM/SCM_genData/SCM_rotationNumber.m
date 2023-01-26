function SCM_rotationNumber(i_z,simPar)

%%% Computes and saves the rotation number of the sine circle map across 
%%% natural frequencies and stimulation amplitudes for a given dithering level.
%%% The name of the output file is based on the dithering level index.

%%% 26-01-23    first commit

aVect               = linspace(simPar.a_min,simPar.a_max,simPar.n_a);
Tratio              = linspace(simPar.f0_min/simPar.f_stim,simPar.f0_max/simPar.f_stim,simPar.n_f0);
fs                  = simPar.f_stim;
n_tr                = simPar.n_tr;
N                   = simPar.N;
zetaVect            = linspace(simPar.zeta_min,simPar.zeta_max,simPar.n_zeta);%0:0.01:0.3;

Ts = 1/fs;
T0Vect = Ts./Tratio;
n_a = length(aVect);
n_T = length(T0Vect);

zeta = zetaVect(i_z);

parfor i_tr = 1:n_tr
    
    %to ensure a different seed on each core
    pause(10*rand)
    rng(sum(100*clock)+333*feature('getpid'));
    
    for i_a = 1:n_a
        a = aVect(i_a);
        for i_T = 1:n_T
            T0 = T0Vect(i_T);
            theta0 = uniRand(0,2*pi);
            theta = SCM_fwdSim(Ts,T0,a,zeta,theta0,N);
            w_(i_a,i_T,i_tr) = (theta(end) - theta0)/(2*pi*N);
        end
    end
end

w_i_z = mean(w_,3);
clear w_

%%% saving workspace
mkdir(simPar.fpath)
save([simPar.fpath filesep num2str(i_z)],'-v7.3')

end