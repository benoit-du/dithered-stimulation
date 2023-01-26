function KM_rotationNumber(fpath,simPar,modPar)

%%% 26-01-23    first commit

f_stim          = modPar.f_stim;
PRCfName        = modPar.PRCfName;
Delta_f_0       = modPar.Delta_f_0;
k               = modPar.k;
theta_0_mean    = modPar.theta_0_mean;
theta_0_std     = modPar.theta_0_std;
xi              = modPar.xi;

N               = simPar.N;
dt              = simPar.dt;
n_tr            = simPar.n_tr;
n_pulses        = simPar.n_pulses;
nTransPeriodf0  = simPar.nTransPeriodf0;
a_min           = simPar.a_min;
a_max           = simPar.a_max;
n_a             = simPar.n_a;
f0_min          = simPar.f0_min;
f0_max          = simPar.f0_max;
n_f0            = simPar.n_f0;
zeta_freq       = simPar.zeta_freq;
freqSet         = simPar.freqSet;
n_same          = simPar.n_same;
rndCycling      = simPar.rndCycling;


temp = load(['.' filesep PRCfName]);
PRC = temp.PRC;
wpsi = NaN(n_a,n_f0,n_tr);
mean_instfreq_psi = NaN(n_a,n_f0,n_tr);
PLV_11 = NaN(n_a,n_f0,n_tr);
PLV_12 = NaN(n_a,n_f0,n_tr);

mkdir(fpath)

vm_std = theta_0_std;
vm_kappa = 1/vm_std^2;

aVect = linspace(a_min,a_max,n_a);
f0Vect = linspace(f0_min,f0_max,n_f0);

n_phi = 1E3;
phi = linspace(0,2*pi,n_phi+1);
phi(end) = [];
PRC_ = getFourierSum(PRC.a0,PRC.a,PRC.b,phi);

% square pulse, long recharge
% <v^2> = 1, charge balanced
pulse_ = zeros(n_phi,1);
pctPos = 20;
nPos = floor(pctPos*n_phi/100);
theta_0_pulse = phi(nPos+1);
a_pulse = (theta_0_pulse*(1+theta_0_pulse/(2*pi-theta_0_pulse))/(2*pi))^-0.5;
pulse_(1:nPos) = a_pulse;
pulse_(nPos+1:n_phi) = -theta_0_pulse/(2*pi-theta_0_pulse)*a_pulse;

parfor i_a = 1:n_a
    stimMag = aVect(i_a);
    for i_f = 1:n_f0
        f_0 = f0Vect(i_f);
        for i_tr = 1:n_tr
            
            omega = 2*pi*f_0;
            
            n_stim = round(1/(f_stim*dt));    %number of time steps between pulses for center freq
            n_period = round(1/(f_0*dt)); %number of time steps in a period at f_0 (unforced WC peak freq)
            n_transient = nTransPeriodf0*n_period;        %number of time steps in 20 periods at f_0, to remove transient prior to stim
            n_rand = round(5*n_period*rand);   %shift to get a random initial phase (using more than one period to avoid issues with underrepresentation of late phases and overrepresentation of early phases). Should be within the trial loop
            n_noStim = n_transient + n_rand;
            n = n_pulses * n_stim + n_noStim;
            
            theta = NaN(N,n);
            theta(:,1) = wrapTo2Pi(vmrand(theta_0_mean,vm_kappa,[N 1]));
            omegas = trnd(1,[N 1])*(2*pi*Delta_f_0) + omega;
            
            stimTrig = zeros(1,n);
            a = 0;
            
            pulse_ind = getDitheredPulseInd(zeta_freq,f_stim,n,n_stim,dt,n_phi,freqSet,n_same,rndCycling);
            
            if xi > 0
                randMat = normrnd(0,1,[N,n-1]);
            else
                randMat = zeros(N,n-1);
            end
            
            first_inds = [];
            
            for i = 1:n-1
                if i>=n_noStim
                    a = stimMag;
                end
                
                theta_wrapped = theta(:,i) - 2*pi*floor(theta(:,i)/(2*pi));
                PRC_ind = floor(n_phi*theta_wrapped/(2*pi))+1;
                PRC_val = PRC_(PRC_ind);
                pulse_val = pulse_(pulse_ind(i));
                
                if pulse_ind(i) == 1 && i>=n_noStim
                    first_inds = [first_inds; i];
                end
                
                r = sum( exp(1j*theta(:,i)) )/ N;
                psi = angle(r);
                rho = abs(r);
                theta_i = theta(:,i);
                theta(:,i+1) = theta_i + ( omegas + k * rho * sin(psi - theta_i) + a*pulse_val*PRC_val ) * dt + xi * sqrt(dt) * randMat(:,i);
                stimTrig(i+1) = a*pulse_val;
            end
            
            
            r = sum(exp(1j*theta),1) / N;
            
            psi_uw = unwrap(angle(r(n_noStim:end)));
            instfreq_psi = 1/(2*pi)*diff(psi_uw)/dt;
            mean_instfreq_psi(i_a,i_f,i_tr) = mean(instfreq_psi);
            [wpsi(i_a,i_f,i_tr)] = (psi_uw(end) - psi_uw(1))/(2*pi*n_pulses);
            
            PLV_11(i_a,i_f,i_tr) = abs(sum(exp(1i*angle(r(first_inds)))))/length(first_inds);
            first_inds_12 = downsample(first_inds,2);
            PLV_12(i_a,i_f,i_tr) = abs(sum(exp(1i*angle(r(first_inds_12)))))/length(first_inds_12);
            
        end
    end
end

Avg_wPsi = mean(wpsi,3);

save([fpath filesep 'workspace'],'-v7.3')
end