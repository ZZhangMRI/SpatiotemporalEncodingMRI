function figh = stackedplot(z,style,spacing,labels,varargin)
% STACKED PLOT produces a 3D-like plot as a stacked set of spectra. 
% Syntax: figh = stackedplot(z,style,spacing,labels,varargin)
%   Stacked plots are commonly seen in NMR spectroscopy. There are several (somewhat 
%   equivalent) methods to produce such plots in Matlab. This function provides a 
%   common interface to these various methods. Certainly some methods can be evoked
%   more directly, i.e. mesh, but some others are not obivous choices, e.g. plot3.
%   The purpose of this function is to educate through sample code and to provide the
%   user additional choices. Select the method you like best.
% Arguments:
%   "z" is a two dimensional array to plot.
%       First dimension is the spectroscopic axis.
%       Second dimension has the various spectra or plots (e.g. along time).
%   "style" (optional) selects the method and style for the stacked plot.
%       "1" or "s" (default) performs a traditional stacked plot
%           This is not a 3D plot. The view cannot be rotated and there is no control
%           over z tick labels.
%       "2" or "m" performs a surface mesh plot
%           This is a 3D plot and the camera view may be rotated
%       "3" or "mc" performs a surface mesh plot with mesh lines along dim 1.
%           This is a 3D plot and the camera view may be rotated
%       "4" or "p" uses plot3
%           This is a 3D plot and the camera view may be rotated
%       "5" or "i" uses imagesc
%           This simply plots the data as an image as looking from above.
%           Vertical axis is the second dimension for the data.
%   "spacing" (optional) is a positive integer specifying the spacing along dim 2.
%       e.g. 4 specifies that every fourth point is plotted (default=1).
%   "labels" controls appearance of tick labels on the axes.
%       if it is a single element then it must be one of the following:
%           {0, 'none'} - axis tick labels are removed (default).
%           {1, 'x'} - only x-axis (dim 1) tick labels are kept.
%           {2, 'y'} - only y-axis (dim 2) tick labels are kept.
%           {3, 'xy'} - only x&y-axis tick labels are kept.
%           {4, 'all'} - all axis tick labels are kept.
%       if "labels" is numeric and has more than one element [2,4,or 6] then
%           if a 2 element column vector, only x-axis tick labels are created.
%           if a 2 element row vector, only y-axis tick labels are created.
%           if a 4 element vector, then x & y tick labels are created.
%           if a 6 element vector, then x,y,&z tick labels are created.
%           Each axis "labels" has 2 elements [min, max].
%           To reverse the order of the labels specify in reverse order as [max, min].
%   "varargin" (optional) can be any number of arguments as needed that are passed along
%       to the plotting commands. Thus this depends upon the plot sytle as follows:
%       Style
%           1 - offset, numyticks, linespec
%               1st arg is offset, which is specified as a fraction of data range. 
%               This value represents the total displacement along each axis.
%               If one element then value is repeated for both axes.
%               If two elements then [xoffset,yoffset] (default = [0.1,0.8]).
%               2nd arg is number of y ticks, remember to specify y tick vector.
%               3rd arg is linespec, see Matlab help for "line" (default: 'b').
%           2 - Any property that is valid for "mesh", see Matlab help.
%           3 - Any property that is valid for "mesh", see Matlab help.
%           4 - Any property or linespec that is valid for "plot3", see Matlab help.
%           5 - clims value, see Matlab help on "imagesc".          
%   "figh" (optional) is the figure handle.
%  Notes:
%   Function "Splot" (style 1) can be extracted as a standalone function.
%   Plots are made on the current figure, if no figure exists then one is created.
%   If the axis labels are not in the correct direction try:
%       set(gca,'XDir','normal') or set(gca,'XDir','reverse')
%   'XDir' may be substituted with 'YDir' or 'ZDir' for the corresponding axis.

%   Copyright 2009-2012 Mirtech, Inc.
%   created 05/30/2009  MIH
%   modified 05/19/2012 MIH, changed how tick labels are specified

def_linespec    = 'b';
def_style       = 1;
def_spacing     = 1;
def_labels      = 0;
switch nargin
    case 0
        error ('  Need a two dimensional array as input!')
    case 1
        spacing = [];   style = [];     labels = [];    varargin = [];
    case 2
        style = [];     labels = [];    varargin = [];
    case 3
        labels = [];    varargin = [];
    case 4
        varargin = [];
    otherwise
        % do nothing
end
if isempty(spacing),    spacing = def_spacing;      end
if isempty(style),      style   = def_style;        end
if isempty(labels),     labels  = def_labels;       end

z = z(:,1:spacing:end);     % reduce data to only use displayed elements
zdim = size(z);
xvec = 1:zdim(1);
yvec = 1:zdim(2);
zlimits = [min(z(:)),max(z(:))];
% check "labels" specification
if ischar(labels)||numel(labels)==1,
    % check single element control of labels
    switch labels,
        case {0, 'none', 'NONE'}
            xflag = false;
            yflag = false;
            zflag = false;
        case {1, 'x', 'X'}
            xflag = true;
            yflag = false;
            zflag = false;
        case {2, 'y', 'Y'}
            xflag = false;
            yflag = true;
            zflag = false;
        case {3, 'xy', 'XY'}
            xflag = true;
            yflag = true;
            zflag = false;
        case {4, 'all', 'ALL'}
            xflag = true;
            yflag = true;
            zflag = true;
        otherwise
            error ('  Labels argument is not recognized!')
    end
else
    % check multi-element "label" specification
    switch numel(labels)
        case 2
            if size(labels,2)==1,       % is true if column vector specifying x-ticks.
                xflag = true;
                yflag = false;
                zflag = false;
                xvec = calcticks(zdim(1),labels);
            else
                yflag = true;
                xflag = false;
                zflag = false;
                yvec = calcticks(zdim(2),labels);
            end
        case {4,6}
            xflag = true;
            yflag = true;
            xvec = calcticks(zdim(1),labels(1:2));
            yvec = calcticks(zdim(2),labels(3:4));
            if numel(labels)==4,
                zflag = false;
            else
                zflag = true;
                zlimits = labels(5:6); 
            end
        otherwise
            error ('  Labels argument is not recognized!')
    end
end
% Execute one of the plot styles   
switch style
    case {1,'p','P'}            % do traditional stacked plot
        switch numel(varargin),
            case 0
                f = splot(xvec,yvec,z);
            case {1,2,3}
                f = splot(xvec,yvec,z,varargin{:});
            otherwise
                error('  Input arguments not appropriate for syle 1!')
        end
    case {2,'m','M'}            % do 3D surface mesh plot
        [x,y] = ndgrid(xvec,yvec);
        if isempty(varargin),
            f = mesh(y,x,z);
        else
            f = mesh(y,x,z,varargin{:});
        end   
        axis ij                 % keep x-axis orientation the same as expected
        tmpflag = xflag;        % swap flags as surface plots axes are different
        xflag = yflag;
        yflag = tmpflag;
        axis([min(yvec(1),yvec(end)),max(yvec(1),yvec(end)),...
            min(xvec(1),xvec(end)),max(xvec(1),xvec(end)),...
            min(zlimits),max(zlimits)]);
    case {3, 'mc', 'MC'}        % do 3D surface plot with lines along columns
        [x,y] = ndgrid(xvec,yvec);
        if isempty(varargin),
            f = mesh(y,x,z,'meshstyle','column');
        else
            f = mesh(y,x,z,'meshstyle','column',varargin{:});
        end  
        axis ij                 % keep x-axis orientation the same as expected
        tmpflag = xflag;        % swap flags as surface plots axes are different
        xflag = yflag;
        yflag = tmpflag;
        axis([min(yvec(1),yvec(end)),max(yvec(1),yvec(end)),...
            min(xvec(1),xvec(end)),max(xvec(1),xvec(end)),...
            min(zlimits),max(zlimits)]);
    case {4, 'p3', 'P3'}        % do 3D line plot
        [x,y] = ndgrid(xvec,yvec);
        if isempty(varargin),
            f = plot3(y,x,z,def_linespec);
        else
            f = plot3(y,x,z,varargin{:});
        end  
        grid on
        axis ij
        tmpflag = xflag;        % swap flags as surface plots axes are different
        xflag = yflag;
        yflag = tmpflag;
        axis([min(yvec(1),yvec(end)),max(yvec(1),yvec(end)),...
            min(xvec(1),xvec(end)),max(xvec(1),xvec(end)),...
            min(zlimits),max(zlimits)]);
    case {5, 'i', 'I'}          % do image
        if isempty(varargin),
            f = imagesc(xvec,yvec,z');
        else
            f = imagesc(xvec,yvec,z',varargin{:});
        end  
        axis xy
    otherwise
        error ('  Style argument is not recognized!')
end
% Apply axis label controls to any plot
if xvec(1)>xvec(end),       set(gca,'XDir','reverse');      end
if yvec(1)>yvec(end),       set(gca,'YDir','reverse');      end
if zlimits(1)>zlimits(end), set(gca,'ZDir','reverse');      end
if ~xflag,  set(gca,'XTickLabel',[]),       end
if ~yflag,  set(gca,'YTickLabel',[]),       end
if ~zflag,  set(gca,'ZTickLabel',[]),       end
   
if nargout==1,
    figh = f;
end

function fh = splot(x,y,z,offset,numyticks,linespec)
% Function performs traditional stacked plot
%   x is x-axis vector
%   y is y-axis vector
%   z, 2D data array with x along columns and y along rows.
%   offset, 1 or 2 element vector specifying total offset along x & y directions.
%       Value represents fraction of axis range that is devoted for incrementing
%       along the axis. 
%       The default x and y increment is determined by dividing the total 
%       value by the number of plots. 
%   linespec, a string constant setting the line property, see Matlab help on "plot".
%   numyticks, number of y ticks.
%   Copyright 2009-2012  Mirtech, Inc.
%   Modified 05/23/2012 so that x and y do not have to be monotonically increasing

def_yticks = 4;             % default number of y ticks
def_linespec = 'b';
def_offset = [0.1,0.8];
switch nargin,
    case 6
    case 5
        linespec = [];
    case 4
        numyticks = [];     linespec = [];
    case 3
        offset = [];        numyticks = [];     linespec = [];      
end
if isempty(numyticks),  numyticks = def_yticks;     end
if isempty(linespec),   linespec = def_linespec;    end
if isempty(offset),     offset = def_offset;        end
if numel(offset)==1,
    offset(2) = offset(1);
end
xpts = size(z,1);
if numel(x)~=xpts,  error('  X vector does not match 2D array!'),   end
ypts = size(z,2);
if numel(y)~=ypts,  error('  Y vector does not match 2D array!'),   end
zrange = max(z(:));
delta_y = offset(2)*zrange/(ypts-1);
incx = x(2)-x(1);               % calc increment from difference of adj. pts.
delta_x = floor(offset(1)*xpts/(ypts-1));   % calc x offset in pts.
xall = x(1) + ((1:(xpts+delta_x*(ypts-1)))-1)*incx;
yplt = zeros(size(xall));
yplt(fix(xpts/2)) = zrange*(1+offset(2));
fh = plot(xall,yplt,'w');       % setup length and height of plot with a white plot
set(gca,'YAxisLocation','right')
xlim([min(xall(1),xall(end)),max(xall(1),xall(end))]);
hold on
ylast = z(:,1)';
plot(x,ylast,linespec)          % plot first column
ytickvec = zeros(1,ypts);       % setup y ticks location holder
ytickvec(1) = ylast(end);       % save first y tick location
for n = 2:ypts,
    yplt = z(:,n)' + delta_y*(n-1);             % add y offset to selected column
    ytickvec(n) = yplt(end);                    % save y tick location
    ylast(1:delta_x) = 0;                       % set offsetted points along x to zero
    ylast = circshift(ylast,[0,-delta_x]);      % move those points to end
    ylast = max(yplt,ylast);                    % create new ylast
    plot(x+delta_x*(n-1)*incx,ylast,linespec)   % plot ylast
end
hold off
xtickvec = get(gca,'XTick');
if x(1)<x(end),
    xtickvec(xtickvec>x(end)) = [];
else
    xtickvec(xtickvec<x(end)) = [];
end
set(gca,'XTick',xtickvec)       % setup x ticks for only the first plot
ytickspacing = floor(ypts/(numyticks-1));
yspacing = (y(2) - y(1));
yptvec = 1:ytickspacing:ypts;
if numel(yptvec) < numyticks,
    yptvec = [yptvec,ypts];
else
    yptvec(end) = ypts; 
end
set(gca,'YTick',ytickvec(yptvec))       % setup y ticks
yvec = y(1) + (yptvec - 1)*yspacing;
sclfac = floor(max(log10(abs(yvec))));  % find the largest power of ten
if sclfac<0,
    dec = floor(abs(sclfac));
    field = dec + 2;
else
    field = floor(abs(sclfac));
    dec = [];
end
% setup y tick labels
set(gca,'YTickLabel',cellstr(num2str(yvec',...
    ['%',num2str(field),'.',num2str(dec),'f']))) 
% ------------- splot end --------------  

function [ticklbl,tickpts] = calcticks(npts,tickvector)
% calculates location of ticks and labels
% tickvector is a 2 element vector [min,max] or a 
%   3 element vector [min,max,#ticks]
%   if 2 then #ticks = npts
tmin = min(tickvector);
tmax = max(tickvector);
if numel(tickvector)==3,
    nticks = tickvector(3);
else
    nticks = npts+1;
end
tickspacing = npts/(nticks-1);
tickpts = 1:tickspacing:npts;
ticklbl = tmin:(tmax-tmin)*tickspacing/(npts-1):tmax;
if tmin==tickvector(2),
    ticklbl = ticklbl(end:-1:1);
    tickpts = tickpts(end:-1:1);
end
% ------------- calcticks end --------------
    
