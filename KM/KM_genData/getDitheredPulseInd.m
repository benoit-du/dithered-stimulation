function pulse_ind = getDitheredPulseInd(zeta_freq,f_stim,n,n_stim,dt,n_phi,freqSet,n_same,rndCycling)

%%% 11-02-21    adding toggling options
%%% 29-11-21    removing negative i_p's
%%% 28-06-21    first revision
%%% might not be exact

i = 1;
i_p = i;
if isempty(freqSet)
    while i <= n
        if zeta_freq == 0
            i = i + n_stim;
        else
            i = i + round((1+normrnd(0,zeta_freq))/f_stim/dt);
        end
        i_p = [i_p,i];
    end
else 
    T_set = 1./freqSet;
    idx_T_set = round(T_set/dt);
    n_T_set = length(T_set);
    
    i_same = 0;
    i_set = 1;
    if rndCycling
        Di = idx_T_set(randi(n_T_set));
    else
        Di = idx_T_set(1);
    end
    
    while i <= n
        if i_same >= n_same
            i_set = i_set + 1;
            if rndCycling
                Di = idx_T_set(randi(n_T_set));
            else
                Di = idx_T_set(mod(i_set-1,n_T_set)+1);
            end
            i_same = 0;
        end
        i = i + Di;
        i_same = i_same + 1;
        i_p = [i_p,i];
    end
end

i_p(i_p>n) = [];
i_p(i_p<=0) = [];

i_p_ext = NaN(1,n);
d_p_ext = NaN(1,n);
for ind_p = 1:length(i_p)-1
    i_p_ext(i_p(ind_p):i_p(ind_p+1)) = i_p(ind_p);
    d_p_ext(i_p(ind_p):i_p(ind_p+1)) = i_p(ind_p+1)-i_p(ind_p);
end
i_p_ext(i_p(end):end) = i_p(end);
d_p_ext(i_p(end):end) = n - i_p(end);

pulse_ind = floor(((1:n)-i_p_ext)./d_p_ext*n_phi)+1;
pulse_ind(pulse_ind == n_phi+1) = 1;

end