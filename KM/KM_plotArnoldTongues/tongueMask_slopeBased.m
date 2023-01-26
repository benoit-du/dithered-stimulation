function out = tongueMask_slopeBased(w,p,q,tol_w,tol_dw,df,spanFact,method)

%%% mask for Arnold tongue p:q based on rotation number w
%%% (see Methods section of the paper for more details)

%%% 26-01-23    first commit

[n_a,n_f] = size(w);
w_sm = NaN(n_a,n_f);
dw_sm = NaN(n_a,n_f);
dw_sm(:,1) = zeros(n_a,1);
dw = NaN(n_a,n_f);
dw(:,1) = zeros(n_a,1);

for i_a = 1:n_a
    w_sm(i_a,:) = smooth(w(i_a,:),spanFact,method);%
    dw_sm(i_a,2:end) = diff(w_sm(i_a,:))/df;
    dw(i_a,2:end) = diff(w(i_a,:))/df;
end

out = w > p/q-tol_w & w < p/q+tol_w & abs(dw_sm) < tol_dw;


end