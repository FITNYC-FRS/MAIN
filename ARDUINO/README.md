# ARDUINO MAIN PAGE

Here you will find resources and code for learning how to incorporate Arduino technologies into your next project.

Basics:\
To get started working with Arduino you will need to either install the software or work online:\
\
Download Arduino IDE - [download software](https://www.arduino.cc/en/main/software)\
Getting Started with Arduino - [online editor guide](https://create.arduino.cc)\
\
Introduction tutorials:\
[Intro to Arduino](./Resources/intro_arduino.pdf)\
[Setting up and getting started](./Resources/arduino_setting_up.pdf)\
[Circuit and button basics](./Resources/arduino_buttons_circuit_basics.pdf)\
[Digital input/output](./Resources/arduino_creating_states.pdf)\
[Analog input/output](./Resources/arduino_analog_read.pdf)

After you have a looked at the introduction tutorials, feel free to work with the examples provided below.\
For a more indepth look at our [Resources](./Resources) page.

**Push a button and turn an LED off/on**\
*[Code](Code/arduino_digital_input_output.md)\
Components in the circuit:\
LED\
Resistor(s)\
Momentary Switch (Button)*\
\
\
**Turn a dial to dim a light**\
*[Code](Code/arduino_analog_input_output.md)\
Components in the circuit:\
LED\
Resistor(s)/Capacitor(s)\
Potentiometer (Dial)*\
\
\
**Turn a dial to adjust a servo arm**\
*[Code](Code/arduino_dial_servo.md)\
Components in the circuit:\
Servo Motor\
Capacitor(s)\
Potentiometer (Dial)*\
\
\
**Turn a dial to adjust speed of a motor**\
*[Code](Code/arduino_dial_motor_speed.md)\
Components in the circuit:\
Stepper Motor\
Capacitor(s)\
Potentiometer (Dial)*\
\
\
**Changing visual output with a button press**

*This next section will be about connecting the Arduino computer and sensors to a visual element in an open source software program called Processing.\
\
Processing.org - [main web page for reference and downloading open source software](http://processing.org)
\
Check out our [Processing](../PROCESSING/) info page\
\
In order to connect Arduino interactivity with Processing visual output, we need to write two different sets of code. Code for the Arduino to take in data or input from the sensors/button and then output a response through a USB connected to a computer. And code for the Processing software to listen for the output from the Arduino and then make changes to a display that is being created in the Processing code. For this example, I will provide code that waits for a button to be pressed that is connected to the Arduino and then sends a serial message to the computer. When the message is received by a running Processing sketch(that is what projects in Processing are called), the display will change background colors while the button is pressed.\
\
\
So, for clarity, the same button schematic, or hookup, provided for the button_LED example above will work for this but the code will be different so, instead of turning on an LED, the sketch will send data over the USB to be received by the Processing sketch and change the color of the display. For example, a button is pressed that is hooked up to a microcontroller and the display changes from red to green. This is a super stripped down example but the code provided can be changed to either add more buttons or add more interactivity in the display like keeping count of how many times the button is pressed and displaying that number on the display or virtually anything visual.*


[arduino_code](Code/arduino_usb_processing.md)\
[processing_code](Code/processing_serial_input.md)
