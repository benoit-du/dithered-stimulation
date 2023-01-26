function theta = SCM_fwdSim(Ts,T0,a,zeta,theta0,N)

%%% 26-01-23    first commit

%%% iterative simulation of the sine circle map with
%%% zeta = dithering level
%%% Ts = average stimulation period
%%% T0 = period corresponding to the natural frequency
%%% a = stimulation amplitude
%%% N = number of stimulation pulses to iterate the map for

theta = NaN(N,1);
theta(1) = theta0;

if zeta == 0
    randVect = zeros(N-1,1);
else
    randVect = normrnd(0,zeta,N-1,1);
end

for i = 1:N-1 
    theta(i+1) = theta(i) + 2*pi*Ts*(1+randVect(i))/T0 + a*sin(theta(i));
end

end