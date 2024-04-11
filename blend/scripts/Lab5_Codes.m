

clear
close all

% all data are in dimension of lon*lat*time
% surface data
filesurf = 'ERA5_03121993_00Z_surf.nc';
msl0 = ncread(filesurf,'msl')/100;
time_1d = ncread(filesurf,'time');

% pressure level data
filep = 'P500_data_03121993.nc';
lat = ncread(filep,'lat');
lon = ncread(filep,'lon');
u0 = ncread(filep,'u500'); % 500 mb u - wind
v0 = ncread(filep,'v500'); % 500 mb v - wind
vor0 = ncread(filep,'vor500'); % 500 mb relative vort.
wnd0 = ncread(filep,'wnd250'); % 250 mb wind speed
z0 = ncread(filep,'z500')/9.8; % 500 mb geo. height
thk0 = ncread(filep,'thk')/9.8; % 500 -1000 mb thickness

% isentropic surface data
filethetasurf = 'theta315_Surf_data_03121993.nc';
zt0 = ncread(filethetasurf,'z')/9.8;
qt0 = ncread(filethetasurf,'q');
ut0 = ncread(filethetasurf,'u');
vt0 = ncread(filethetasurf,'v');

% dynamical tropopause surface data
filepvsurf = 'PVU2_Surf_data_03121993.nc';
thetap0 = ncread(filepvsurf,'theta');
zp0 = ncread(filepvsurf,'z')/9.8;
up0 = ncread(filepvsurf,'u');
vp0 = ncread(filepvsurf,'v');

%% Preparing for plotting

% define .gif file
gif_filename = 'Weather_Evolution_sample_1.gif';

% define movie file
vd = VideoWriter('Weather_Evolution_sample_1','MPEG-4');
vd.FrameRate = 1; % this parameter controls the speed of movie
open(vd);
%


%%%%%%%%% creat colormap for each subplot respectively %%%%%%

% subplot 1: jet
cmapwnd1 = colormap(othercolor('PRGn8',14));
cmapwnd2 = colormap(othercolor('PuRd5',7));
cmap1 = cat(1,cmapwnd1([9,11,13],:),cmapwnd2(2:5,:));

% subplot 2: absolute vorticity
cmap2 = colormap(othercolor('BuDRd_18',24));
cmap2 = cmap2(15:2:24,:);

% subplot 3: 315k theta surface specific humidity
cmap3 = colormap(othercolor('Set34',30));

% subplot 3_2: 315k theta surface height
cmap3_2=colormap(othercolor('PuRd9',30));
cmap3_2=cmap3_2(16:end,:);


% subplot 4: 2pvu surface theta
map3=colormap(othercolor('BuDRd_18',200));
map4 = colormap(othercolor('GrMg_16',200));
map4 = flipud(map4(120:2:end,:));

cmap4=cat(1,map3,map4);
cmap4 = cmap4(1:12:end-12,:);

close

% end defining colormaps


%% start plotting

for time1 = 1:length(time_1d) % loop all available time-step

    figure('units','normalized','Position',[.1,.1,.8,.8])
    tiledlayout(2,2,'TileSpacing','compact')  % a new way to do subplot

    %%%%%%%%%%%%%%%%%%%%%%%%% plot 1 %%%%%%%%%%%%%%%%%%%%
    nexttile % toward next panel

    hold on % multiple plots on one figure
    % Map projection and choose the region to plot
    m_proj('miller','lon',[230 300],'lat',[15 55])
    m_grid('tickdir','in','linewidth',2,'fontsize',16,...
        'xtick',0:20:360,'ytick',-90:10:90);
    title({['mean sea level pressure (dashed red/hPa)'], ...
        ['500 hPa Geo.Height (solid blue/dm), 250 hPa jet (shading m/s)']})

    wnd250 = imgaussfilt(wnd0(:,:,time1),2);
    wnd250(wnd250<30) = NaN;

    m_contourf(lon,lat,wnd250',0:10:1120,'linestyle','none');
    set(gca,'colormap',cmap1);
    set(gca,'clim',[30,100])
    colorbar
    
    msl = imgaussfilt(msl0(:,:,time1),2);
    CI = 0:4:1500;
    [c1,h1] = m_contour(lon,lat,msl',CI,':', ...
        'linewidth',2,'color',[0.8500 0.3250 0.0980]);
    clabel(c1,h1,CI(1:2:end),'color',[0.8500 0.3250 0.0980],'fontsize',14)
    
    z500 = imgaussfilt(z0(:,:,time1),2);
    CI2 = 204:6:800;
    [c2,h2] = m_contour(lon,lat,z500'/10,CI2, ...
        'color',[0 0.4470 0.7410],'linewidth',2);
    clabel(c2,h2,CI2(1:2:end),'color',[0 0.4470 0.7410],'fontsize',14)
    
    m_coast('color','k');
    set(gca,'fontsize',16)

    M=m_shaperead('ne_110m_admin_1_states_provinces');
    for k=1:length(M.ncst) 
         m_line(M.ncst{k}(:,1)+360,M.ncst{k}(:,2),'color','k','linewidth',1); 
    end 

    %%%%%%%%%%%%%%%%%%%%%%%%% plot 2 %%%%%%%%%%%%%%%%%%%%
    nexttile
    hold on % multiple plots on one figure
    % Map projection and choose the region to plot
    m_proj('miller','lon',[230 300],'lat',[15 55])
    m_grid('tickdir','in','linewidth',2,'fontsize',16,...
        'xtick',0:20:360,'ytick',-90:10:90);
    title({ ['500 hPa abs.vort. (shading, 10^-^4 s^-^1),' ...
        ' Wind (barbs, kt)'],...
        ['500-1000 hPa Thickness (solid line/dm)'] ...
        })

    % shading plot of vorticity
    vor = imgaussfilt(vor0(:,:,time1),4);
    [~,LT] = meshgrid(lon,lat);
    f_2d = 2 * (2*pi/86400)*sind(LT'); 
    abs_vor = (vor + f_2d)*1e4;
    abs_vor(abs_vor<1.5)= NaN;

    m_contourf(lon,lat,abs_vor',0:0.1:20,'linestyle','none');
    colorbar('ytick',1.5:0.5:4)
    set(gca,'clim',[1.5 4])
    set(gca,'colormap',cmap2)


    % contourline of thickness(temp.)
    thk = imgaussfilt(thk0(:,:,time1),2);

    % less then 540 dam in cold color
    [c2,h2] = m_contour(lon,lat,thk'/10,300:8:532, ...
        'color',[0 0.4470 0.7410],'linewidth',2);
    clabel(c2,h2,200:4:532,'color',[0 0.4470 0.7410],'fontsize',14)

    % emphasize 540 dam contour line
    [c2,h2] = m_contour(lon,lat,thk'/10,[540 540], ...
        'color',[0 0.4470 0.7410],'linewidth',4);
    clabel(c2,h2,540,'color',[0 0.4470 0.7410], ...
        'fontweight','bold','fontsize',14)

    % larger then 540 dam in warm color
    [c2,h2] = m_contour(lon,lat,thk'/10,548:8:800, ...
        'color',[0.8500 0.3250 0.0980],'linewidth',2);
    clabel(c2,h2,548:8:800,'color',[0.8500 0.3250 0.0980],'fontsize',14)
    

    u500 = imgaussfilt(u0(:,:,time1),2);
    v500 = imgaussfilt(v0(:,:,time1),2);

    [LN,LT] = meshgrid(lon,lat);
    m_windbarb(LN(1:12:end,1:12:end),LT(1:12:end,1:12:end), ...
        u500(1:12:end,1:12:end)',v500(1:12:end,1:12:end)',5, ...
        'units','m/s','linewidth',1.5,'color','k')
    
    m_coast('color','k');
    set(gca,'fontsize',16)

    M=m_shaperead('ne_110m_admin_1_states_provinces');
    for k=1:length(M.ncst) 
         m_line(M.ncst{k}(:,1)+360,M.ncst{k}(:,2),'color','k','linewidth',1); 
    end 


    %%%%%%%%%%%%%%%%%%%%%%%%% plot 3 %%%%%%%%%%%%%%%%%%%%
    nexttile
    hold on % multiple plots on one figure
    % Map projection and choose the region to plot
    m_proj('miller','lon',[230 300],'lat',[15 55])
    m_grid('tickdir','in','linewidth',2,'fontsize',16,...
        'xtick',0:20:360,'ytick',-90:10:90);
    title({['\theta = 315K Spec. humidity (shading/10^-^3 kg kg^-^1)'], ...
        ['Wind (barbs, kt) and Geo.Height. (solid lines/dm)']})

    q = imgaussfilt(qt0(:,:,time1),2)*1e3;
    m_contourf(lon,lat,q',0:0.2:6,'linestyle','none');
    colorbar('ytick',0:1:5)
    set(gca,'clim',[0 4])
    set(gca,'colormap',cmap3)

    zt = imgaussfilt(zt0(:,:,time1),2);
    CI2 = 300:50:1000;
    for ic = 1:length(CI2)
        [c2,h2] = m_contour(lon,lat,zt'/10,[CI2(ic) CI2(ic)], ...
            'color',cmap3_2(ic,:),'linewidth',2);
        clabel(c2,h2,CI2(ic),'color',cmap3_2(ic,:),'fontsize',14)
    end

    ut = imgaussfilt(ut0(:,:,time1),2);
    vt = imgaussfilt(vt0(:,:,time1),2);

    [LN,LT] = meshgrid(lon,lat);
    m_windbarb(LN(1:12:end,1:12:end),LT(1:12:end,1:12:end), ...
        ut(1:12:end,1:12:end)',vt(1:12:end,1:12:end)',5, ...
        'units','m/s','linewidth',1.5,'color','b')
    
    m_coast('color','k');
    set(gca,'fontsize',16)

    M=m_shaperead('ne_110m_admin_1_states_provinces');
    for k=1:length(M.ncst) 
         m_line(M.ncst{k}(:,1)+360,M.ncst{k}(:,2),'color','k','linewidth',1); 
    end 


    %%%%%%%%%%%%%%%%%%%%%%%%% plot 4 %%%%%%%%%%%%%%%%%%%%
    nexttile
    hold on
    m_proj('miller','lon',[230 300],'lat',[15 55])
    m_grid('tickdir','in','linewidth',2,'fontsize',16,...
        'xtick',0:20:360,'ytick',-90:10:90);
    title({['Dyn. Tropopause (2PVU Surf.) \theta (shading/K)'], ...
        ['Wind (barbs, kt)']})
    
    set(gca,'colormap',cmap4)

    thetap = imgaussfilt( thetap0(:,1:360,time1),2);

    CI4 = 264-6*10:6:384+6*10;
    m_contourf(lon,lat(1:360),thetap',CI4,'linestyle','none');
    colorbar('ytick',264:12:384)
    set(gca,'clim',[264 384])

    [LN,LT] = meshgrid(lon,lat);
    m_windbarb(LN(1:12:end,1:12:end),LT(1:12:end,1:12:end), ...
        up0(1:12:end,1:12:end,time1)',vp0(1:12:end,1:12:end,time1)', ...
        5, 'units','m/s','linewidth',1.5,'color',[0 0.4470 0.7410])
       
    m_coast('color','k','linewidth',1);
    set(gca,'fontsize',16,'FontWeight','bold')

    M=m_shaperead('ne_110m_admin_1_states_provinces');
    for k=1:length(M.ncst) 
         m_line(M.ncst{k}(:,1)+360,M.ncst{k}(:,2),'color','k','linewidth',1); 
    end

    %%%%%%%%%%%%%%%%% adding Annotation to subplots %%%%%

    annotation('textbox',...
    [0.015, 0.92, 0.165, 0.04],...
    'String','a)',...
    'FontWeight','bold',...
    'FontSize',24,...
    'HorizontalAlignment','center',...
    'FitBoxToText','on',...
    'EdgeColor','none','linewidth',1.2);

    annotation('textbox',...
    [0.485, 0.92, 0.165, 0.04],...
    'String','b)',...
    'FontWeight','bold',...
    'FontSize',24,...
    'HorizontalAlignment','center',...
    'FitBoxToText','on',...
    'EdgeColor','none','linewidth',1.2);

    annotation('textbox',...
    [0.015, 0.47, 0.165, 0.04],...
    'String','c)',...
    'FontWeight','bold',...
    'FontSize',24,...
    'HorizontalAlignment','center',...
    'FitBoxToText','on',...
    'EdgeColor','none','linewidth',1.2);

    annotation('textbox',...
    [0.485, 0.47, 0.165, 0.04],...
    'String','d)',...
    'FontWeight','bold',...
    'FontSize',24,...
    'HorizontalAlignment','center',...
    'FitBoxToText','on',...
    'EdgeColor','none','linewidth',1.2);



    %%%%%%%%%%%%%%%%% adding Annotation for time %%%%%%%%%%

    %%%%%%%%%%%%%%%%% converting time (hours) to date/time %%%%%
    % Your data: hours from January 1, 1900, 00:00 UTC
    hours_from_reference = time_1d(time1);
    
    % Convert to date-time
    reference_date = datetime(1900, 1, 1, 0, 0, 0, ...
        'Format', 'yyyy-MM-dd HH:mm:ss', 'TimeZone', 'UTC');

    result_date_time = reference_date + hours(hours_from_reference);

    
    annotation('textbox',...
    [0.425, 0.95, 0.165, 0.04],...
    'String',[string(result_date_time)+' Z'],...
    'FontWeight','bold',...
    'FontSize',20,...
    'HorizontalAlignment','center',...
    'FitBoxToText','on',...
    'EdgeColor','k','linewidth',1.2);

    %%%%%%%%%%%%%%%%%%% creating gif %%%%%%%%%%

    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if time1 == 1
      imwrite(imind,cm,gif_filename,'gif', 'Loopcount',inf);
    else
      imwrite(imind,cm,gif_filename,'gif','WriteMode','append', ...
          'DelayTime',1);
    end

    %%%%%%%%%%%%%%%%%%% end creating gif %%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%% creating movie %%%%%%%%%%

    frame = getframe(gcf);
    writeVideo(vd,frame);

    %%%%%%%%%%%%%%%%%%% end creating movie %%%%%%%%%%

    %%%%%%%%%%%%%%%%%%% save as picture %%%%%%%%%%

    str1 =  strrep(string(result_date_time),'-','_');
    char1 = char(str1);
    char2 = [char1(1:10),'_',char1(12:13),'Z'];
    savename = ['Weathermap_',char2,'.jpg']

    if exist(savename, 'file')== 2
        disp('file exists and to be replaced')
        delete(savename);
    end
    
    saveas(gca,savename)

    close


end

close(vd);


