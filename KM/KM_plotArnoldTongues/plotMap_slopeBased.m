function plotMap_slopeBased(w,f0Vect,aVect,fpath,withMask,clab,xlims,ylims,clims,...
    adjustFt,tol_w,tol_dw,spanFact,method)

%%% 26-01-23    first commit

figure
if strcmp(clab,'mean instantaneous frequency (Hz)')
    colormap(inferno(256))
elseif strcmp(clab,'PLV 1:1') ||  strcmp(clab,'PLV 1:2') ||  strcmp(clab,'PLV 1:2 - PLV 1:1')
    colormap(inferno(256))
else
    colormap(jet(256))
end

if ~withMask
    imagesc([f0Vect(1) f0Vect(end)],[aVect(1) aVect(end)],w)
else
    df = f0Vect(2) - f0Vect(1); 
    mask = tongueMask_slopeBased(w,1,1,tol_w,tol_dw,df,spanFact,method) + ...
        tongueMask_slopeBased(w,1,2,tol_w,tol_dw,df,spanFact,method) + ...
        tongueMask_slopeBased(w,2,3,tol_w,tol_dw,df,spanFact,method);
    mask = mask + tongueMask_slopeBased(w,3,2,tol_w,tol_dw,df,spanFact,method) + tongueMask_slopeBased(w,2,1,tol_w,tol_dw,df,spanFact,method) + ...
        tongueMask_slopeBased(w,4,3,tol_w,tol_dw,df,spanFact,method);
    
    imagesc([f0Vect(1) f0Vect(end)],[aVect(1) aVect(end)],w,'alphadata',mask)
end

set(gca,'YDir','normal')
c = colorbar;
ylabel(c,clab,'interpreter','latex');
set(c,'fontsize',15)
xlabel('natural frequency (Hz)','Interpreter','LaTeX')
ylabel('stim. amplitude (a.u.)','Interpreter','LaTeX')
set(gcf,'color','w')

if ~isempty(clims)
    caxis(clims)
end
if ~isempty(ylims)
    ylim(ylims)
end
if ~isempty(xlims)
    xlim(xlims)
end
if adjustFt
    ft = 13;
    set(gca,'fontsize',ft)
end

pause(1)
mySaveasFlex('dimXY',[13.5 9],'fNameNoNowStr',[fpath filesep 'out']);
close

end

