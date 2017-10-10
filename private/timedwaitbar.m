function hout = timedwaitbar(x,txt)
% A waitbar with ETA, Estimated Time of Arrival...
%
% Usage: h=timedwaitbar(fraction_complete,textlabel)
%
% Fraction: is a number between 0 and 1. a value of 1 means completed and closes the window.
% h: window handle.
%
% some nice features:
% * Estimates how much time before completion.
% * Automatically open and close the waitbar window.
%     - It closes the window when fraction reaches 1
% * You can abort the program by closing the progressbar
%
% example use:
%
% for ii=1:1000
%   timedwaitbar(ii/1000)
%   q=isprime(ii+1000:10000);
% end
%
%
% Aslak Grinsted 2011-2016


%---------------------------------------------------
persistent startx startt prevx hwait lastupdate hprogress htxt 

t=now;

if (x>=1)||isempty(prevx)||(prevx>=x)
    %CLOSE AND RESTART
    hwait=findobj(0,'Tag','AGProgress'); 
    close(hwait);   
    startx=[];lastupdate=t-1;startt=[];hwait=[];prevx=[];
    if x>=1 %completed.
        drawnow;
        return;
    end;
end

prevx=x;

if (t-lastupdate)<(1/15)/(24*60*60) 
    return
end

if isempty(hwait) 
    hwait=figure('name','progressbar','NumberTitle','off','units','normalized','position',[.4 .4 .2 .05], ...
            'CreateFcn','', 'IntegerHandle','off', 'MenuBar', 'none', 'Interruptible', 'off', ...
            'DockControls', 'off','Tag','AGProgress','BusyAction', 'queue', 'WindowStyle', 'normal','color',[1 1 1]*.2); 
    hprogress=annotation(hwait,'textbox',[0 0 x .25],'color',[1 1 1],'String',sprintf('%.0f%%',x*100), ...
        'horizontalalignment','left','verticalalignment','middle','edgecolor','none','backgroundcolor',[.7 0 0],'fontunits','normalized','fontsize',.25);
    htxt=annotation(hwait,'textbox',[0 .25 1 .75],'color',[1 1 1]*.9,'String','', ...
        'horizontalalignment','center','verticalalignment','middle','edgecolor','none','backgroundcolor','none');
    drawnow;
    t=now; %Don't time window creation.
else
    if ~ishandle(hprogress) %if progress windows is closed
        hwait=[];
        error('Timedwaitbar:ProgressWindowClosed','-------------- Execution interrupted! --------------')
    end
    set(hprogress,'Position',[0 0 x .25]);
    set(hprogress,'String',sprintf('%.0f%%',x*100));
end
if nargin>1
    set(htxt,'String',txt);
end


if isempty(startx)
    %first run....
    startt=t; startx=x;
else    
    dt=t-startt; dx=x-startx;
    eta=(dt./dx).*(1-x); 
    w=exp(-dx/.2); %e-folding dx for time updating... (used to smooth the ETA estimate)
    startx=x*(1-w)+startx*w;
    startt=t*(1-w)+startt*w;    
    set(hwait,'name',['ETA: ' datestr(eta,13)]);
end
drawnow

lastupdate=t;

if nargout>0
    hout=hwait;
end






