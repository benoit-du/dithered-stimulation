%%% To plot Arnold tongues, mean instantaneous frequency, and PLV of the 
%%% Kuramoto model (potentially with dithering) based on data generated 
%%% using code in the folder KM_genData

%%% 26-01-23    first commit

close all
clearvars

fpath_read = ['..' filesep 'KM_genData' filesep 'test' filesep 'workspace']; %path to the data
tol_w = 3E-2;       %tolerance on rotation number for Arnold tongues (see Methods section of the paper for more details)
tol_dw = 2E-2;      %tolerance on the smoothed partial derivative of the rotation number with respect to natural frequency (used for Arnold tongues, see Methods section of the paper for more details)
method = 'lowess';  %smoothing method(used for Arnold tongues, see Methods section of the paper for more details)
newClims = [0 2];   %color limits for winding number plots (leave empty for auto)
xlims = [30 350];   %frequency limits for plots (leave empty for auto)
ylims = [];         %stim amplitude limits for plots (leave empty for auto)
plotInBkgd = true;  %plot in background

if plotInBkgd
    set(0, 'DefaultFigureVisible', 'off');
else
    set(0, 'DefaultFigureVisible', 'on');
end

load(fpath_read)
outpath = 'Fig';
mkdir(outpath)

spanFact = 4/length(f0Vect);

plotMap_slopeBased(Avg_wPsi,f0Vect,aVect,outpath,false,'rotation number',xlims,ylims,newClims,true,tol_w,tol_dw,spanFact,method)
plotMap_slopeBased(Avg_wPsi,f0Vect,aVect,outpath,true,'rotation number',xlims,ylims,newClims,true,tol_w,tol_dw,spanFact,method)

plotMap_slopeBased(mean(mean_instfreq_psi,3),f0Vect,aVect,outpath,false,'mean instantaneous frequency (Hz)',xlims,ylims,[30 350],true)

plotMap_slopeBased(mean(PLV_11,3),f0Vect,aVect,outpath,false,'PLV 1:1',xlims,ylims,[0 1],true)
plotMap_slopeBased(mean(PLV_12,3),f0Vect,aVect,outpath,false,'PLV 1:2',xlims,ylims,[0 1],true)
plotMap_slopeBased(mean(PLV_12-PLV_11,3),f0Vect,aVect,outpath,false,'PLV 1:2 - PLV 1:1',xlims,ylims,[0 1],true)


