%% Why is something missing from my figures on screen or when I try to save them?
% This is usually caused by an incompatibility bug between Matlab and your
% graphics driver? There is unfortunately not any single method to resolve
% this issue, since it depends on your system. However, the problems can in
% some cases be resolved by changing the renderer property on the figure.
% In some cases it is caused by the shaded rendering of the COI. Here are
% some options you may try:

t=(1:100)';
X=[t,cos(t.*(1+sin(t/2)*2))];
Y=[t,cos(t.*(.7+sin(t/4)*7))];
xwt(X,Y)

set(gcf,'renderer','painters');
set(gcf,'renderer','zbuffer');
set(gcf,'renderer','opengl');
set(findobj(gca,'type','patch'),'alphadatamap','none','facealpha',1)

%%
% *Further reading on how to resolve this issue:*
% http://www.mathworks.com/access/helpdesk/help/techdoc/index.html?/access/helpdesk/help/techdoc/ref/opengl.html
% http://www.mathworks.com/support/solutions/data/28724.shtml
% http://www.mathworks.com/access/helpdesk/help/techdoc/ref/figure_props.html

