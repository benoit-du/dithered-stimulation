%%% To plot Arnold tongues of the sine circle map (potentially with
%%% dithering) based on data generated using code in the folder SCM_genData

%%% 26-01-23    first commit

close all
clearvars

dataDirToLoad           = ['..' filesep 'SCM_genData' filesep 'test']; %directory with data to load
alphaOutsideTongues     = 0; %alpha value for imagesc outside tongues            
clims                   = [0 2]; %limits of the color bar corresponding to the rotation number
tol_w                   = 0.0006; %tolerance on rotation number for Arnold tongues (see Methods section of the paper for more details)
tol_dw                  = 0.01; %tolerance on the smoothed partial derivative of the rotation number with respect to natural frequency (used for Arnold tongues, see Methods section of the paper for more details)
method                  = 'lowess'; %smoothing method(used for Arnold tongues, see Methods section of the paper for more details)

%%% loading data
[names,n_f] = getFilesInDir(dataDirToLoad);
for i_f = 1:n_f
    temp = load([dataDirToLoad filesep names{i_f}]);
    i_z = temp.i_z;
    w{i_z} = temp.w_i_z;
end
 
zetaVect = temp.zetaVect;
n_z = length(zetaVect);
T0Vect = temp.T0Vect;
Tratio = temp.Tratio;
n_T = temp.n_T;
Ts = temp.Ts;
aVect = temp.aVect;
n_a = temp.n_a;
fs = temp.fs;
n_tr = temp.n_tr;
N = temp.N;


%%% plotting tongues
Tratio_corners = [Tratio(1) Tratio(end)];
a_corners = [aVect(1) aVect(end)];
ft = 16;
figFolder = ['Figs' filesep getDateTimeStr];
mkdir(figFolder)

for i_z = 1:n_z
    zeta = zetaVect(i_z);
    titleStr = ['$\zeta$ = ' num2str(zeta,2)];
    
    f0Vect = Tratio*fs;
    f0_corners = Tratio_corners*fs;
    f0An = linspace(f0_corners(1),f0_corners(end),5E4);
    df = f0Vect(2) - f0Vect(1);
    spanFact = 4/length(f0Vect);
    
    %%% tongue masks - 0 to 1:1 family    
    mask = tongueMask_slopeBased(w{i_z},1,1,tol_w,tol_dw,df,spanFact,method) + tongueMask_slopeBased(w{i_z},1,2,tol_w,tol_dw,df,spanFact,method) + tongueMask_slopeBased(w{i_z},1,3,tol_w,tol_dw,df,spanFact,method) +...
        tongueMask_slopeBased(w{i_z},1,4,tol_w,tol_dw,df,spanFact,method) + tongueMask_slopeBased(w{i_z},1,5,tol_w,tol_dw,df,spanFact,method) + tongueMask_slopeBased(w{i_z},1,6,tol_w,tol_dw,df,spanFact,method) + tongueMask_slopeBased(w{i_z},2,3,tol_w,tol_dw,df,spanFact,method) +...
        tongueMask_slopeBased(w{i_z},3,4,tol_w,tol_dw,df,spanFact,method) + tongueMask_slopeBased(w{i_z},4,5,tol_w,tol_dw,df,spanFact,method) + tongueMask_slopeBased(w{i_z},5,6,tol_w,tol_dw,df,spanFact,method);
    
    %%% tongue masks - 1:1 to 2:1 family
    mask = mask + tongueMask_slopeBased(w{i_z},2,1,tol_w,tol_dw,df,spanFact,method) + tongueMask_slopeBased(w{i_z},7,6,tol_w,tol_dw,df,spanFact,method) + tongueMask_slopeBased(w{i_z},6,5,tol_w,tol_dw,df,spanFact,method) + tongueMask_slopeBased(w{i_z},5,4,tol_w,tol_dw,df,spanFact,method) +...
        tongueMask_slopeBased(w{i_z},4,3,tol_w,tol_dw,df,spanFact,method) + tongueMask_slopeBased(w{i_z},3,2,tol_w,tol_dw,df,spanFact,method) + tongueMask_slopeBased(w{i_z},5,3,tol_w,tol_dw,df,spanFact,method) + tongueMask_slopeBased(w{i_z},7,4,tol_w,tol_dw,df,spanFact,method) +...
        tongueMask_slopeBased(w{i_z},9,5,tol_w,tol_dw,df,spanFact,method) + tongueMask_slopeBased(w{i_z},11,6,tol_w,tol_dw,df,spanFact,method);
    
    figure
    n_colmap = 1E4;
    cmp = colormap(jet(n_colmap));
    col21 = cmp(end,:);
    col11 = cmp(round(n_colmap/2),:);
    col12 = cmp(round(n_colmap/4),:);
    col32 = cmp(round(3*n_colmap/4),:);
    mask(mask == 0) = alphaOutsideTongues;
    imagesc(10*f0_corners,a_corners,w{i_z},'alphadata',mask)
    set(gca,'YDir','normal')
    c = colorbar;
    caxis(clims);
    set(gca,'ColorScale','linear')
    ylabel(c,'rotation number','interpreter','latex');
    set(c,'fontsize',ft)
    xlabel('natural frequency (Hz)','interpreter','latex');
    ylabel({titleStr,'stim. amplitude (a.u.)'},'interpreter','latex');
    set(gca,'fontSize',ft)
    
    pause(0.8)
    mySaveasFlex('dimXY',[16 8.5],'fNameNoNowStr',[figFolder filesep 'tongues']);
    close
end



