The app **RaspiRemoteControl** designed to explore features and capabilities of a *Raspberry Pi Hardware*. A mobile robot remote control system had been considered as example. The app (running on
host computer with MATLAB) allows *Raspberry Pi* board to communicate with other hardware using GPIOpins, serial port, I2C and SPI interfaces. For acquiring sensor data and image data had been used MATLAB
Support Package for *Raspberry Pi Hardware*. For creating GUI had been used GUIDE – drag-and-drop environment which the provides various interactive components, including menus, tool bars and axes.
The app menu allows to perform the following functions:

**1. RasPi**
- Connect – connect app to Raspberry Pi Hardware via Wi-Fi (usb-dongle); the IP-address may be entered in a special text box “IP address 
- connect” on the main window app; this mode will indicated by green-highlighted button Connect.
- Disconnect – disconnect app from Raspberry Pi Hardware; this mode will indicated by red-highlighted button Connect.
- Network – open the dialogue box to enter IP address, login and password for Raspberry Pi.
- Reboot – reboot the Raspberry Pi operating system.
- Shutdown – shutdown the Raspberry Pi operating system.
- Terminal – open SSH terminal on host computer to use Raspberry Pi onboard Linux shell.
- Close – close the app.

**2. Interfaces**
- Camera – open the dialogue box to change default settings of Raspberry Pi Camera Board.
- RS232 – open the dialogue box to change default settings of Raspberry Pi Serial Port.
- SPI – open the dialogue box to change default settings of Raspberry Pi SPI interface.
- TWI – is not available in this version.

**3. Devices**
- Joystick – connect a joystick to the host computer (first joystick on the list).
- Webcam – is not available in this version.

 
Additional field “Interfaces” on the main window allows user to activate Raspberry Pi interfaces
via radio buttons: Camera Board, Serial Port, SPI interface and TWI interface (TWI is not available in this
version).

Use Camera Board to obtain images with Raspberry Pi. After the joystick had been connected and
radio button “Camera” had been activated, angles of slope first and second axis is being converted into
wheel speeds. Then wheel speeds are being sent via serial port in form:

[**‘$’**, 1, 0, 0, ***Left Robot Wheel speed***, 0, 0, ***Right Robot Wheel speed***, 0, **‘#’**].

It is necessary to install MATLAB® firmware (Raspbian) on Raspberry Pi board. Raspberry Pi and
host computer must be in same Wi-Fi network. All settings stored in the raspi.mat structure.

The project includes the following files:
- RaspiRemoteControl.m
- RaspiRemoteControl.fig
- Raspi_Network.fig
- Interfaces_Camera.fig
- Interfaces_RS232.fig
- Interfaces_SPI.fig
- raspi.mat 
