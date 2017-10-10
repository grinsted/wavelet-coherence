%%publish examples.
%
% This code publishes the examples to the html folder.
%
function publishexamples

close all

thispath=fileparts(mfilename('fullpath'));

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

publishfile('..\wtcdemo','markdown',[thispath '\_demo'],'demo')
return
d=dir(fullfile(thispath,'..\faq\*.m'))

for ii=1:length(d)
    publishfile(fullfile('..\faq\',strrep(d(ii).name,'.m','')),'markdown',[thispath '\_faq'],'faq')
end




function publishfile(fname,outputformat,targetfolder,category)
disp(fname); drawnow
close all

thispath=fileparts(mfilename('fullpath'));

options=[];
options.format= 'html'; % 'html' | 'doc' | 'pdf' | 'ppt' | 'xml' | 'latex'
%options.stylesheet= 'C:\Users\Aslak\Documents\MATLAB\gwmcmc\repoexclude\robotoslab.xsl'; % '' | an XSL filename (ignored when format = 'doc', 'pdf', or 'ppt')
options.outputDir= targetfolder;
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
    options.stylesheet= fullfile(thispath,'mxdom2md.xsl');
    options.format= 'latex';
end

[examplepath,name]=fileparts(fname);
oldpath=pwd;
try
    cd(examplepath)
    publish(name,options);
    if markdown
        target=fullfile(options.outputDir,name);
        newfilename=[target '.md'];
        movefile([target '.tex'],newfilename);
        try
            movefile(fullfile(options.outputDir,'*.png'),fullfile(options.outputDir, '..\images'),'f');
        catch
        end
        fid  = fopen(newfilename,'r');
        f=fread(fid,'*char')';
        fclose(fid);
        f = regexprep(f,'\(([\w\d_-]+\.png)\)','(images/$1)');
        f = strrep(f,'##category##',category);
        fid  = fopen(newfilename,'w');
        fprintf(fid,'%s',f);
        fclose(fid);
    end
catch ME
    cd(oldpath)
    rethrow(ME)
end
cd(oldpath)



