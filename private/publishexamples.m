%%publish examples.
%
% This code publishes the examples to the html folder.
%
function publishexamples


font='Rockwell';
set(0,'defaultUicontrolFontName',font);
set(0,'defaultUitableFontName',font);
set(0,'defaultAxesFontName',font);
set(0,'defaultTextFontName',font);
set(0,'defaultUipanelFontName',font);
set(0,'defaultFigureColor',[1 1 1]);
set(0,'defaultAxesColor',[1 1 1]*.97);
set(0,'defaultaxesxcolor',[1 1 1]*.4);
set(0,'defaultaxesycolor',[1 1 1]*.4);
set(0, 'defaulttextcolor',[1 1 1]*.4);
set(0,'defaultaxesbox','off');
set(0,'defaultlegendbox','off');
set(0,'defaultaxestickdir','out','defaultAxesTickDirMode', 'manual');
set(0,'defaultfigureinverthardcopy','off');
set(0,'defaultfigurecolormap', hslcolormap('yr',[0 .7 .9],[.98 .2]));

% reset random number generator...
s = RandStream('mt19937ar','Seed',0);
RandStream.setGlobalStream(s);
addpath ..


% publishfile('..\ex_linefit','html')
% publishfile('..\ex_rosenbrockbanana','html')
% publishfile('..\ex_behappy','html')
% publishfile('..\ex_breakfit','html')

% publishfile('..\ex_linefit','markdown')
% publishfile('..\ex_rosenbrockbanana','markdown')
% publishfile('..\ex_behappy','markdown')
publishfile('..\demos\faq','markdown')




function publishfile(fname,outputformat)

options=[];
options.format= 'html'; % 'html' | 'doc' | 'pdf' | 'ppt' | 'xml' | 'latex'
%options.stylesheet= 'C:\Users\Aslak\Documents\MATLAB\gwmcmc\repoexclude\robotoslab.xsl'; % '' | an XSL filename (ignored when format = 'doc', 'pdf', or 'ppt')
options.outputDir= '..\docs';
options.imageFormat= 'png'; % '' (default based on format)  'bmp' | 'eps' | 'epsc' | 'jpeg' | 'meta' | 'png' | 'ps' | 'psc' | 'tiff'
options.figureSnapMethod= 'print';  % 'entireGUIWindow'| 'print' | 'getframe' | 'entireFigureWindow'
options.useNewFigure= true; % true | false
options.showCode= true; % true | false
options.evalCode= true; % true | false
options.catchError= true; % true | false
options.createThumbnail= false;  % true | false
options.maxOutputLines= inf; % Inf | non-negative integer

switch outputformat
    case 'markdown',markdown=true;
    otherwise, markdown=false;
end

if markdown
    privatepath=fileparts(mfilename('fullpath'));
    options.stylesheet= fullfile(privatepath,'mxdom2md.xsl');
    options.format= 'latex';
end

[examplepath,name]=fileparts(fname);
oldpath=pwd;
try
    cd(examplepath)
    publish(name,options);
    if markdown
        target=fullfile(options.outputDir,name);
        movefile([target '.tex'],[target '.md']);
    end
catch ME
    cd(oldpath)
    rethrow(ME)
end
cd(oldpath)
