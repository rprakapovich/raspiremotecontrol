% % Copyright (c) 2016, RoboticsBY/SmartRobo, United Institute of Informatics
% % Problems National Academy of Science of Belarus
% % 
% % Granted by Ryhor Prakapovich, rprakapovich@robotics.by
% % 
% % All rights reserved.
 

function RaspiRemoteControl
clc

H = open('RaspiRemoteControl.fig');
handles = guihandles(H);

set(handles.pushbutton_Up,'Callback',{@pushbutton_Up_Callback, handles})
set(handles.pushbutton_Rt,'Callback',{@pushbutton_Rt_Callback, handles})
set(handles.pushbutton_Dn,'Callback',{@pushbutton_Dn_Callback, handles})
set(handles.pushbutton_Lf,'Callback',{@pushbutton_Lf_Callback, handles})
set(handles.pushbutton_St,'Callback',{@pushbutton_St_Callback, handles})

set(handles.radiobutton_Camera,'Callback',{@radiobutton_Camera_Callback, handles})
set(handles.radiobutton_RS232, 'Callback',{@radiobutton_RS232_Callback,  handles})
set(handles.radiobutton_SPI,   'Callback',{@radiobutton_SPI_Callback,    handles})
set(handles.radiobutton_TWI,   'Callback',{@radiobutton_TWI_Callback,    handles})

set(handles.edit_IPadress, 'Callback',{@edit_IPadress_Callback, handles})

set(handles.pushbutton_IPconnect,'Callback',{@pushbutton_IPconnect_Callback, handles})

Menu_Raspi = uimenu(...    
                    'Parent',H,...
                    'HandleVisibility','callback', ...
                    'Label','RasPi');
handles.ConnectMenu_item = uimenu(...      
                        'Parent',Menu_Raspi,...
                        'Label','Connect',...
                        'HandleVisibility','callback', ...
                        'Callback', {@Menu_Raspi_Connect_Callback, handles});
handles.DisconnectMenu_item = uimenu(...      
                        'Parent',Menu_Raspi,...
                        'Label','Disconnect',...
                        'HandleVisibility','callback', ...
                        'Enable','off',...
                        'Callback', {@Menu_Raspi_Disconnect_Callback, handles});
  
handles.NetworkMenu_item = uimenu(...      
                        'Parent',Menu_Raspi,...
                        'Label','Network',...
                        'Separator','on',...
                        'HandleVisibility','callback', ...
                        'Callback',{@Menu_Raspi_Network_Callback, handles});   
                 
handles.RebootMenu_item = uimenu(...      
                        'Parent',Menu_Raspi,...
                        'Label','Reboot',...
                        'Separator','on',...
                        'HandleVisibility','callback', ...
                        'Enable','off',...
                        'Callback',{@Menu_Raspi_Reboot_Callback, handles});    
                    
handles.ShutdownMenu_item = uimenu(...      
                        'Parent',Menu_Raspi,...
                        'Label','Shutdown',...
                        'HandleVisibility','callback', ...
                        'Enable','off',...
                        'Callback',{@Menu_Raspi_Shutdown_Callback, handles});    

handles.TerminalMenu_item = uimenu(...       
                        'Parent',Menu_Raspi,...
                        'Separator','on',...                        
                        'Label','Terminal',...
                        'HandleVisibility','callback', ...
                        'Enable','off',...
                        'Callback', {@Menu_Devices_Terminal_Callback, handles});                     
                    
handles.CloseMenu_item = uimenu(...      
                        'Parent',Menu_Raspi,...
                        'Label','Close',...
                        'Separator','on',...
                        'HandleVisibility','callback', ...
                        'Callback',{@close_Figure, handles});
                                       
                    
handles.Menu_Interfaces = uimenu(...       
                    'Parent',H,...
                    'HandleVisibility','callback',...
                    'Label','Interfaces');
Camera_item = uimenu(...        
                        'Parent',handles.Menu_Interfaces,...
                        'Label','Camera',...
                        'HandleVisibility','callback', ...
                        'Callback', {@Menu_Interfaces_Camera_Callback, handles});
RS232_item = uimenu(...       
                        'Parent',handles.Menu_Interfaces,...
                        'Label','RS232',...
                        'HandleVisibility','callback', ...
                        'Callback', {@Menu_Interfaces_RS232_Callback, handles});                    
SPI_item = uimenu(...       
                        'Parent',handles.Menu_Interfaces,...
                        'Label','SPI',...
                        'HandleVisibility','callback', ...
                        'Callback', {@Menu_Interfaces_SPI_Callback, handles});                    
   
TWI_item = uimenu(...       
                        'Parent',handles.Menu_Interfaces,...
                        'Label','TWI',...
                        'HandleVisibility','callback', ...
                        'Callback', {@Menu_Interfaces_TWI_Callback, handles}); 
                   
                    
handles.Menu_Devices = uimenu(...       
                    'Parent',H,...
                    'HandleVisibility','callback',...
                    'Label','Devices');
Joystick_item = uimenu(...        
                        'Parent',handles.Menu_Devices,...
                        'Label','Joystick',...
                        'HandleVisibility','callback', ...
                        'Callback', {@Menu_Devices_Joystick_Callback, handles});
Webcam_item = uimenu(...       
                        'Parent',handles.Menu_Devices,...
                        'Label','Webcam',...
                        'HandleVisibility','callback', ...
                        'Callback', {@Menu_Devices_Webcam_Callback, handles});    


load('raspi.mat','-mat','raspi')
handles.raspi = raspi;
clear raspi

handles.timer_cam = timer('ExecutionMode', 'fixedRate',...
                          'Period', round(1000/handles.raspi.interfaces.camera.framerate)/1000,...
                          'TimerFcn', {@update_Cam_Callback,handles}); 

set(handles.edit_IPadress,'String',handles.raspi.connecting.ipadress); 

temp = handles.raspi.interfaces.camera.resolution;
cols = str2double(temp(1:strfind(temp,'x')-1));
rows = str2double(temp(strfind(temp,'x')+1:end));
set(handles.axes_CameraViewer,'XLim',[0 cols],'YLim',[0 rows])
clear rows cols temp 


guidata(H, handles)


function pushbutton_IPconnect_Callback(src, evt, handles)
handles = guidata(handles.win_main);
    
    if strcmp(get(handles.pushbutton_IPconnect,'String'),'Connect')

        if ~isfield(handles,'mypi')
              handles.mypi = raspi(handles.raspi.connecting.ipadress,...
                                   handles.raspi.connecting.username,...
                                   handles.raspi.connecting.password);
        end
            
        set(handles.Menu_Interfaces, 'Enable','off');
        set(handles.Menu_Devices,    'Enable','off');
        set(handles.NetworkMenu_item,'Enable','off');
        set(handles.CloseMenu_item,  'Enable','off');
                
        set(handles.pushbutton_IPconnect,'BackgroundColor','green')
        set(handles.pushbutton_IPconnect,'String','Disconnect')

        set(handles.ConnectMenu_item,   'Enable','off')
        set(handles.DisconnectMenu_item,'Enable','on')
        set(handles.RebootMenu_item,    'Enable','on')
        set(handles.ShutdownMenu_item,  'Enable','on')
        set(handles.TerminalMenu_item,  'Enable','on')
        
        set(handles.radiobutton_Camera,'Enable','on')
        set(handles.radiobutton_RS232, 'Enable','on')
        set(handles.radiobutton_SPI,   'Enable','on')
        set(handles.radiobutton_TWI,   'Enable','on')

        if ~isfield(handles,'cam')
             handles.cam = cameraboard(handles.mypi,...
                  'Resolution',     handles.raspi.interfaces.camera.resolution,...
                  'FrameRate',      handles.raspi.interfaces.camera.framerate,...
                  'Rotation',       handles.raspi.interfaces.camera.rotation,...
                  'HorizontalFlip', handles.raspi.interfaces.camera.horizontalflip,...
                  'VerticalFlip',   handles.raspi.interfaces.camera.verticalflip);
        end
        
        if ~isfield(handles,'rs232')
            handles.rs232 = serialdev(handles.mypi,'/dev/ttyAMA0',...
                handles.raspi.interfaces.rs232.baudRate,...
                handles.raspi.interfaces.rs232.dataBits,...
                handles.raspi.interfaces.rs232.parity,...
                handles.raspi.interfaces.rs232.stopBits);
                handles.raspi.interfaces.rs232.Timeout = 1;
        end
        
        if ~isfield(handles,'spi')
            handles.spi = spidev(handles.mypi,...
                                 handles.raspi.interfaces.spi.channel,...
                                 handles.raspi.interfaces.spi.mode,...
                                 handles.raspi.interfaces.spi.speed);
        end

        handles.ii = 0;
        handles.direction = 0;
       
    else
        set(handles.pushbutton_IPconnect,'BackgroundColor','red')
        set(handles.pushbutton_IPconnect,'String','Connect')

        set(handles.Menu_Interfaces, 'Enable','on');
        set(handles.Menu_Devices,    'Enable','on');
        set(handles.NetworkMenu_item,'Enable','on');
        set(handles.CloseMenu_item,  'Enable','on');

        set(handles.ConnectMenu_item,'Enable',   'on')
        set(handles.DisconnectMenu_item,'Enable','off')        
        set(handles.RebootMenu_item,'Enable',    'off')
        set(handles.ShutdownMenu_item,'Enable',  'off')        
        
        set(handles.radiobutton_Camera,'Value', 0)
        set(handles.radiobutton_RS232, 'Value', 0)
        set(handles.radiobutton_SPI,   'Value', 0)
        set(handles.radiobutton_TWI,   'Value', 0)        
        
        set(handles.radiobutton_Camera,'Enable','off')
        set(handles.radiobutton_RS232, 'Enable','off')
        set(handles.radiobutton_SPI,   'Enable','off')
        set(handles.radiobutton_TWI,   'Enable','off')
        set(handles.TerminalMenu_item, 'Enable','off')
        
        if strcmp(get(handles.timer_cam, 'Running'), 'on')
            stop(handles.timer_cam);
        end        
        
        if isfield(handles,'spi'),  handles = rmfield(handles,'spi');   end
        if isfield(handles,'twi'),  handles = rmfield(handles,'twi');   end
        if isfield(handles,'rs232'),handles = rmfield(handles,'rs232'); end
        if isfield(handles,'cam'),  handles = rmfield(handles,'cam');   end
        if isfield(handles,'mypi'), handles = rmfield(handles,'mypi');  end
        
    end

guidata(handles.win_main, handles)

function Menu_Interfaces_Camera_Callback(src, evt, handles)

handles = guidata(handles.win_main);

handles.figure_camera = guihandles(open('Interfaces_Camera.fig'));
set(handles.figure_camera.pushbutton_Ok,'Callback',{@figure_pushbutton_Camera_Ok_Callback, handles})

% ============ Rotation ===============
for ii = 1: 4
    eval(['set(handles.figure_camera.radiobutton',num2str(ii),',''Callback'',{@radiobuttons_camera_Rotation_Callback, handles})'])
end
    for ii = 1: 4
        if eval(['str2num(get(handles.figure_camera.radiobutton',num2str(ii),',''String'')) == handles.raspi.interfaces.camera.rotation'])
            eval(['set(handles.figure_camera.radiobutton',num2str(ii),',''Value'',1)']);
            break
        end
    end

% ============= Flip ==================    
    set(handles.figure_camera.radiobutton_hf,'Callback',{@radiobuttons_camera_Flip_Callback, handles});
    set(handles.figure_camera.radiobutton_vf,'Callback',{@radiobuttons_camera_Flip_Callback, handles})

    set(handles.figure_camera.radiobutton_hf','Value',handles.raspi.interfaces.camera.horizontalflip)
    set(handles.figure_camera.radiobutton_vf','Value',handles.raspi.interfaces.camera.verticalflip)
    
% ============= Resolution ============
    set(handles.figure_camera.popupmenu_resolution,'Callback',{@popupmenu_camera_Resolution_Callback, handles});

    temp = get(handles.figure_camera.popupmenu_resolution,'String');
    for ii = 1: numel(temp)
        if strcmp(temp{ii},handles.raspi.interfaces.camera.resolution)
            set(handles.figure_camera.popupmenu_resolution,'Value',ii);
            break
        end       
    end
    clear temp
        
% ============= FrameRate ============
    set(handles.figure_camera.popupmenu_framerate,'Callback',{@popupmenu_camera_FrameRate_Callback, handles});

    temp = str2double(get(handles.figure_camera.popupmenu_framerate,'String'));
    for ii = 1: numel(temp)
        if temp(ii) == handles.raspi.interfaces.camera.framerate
            set(handles.figure_camera.popupmenu_framerate,'Value',ii);
            break
        end       
    end
    clear temp

% ============= Brightness-Contrast-Saturation-Sharpness ============   

    set(handles.figure_camera.slider_Brightness,'Callback',{@slider_camera_BlindStopper_Callback, handles})    
    set(handles.figure_camera.slider_Contrast,  'Callback',{@slider_camera_BlindStopper_Callback, handles})
    set(handles.figure_camera.slider_Saturation,'Callback',{@slider_camera_BlindStopper_Callback, handles})
    set(handles.figure_camera.slider_Sharpness, 'Callback',{@slider_camera_BlindStopper_Callback, handles})
    
guidata(handles.win_main, handles)

function Menu_Interfaces_SPI_Callback(src, evt, handles)

handles = guidata(handles.win_main);

handles.figure_spi = guihandles(open('Interfaces_SPI.fig'));

set(handles.figure_spi.pushbutton_Ok,'Callback',{@figure_pushbutton_RS232_Ok_Callback, handles})

% ============= Channel ============
    set(handles.figure_spi.popupmenu_channel,'Callback',{@popupmenu_spi_Channel_Callback, handles});

    temp = get(handles.figure_spi.popupmenu_channel,'String');
    for ii = 1: numel(temp)
        if strcmp(temp{ii},handles.raspi.interfaces.spi.channel)
            set(handles.figure_spi.popupmenu_channel,'Value',ii);
            break
        end       
    end
    clear temp
        
% ============= Mode ============
    set(handles.figure_spi.popupmenu_mode,'Callback',{@popupmenu_spi_Mode_Callback, handles});

    temp = str2double(get(handles.figure_spi.popupmenu_mode,'String'));
    for ii = 1: numel(temp)
        if temp(ii) == handles.raspi.interfaces.spi.mode
            set(handles.figure_spi.popupmenu_mode,'Value',ii);
            break
        end       
    end
    clear temp    
    
% ============= Speed ============
    set(handles.figure_spi.popupmenu_speed,'Callback',{@popupmenu_spi_Speed_Callback, handles});

    temp = str2double(get(handles.figure_spi.popupmenu_speed,'String'));
    for ii = 1: numel(temp)
        if temp(ii) == handles.raspi.interfaces.spi.speed
            set(handles.figure_spi.popupmenu_speed,'Value',ii);
            break
        end       
    end
    clear temp

guidata(handles.win_main, handles)


function Menu_Devices_Joystick_Callback(src, evt, handles)

handles = guidata(handles.win_main);
        
    if ~isfield(handles,'joystick')
        handles.joystick = vrjoystick(1);
    else
        close(handles.joystick);
        handles = rmfield(handles,'joystick');
    end 
          
guidata(handles.win_main, handles)

function radiobuttons_camera_Rotation_Callback(src, evt, handles)

handles = guidata(handles.win_main);
 for ii = 1: 4
     if eval(['get(handles.figure_camera.radiobutton',num2str(ii),',''Value'')'])
         eval(['handles.raspi.interfaces.camera.rotation = str2num(get(handles.figure_camera.radiobutton',num2str(ii),',''String''))'])     
         break
     end  
 end
guidata(handles.win_main, handles)

function radiobuttons_camera_Flip_Callback(src, evt, handles)

handles = guidata(handles.win_main);
    
    handles.raspi.interfaces.camera.horizontalflip = get(handles.figure_camera.radiobutton_hf,'Value');
    handles.raspi.interfaces.camera.verticalflip   = get(handles.figure_camera.radiobutton_vf,'Value');
 
guidata(handles.win_main, handles)

function popupmenu_camera_Resolution_Callback(src, evt, handles)

handles = guidata(handles.win_main);
        
    temp = get(handles.figure_camera.popupmenu_resolution,'String');
    handles.raspi.interfaces.camera.resolution = temp{get(handles.figure_camera.popupmenu_resolution,'Value')};
    clear temp
 
guidata(handles.win_main, handles)

function popupmenu_camera_FrameRate_Callback(src, evt, handles)

handles = guidata(handles.win_main);
        
    temp = str2double(get(handles.figure_camera.popupmenu_framerate,'String'));
    handles.raspi.interfaces.camera.framerate = temp(get(handles.figure_camera.popupmenu_framerate,'Value'));
    clear temp
 
guidata(handles.win_main, handles)

function figure_pushbutton_Camera_Ok_Callback(src, evt, handles)

handles = guidata(handles.win_main);
        
    raspi = handles.raspi;
    save('raspi.mat','raspi')
    clear raspi 
    
close gcf

guidata(handles.win_main, handles)

% ========================== Menu_Interfaces_RS232 =====================
function Menu_Interfaces_RS232_Callback(src, evt, handles)

handles = guidata(handles.win_main);

handles.figure_rs232 = guihandles(open('Interfaces_RS232.fig'));
set(handles.figure_rs232.pushbutton_Ok,'Callback',{@figure_pushbutton_RS232_Ok_Callback, handles})

for ii = 1: 14
    eval(['set(handles.figure_rs232.radiobutton',num2str(ii),',''Callback'',{@radiobuttons_rs232_baudRate_Callback, handles})'])
end
    for ii = 1: 14
        if eval(['str2num(get(handles.figure_rs232.radiobutton',num2str(ii),',''String'')) == handles.raspi.interfaces.rs232.baudRate'])
            eval(['set(handles.figure_rs232.radiobutton',num2str(ii),',''Value'',1)'])
            break
        end
    end

for ii = 16: 19
    eval(['set(handles.figure_rs232.radiobutton',num2str(ii),',''Callback'',{@radiobuttons_rs232_dataBits_Callback, handles})'])
end
    for ii = 16: 19
        if eval(['str2num(get(handles.figure_rs232.radiobutton',num2str(ii),',''String'')) == handles.raspi.interfaces.rs232.dataBits'])
            eval(['set(handles.figure_rs232.radiobutton',num2str(ii),',''Value'',1)'])
            break
        end
    end
    
for ii = 20: 24
    eval(['set(handles.figure_rs232.radiobutton',num2str(ii),',''Callback'',{@radiobuttons_rs232_Parity_Callback, handles})'])
end
    for ii = 20: 24
        if eval(['strcmp(get(handles.figure_rs232.radiobutton',num2str(ii),',''String''), handles.raspi.interfaces.rs232.parity)'])
            eval(['set(handles.figure_rs232.radiobutton',num2str(ii),',''Value'',1)'])
            break
        end
    end    
    
for ii = 25: 27
    eval(['set(handles.figure_rs232.radiobutton',num2str(ii),',''Callback'',{@radiobuttons_rs232_stopBits_Callback, handles})'])
end
    for ii = 25: 27
        if eval(['str2num(get(handles.figure_rs232.radiobutton',num2str(ii),',''String'')) == handles.raspi.interfaces.rs232.stopBits'])
            eval(['set(handles.figure_rs232.radiobutton',num2str(ii),',''Value'',1)'])
            break
        end
    end
    
guidata(handles.win_main, handles)


function radiobuttons_rs232_baudRate_Callback(src, evt, handles)

handles = guidata(handles.win_main);
 for ii = 1: 14
     if eval(['get(handles.figure_rs232.radiobutton',num2str(ii),',''Value'')'])
         eval(['handles.raspi.interfaces.rs232.baudRate = str2num(get(handles.figure_rs232.radiobutton',num2str(ii),',''String''))'])     
         break
     end  
 end
guidata(handles.win_main, handles)

function radiobuttons_rs232_dataBits_Callback(src, evt, handles)

handles = guidata(handles.win_main);
 for ii = 16: 19
     if eval(['get(handles.figure_rs232.radiobutton',num2str(ii),',''Value'')'])
         eval(['handles.raspi.interfaces.rs232.dataBits = str2num(get(handles.figure_rs232.radiobutton',num2str(ii),',''String''))'])     
         break
     end  
 end
guidata(handles.win_main, handles)

function radiobuttons_rs232_Parity_Callback(src, evt, handles)

handles = guidata(handles.win_main);
 for ii = 20: 24
     if eval(['get(handles.figure_rs232.radiobutton',num2str(ii),',''Value'')'])
         eval(['handles.raspi.interfaces.rs232.parity = get(handles.figure_rs232.radiobutton',num2str(ii),',''String'')'])     
         break
     end  
 end
guidata(handles.win_main, handles)

function radiobuttons_rs232_stopBits_Callback(src, evt, handles)

handles = guidata(handles.win_main);
 for ii = 25: 27
     if eval(['get(handles.figure_rs232.radiobutton',num2str(ii),',''Value'')'])
         eval(['handles.raspi.interfaces.rs232.stopBits = str2num(get(handles.figure_rs232.radiobutton',num2str(ii),',''String''))'])
         break
     end  
 end
guidata(handles.win_main, handles)
         
function figure_pushbutton_RS232_Ok_Callback(src, evt, handles)

handles = guidata(handles.win_main);
raspi = handles.raspi;
save('raspi.mat','raspi')
clear raspi

close gcf

guidata(handles.win_main, handles)

function popupmenu_spi_Channel_Callback(src, evt, handles)

handles = guidata(handles.win_main);
        
    temp = get(handles.figure_spi.popupmenu_channel,'String')
    handles.raspi.interfaces.spi.channel = temp{get(handles.figure_spi.popupmenu_channel,'Value')}
    clear temp
 
guidata(handles.win_main, handles)

function popupmenu_spi_Mode_Callback(src, evt, handles)

handles = guidata(handles.win_main);
        
    temp = str2double(get(handles.figure_spi.popupmenu_mode,'String'));
    handles.raspi.interfaces.spi.mode = temp(get(handles.figure_spi.popupmenu_mode,'Value'));
    clear temp
 
guidata(handles.win_main, handles)

function popupmenu_spi_Speed_Callback(src, evt, handles)

handles = guidata(handles.win_main);
        
    temp = str2double(get(handles.figure_spi.popupmenu_speed,'String'));
    handles.raspi.interfaces.spi.speed = temp(get(handles.figure_spi.popupmenu_speed,'Value'));
    clear temp
 
guidata(handles.win_main, handles)

function pushbutton_Up_Callback(src, evt, handles)
handles = guidata(handles.win_main);
    warndlg('This feature is not available in this version');
guidata(handles.win_main, handles)

function pushbutton_Dn_Callback(src, evt, handles)
handles = guidata(handles.win_main);
    warndlg('This feature is not available in this version');
guidata(handles.win_main, handles)

function pushbutton_Rt_Callback(src, evt, handles)
handles = guidata(handles.win_main);
   warndlg('This feature is not available in this version');
guidata(handles.win_main, handles)

function pushbutton_Lf_Callback(src, evt, handles)
handles = guidata(handles.win_main);
    warndlg('This feature is not available in this version');
guidata(handles.win_main, handles)

function pushbutton_St_Callback(src, evt, handles)
handles = guidata(handles.win_main);
    warndlg('This feature is not available in this version');
guidata(handles.win_main, handles)

function radiobutton_Camera_Callback(src, evt, handles)
handles = guidata(handles.win_main);
 
   if get(handles.radiobutton_Camera,'Value') == 1
        
        handles.CameraViewer = imagesc(snapshot(handles.cam));
        guidata(handles.win_main, handles)
        
        if strcmp(get(handles.timer_cam, 'Running'), 'off')
            start(handles.timer_cam);
        end
    else 
        if strcmp(get(handles.timer_cam, 'Running'), 'on')
            stop(handles.timer_cam);
        end
        guidata(handles.win_main, handles)
    end
    
    
function radiobutton_RS232_Callback(src, evt, handles)

handles = guidata(handles.win_main);
    if get(handles.radiobutton_RS232,'Value') == 1   
        tmp = handles.rs232
%     Here you can write code for data processing from the RS232 port
    end
guidata(handles.win_main, handles)

function radiobutton_SPI_Callback(src, evt, handles)
handles = guidata(handles.win_main);
   
    if get(handles.radiobutton_SPI,'Value') == 1
        tmp = handles.spi
%     Here you can write code for data processing from the SPI port        
    end
    
guidata(handles.win_main, handles)

function radiobutton_TWI_Callback(src, evt, handles)
handles = guidata(handles.win_main);

%     Here you can write code for data processing from the TWI port 
   
guidata(handles.win_main, handles)

function update_Cam_Callback(src, evt, handles)

handles = guidata(handles.win_main);

    set(handles.CameraViewer,'CData', snapshot(handles.cam));
       
    handles.ii = handles.ii + 1;    
    if isfield(handles, 'joystick') && mod(handles.ii, 3)
        p = (-axis(handles.joystick, 2)+1)/2*255;
        q = (-axis(handles.joystick, 1)+1)/2*255 - 127;
        
        t = [36, 1, 0, 0, p + q/2, 0, 0, p - q/2, 0, 35]

        write(handles.rs232,t,'uint8')
    end
    
guidata(handles.win_main, handles)

function Menu_Raspi_Connect_Callback(src, evt, handles)

handles = guidata(handles.win_main);
    pushbutton_IPconnect_Callback(src, evt, handles)

function Menu_Raspi_Disconnect_Callback(src, evt, handles)

handles = guidata(handles.win_main);
    pushbutton_IPconnect_Callback(src, evt, handles)    
    
function Menu_Raspi_Reboot_Callback(src, evt, handles)

handles = guidata(handles.win_main);
    system(handles.mypi, 'sudo reboot')
    pushbutton_IPconnect_Callback(src, evt, handles)
% guidata(handles.win_main, handles)

function Menu_Raspi_Shutdown_Callback(src, evt, handles)

handles = guidata(handles.win_main);
    system(handles.mypi, 'sudo shutdown -h now')
    pushbutton_IPconnect_Callback(src, evt, handles)
% guidata(handles.win_main, handles)
   
function Menu_Raspi_Network_Callback(src, evt, handles)

handles = guidata(handles.win_main);

handles.figure_network = guihandles(open('Raspi_Network.fig'));

set(handles.figure_network.pushbutton_Ok,'Callback',{@figure_pushbutton_Network_Ok_Callback, handles})

% ============= IP address ============
    tmp = find(handles.raspi.connecting.ipadress == '.');

    set(handles.figure_network.edit_ip_1,'String',handles.raspi.connecting.ipadress(1        : tmp(1)-1));
    set(handles.figure_network.edit_ip_2,'String',handles.raspi.connecting.ipadress(tmp(1)+1 : tmp(2)-1));
    set(handles.figure_network.edit_ip_3,'String',handles.raspi.connecting.ipadress(tmp(2)+1 : tmp(3)-1));
    set(handles.figure_network.edit_ip_4,'String',handles.raspi.connecting.ipadress(tmp(3)+1 : end));

    clear tmp
% ============= Login ============
    set(handles.figure_network.edit_login,'String',handles.raspi.connecting.username);

% ============= Password ============
    set(handles.figure_network.edit_password,'String',handles.raspi.connecting.password);

guidata(handles.win_main, handles)

function figure_pushbutton_Network_Ok_Callback(src, evt, handles)

handles = guidata(handles.win_main);

    handles.raspi.connecting.ipadress = ...
        [get(handles.figure_network.edit_ip_1,'String'),'.',...
         get(handles.figure_network.edit_ip_2,'String'),'.',...
         get(handles.figure_network.edit_ip_3,'String'),'.',...
         get(handles.figure_network.edit_ip_4,'String')];

    set(handles.edit_IPadress, 'String', handles.raspi.connecting.ipadress); 
     
    handles.raspi.connecting.username = get(handles.figure_network.edit_login,'String');
    
    handles.raspi.connecting.password = get(handles.figure_network.edit_password,'String');
    
raspi = handles.raspi;
save('raspi.mat','raspi')
clear raspi

close gcf

guidata(handles.win_main, handles)

function Menu_Devices_Terminal_Callback(src, evt, handles)

handles = guidata(handles.win_main);
    openShell(handles.mypi)
guidata(handles.win_main, handles)

function edit_IPadress_Callback(src, evt, handles)

handles = guidata(handles.win_main);
    handles.raspi.connecting.ipadress = get(handles.edit_IPadress, 'String');
    raspi = handles.raspi;
    save('raspi.mat','raspi')
    clear raspi 
guidata(handles.win_main, handles)

function Menu_Devices_Webcam_Callback(src, evt, handles)

handles = guidata(handles.win_main);
    warndlg('This feature is not available in this version');
guidata(handles.win_main, handles)

function Menu_Interfaces_TWI_Callback(src, evt, handles)

handles = guidata(handles.win_main);
    warndlg('This feature is not available in this version');
guidata(handles.win_main, handles)

function slider_camera_BlindStopper_Callback(src, evt, handles)

handles = guidata(handles.win_main);
    warndlg('This feature is not available in this version');
guidata(handles.win_main, handles)

function close_Figure(src, evt, handles)

close(gcf)
