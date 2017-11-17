%% Visualisierung Bisektion
clear all; close all; clc
%% numerics
nx=16;ny=16;nz=16;
ni_array=(1:nx+1);nj_array=(1:ny+1);nk_array=(1:nz+1);   % müssen gerade sein

%% Kantenlängen Rechengebietdomain 
Lx=1.0; Ly=1.0;Lz=1.0;

%% initial drop size and location
V = ones(nx+1,ny+1,nz+1); % funs Feld
radi=0.15;xc=0.25;yc=0.75;zc=0.75; 

%% mesh Vgl. mit fs3d mesh3d
% dx=Lx/nx;dy=Ly/ny;dz=Lz/nz;

x = linspace (0,Lx,nx+1);
y = linspace (0,Ly,ny+1);
z = linspace (0,Lz,nz+1);

dx = x(2)-x(1);
dy = y(2)-y(1);
dz = z(2)-z(1);

% for i=1:nx
%     x(i)=dx*(i);
% end
% for j=1:ny
%     y(j)=dy*(j);
% end
% for k=1:nz
%     z(k)=dz*(k);
% end

%% set funs inside drop
% 
for k=1:nz+1
    for j=1:ny+1
        for i=1:nx+1
              if ((x(i)-xc)^2+(y(j)-yc)^2+(z(k)-zc)^2 >= (radi-dx)^2 &&  ...
                      (x(i)-xc)^2+(y(j)-yc)^2+(z(k)-zc)^2<= radi^2)
                        V(i,j,k)=10;  
              end %if
         end
    end
end

%% block parameters

dom_total     = 8;                        % Anzahl der Domains
coord_num     = 6;                          % top, bottom ... 3-D

% alloc block
block=zeros(dom_total,coord_num);

%% initialization for block 1
 % dom_num,coord_num
block(1,1)  = 1;        % x_min left 
block(1,2)  = nx;       % x_max right
block(1,3)  = 1;        % y_min bottom
block(1,4)  = ny;       % y_max top
block(1,5)  = 1;        % z_min back
block(1,6)  = nz;       % z_max front

%% bisection
dom_num = 1;                      % before first cut, only one domain exists
block = bisec(block,dom_num);

%% Gewichtsfunktion
% whitch domain to intersect?
dom_num_cut = weights(block,V,dom_total) 
%dom_num = 1;       % spezifische Domain


block = bisec(block,dom_num);

%% write a loop to visualize blocks :)

Visu =  zeros(nx,ny,nz);

% generic version

% temporal block indizes

% block1_nk_min = block(1,1);


for nk = block(1,5):block(1,6)
    for nj = block(1,3):block(1,4)
        for ni = block(1,1):block(1,2)
            Visu(ni,nj,nk)=1;
        end
    end
end

for nk = block(2,5):block(2,6)
    for nj = block(2,3):block(2,4)
        for ni = block(2,1):block(2,2)
            Visu(ni,nj,nk)=2;
        end
    end
end



%% slices for domains   
figure
xslice = x(end);
yslice = y(end);          
zslice = z(block(2,5));  % Achtung Stützstellen mit x(i) /= Blocknummern (nx) 

hold on;
h = slice(x,y,z,V,xslice,yslice,zslice );
h(1,1).EdgeColor = 'white';
h(2,1).EdgeColor =  'white';
h(3,1).EdgeColor =  [0.5,0.5,0.5];
h(1,1).FaceColor = 'flat';
h(2,1).FaceColor = 'flat';
h(3,1).FaceColor = 'flat';

% label domains
block_num = (1:dom_total)

t= text(x(4),y(4),z(block(1,5)+2),['domain number   ' ...
num2str(block_num(1))],'HorizontalAlignment','left','FontSize',8,'Color','red');

text(x(4),y(4),z(block(2,5)+2),['domain number   ' ...
num2str(block_num(2))],'HorizontalAlignment','left','FontSize',8,'Color','red');

xlabel('x','FontSize',12,'interpreter','latex')
ylabel('y','FontSize',12,'interpreter','latex')
zlabel('z','FontSize',12,'interpreter','latex')
daspect([1 1 1]);
view(-78, 16); 
hold on;
%isosurface of drop
%fig = figure
[x1,y1,z1]=meshgrid(x);
p = patch(isosurface(x1,y1,z1,V));
isonormals(x1,y1,z1,V,p)
p.FaceColor = 'red';
p.EdgeColor = 'none';
daspect([1 1 1])
view(-78, 16); 

%slices for funs field
xslice = 0.75;
yslice = 1;
zslice =0;
hold on;
h = slice(x,y,z,V,xslice,yslice,zslice);
h(1,1).EdgeColor = [0.5,0.5,0.5];
h(2,1).EdgeColor =  [0.5,0.5,0.5];
h(3,1).EdgeColor =  [0.5,0.5,0.5];
h(1,1).FaceColor = 'flat';
h(2,1).FaceColor = 'flat';
h(3,1).FaceColor = 'flat';

%% print setup
% set(fig,'Units','centimeters','Position',[1 1  15 15],...
% 'PaperPositionMode','auto');
% 
% fig = gcf;
% ax = fig.CurrentAxes;
% 
% caxis([-3.2 2])
% 
% 
% ax.FontSize = 12;
% ax.TickLabelInterpreter= 'latex';
% ax.XAxisLocation = 'origin';
% ax.YAxisLocation = 'origin';
% xlabel('x','FontSize',12,'interpreter','latex')
% ylabel('y','FontSize',12,'interpreter','latex')
% zlabel('z','FontSize',12,'interpreter','latex')
% 
% print(fig,'filename','-depsc2','-r0')
% movefile('filename.eps','~/masterarbeit/Dokumentation/plot') 

