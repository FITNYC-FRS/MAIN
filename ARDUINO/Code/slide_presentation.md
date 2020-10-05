# SLIDE PRESENTATION IN PROCESSING USING A BUTTON AND ARDUINO

This example is for using Arduino button presses to advance a slide show presentation in Processing.

Check out the example for hooking up a button to Arduino - [Button Example](http://www.arduino.cc/en/Tutorial/Debounce)

Copy and paste this code below into your Arduino editor to upload to the Arduino board. If you need help understanding how to 
do that, check out [Setting Up](./Resources/arduino_setting_up.pdf) or the main introduction page [here](./)

# BELOW IS THE CODE FOR THE ARDUINO

```
// constants won't change. They're used here to set pin numbers:
const int buttonPin = 2;    // the number of the pushbutton pin
const int ledPin = 13;      // the number of the LED pin

// Variables will change:
int ledState = LOW;          // the current state of the output pin
int buttonState;             // the current reading from the input pin
int lastButtonState = LOW;   // the previous reading from the input pin
int buttonPressCount = 0;    // this variable is used to count how many times the button is pressed

// the following variables are unsigned longs because the time, measured in
// milliseconds, will quickly become a bigger number than can be stored in an int.
unsigned long lastDebounceTime = 0;  // the last time the output pin was toggled
unsigned long debounceDelay = 50;    // the debounce time; increase if the output flickers

void setup() {
  pinMode(buttonPin, INPUT);
  pinMode(ledPin, OUTPUT);

  // set initial LED state
  digitalWrite(ledPin, ledState);
  Serial.begin(9600);
}

void loop() {
  // read the state of the switch into a local variable:
  int reading = digitalRead(buttonPin);

  // check to see if you just pressed the button
  // (i.e. the input went from LOW to HIGH), and you've waited long enough
  // since the last press to ignore any noise:

  // If the switch changed, due to noise or pressing:
  if (reading != lastButtonState) {
    // reset the debouncing timer
    lastDebounceTime = millis();
  }

  if ((millis() - lastDebounceTime) > debounceDelay) {
    // whatever the reading is at, it's been there for longer than the debounce
    // delay, so take it as the actual current state:

    // if the button state has changed:
    if (reading != buttonState) {
      buttonState = reading;

      // only toggle the LED if the new button state is HIGH
      if (buttonState == HIGH) {
        ledState = !ledState;
      }
    }
  }

  // set the LED:
  digitalWrite(ledPin, ledState);   // this just turns the onboard LED on/off each time the button is pressed(just visual feedback for you)
  Serial.println(ledState);         // this is where the arduino sends the information through the USB to the computer

  // save the reading. Next time through the loop, it'll be the lastButtonState:
  lastButtonState = reading;
  
}

```

After you have successfully uploaded the code to your Arduino, open the Processing software so we can look for the signal from the Arduino 
to change our slides. In the code below, there are two things you would need to change.

One is to make sure that the serial port you are trying to read matches the USBmodem port for the Arduino. The variable "serial_port_arduino"
in the Processing code below is set to 11 because that is here my computer registers that USB port. When you run the sketch for the first time, 
you will see a list of serial ports printed out in the console log at the bottom of the screen below the code. That list will tell you what number
should be in the "serial_port_arduino" variable assignment where mine says "serial_port_arduino=11", your should match the number in brackets like mine
where it says "/dev/tty.usbmodem14101". The list looks like this:

\[0] "/dev/cu.Animal-SPPDev"\
\[1] "/dev/cu.Bluetooth-Incoming-Port"\
\[2] "/dev/cu.hmpdub-WirelessiAP"\
\[3] "/dev/cu.hmpdub-WirelessiAP-1"\
\[4] "/dev/cu.UEBOOM-LWACP"\
\[5] "/dev/cu.usbmodem14101"\
\[6] "/dev/tty.Animal-SPPDev"\
\[7] "/dev/tty.Bluetooth-Incoming-Port"\
\[8] "/dev/tty.hmpdub-WirelessiAP"\
\[9] "/dev/tty.hmpdub-WirelessiAP-1"\
\[10] "/dev/tty.UEBOOM-LWACP"\
\[11] "/dev/tty.usbmodem14101" - the number in the brackets on your list should be put into the "serial_port_arduino" variable.

The other is to accommodate the number of slides. At the very top of the code area is a variable called "number_slides" and
this is the number you would change to match the number of slides in your presentation. So, right now, it is equal to 4, meaning it will cycle
through four outputs starting with 0(programming concepts involve starting from 0 when establishing an order) and sequentially
increasing up to 3. So, each time the button is pressed, the counter(buttonPressCount) increases by 1 and resets when it passes
the number of slides provided by "number_slides" variable.

The trickiest part of all of this is making sure that your files are named correctly and placed in the sketch. You just want to make sure when you
name your files that they match the name in the code. For example, below I have named the files "slide_1.jpg", slide_2.jpg", etc. and you should do the same
just making sure that your extensions are correct whether they are .jpg or .png.

Once you have your files named, you will simply drag and drop them into your sketch. This action will create a folder named "Data" and
it is where the files will be stored. Copy and paste the code below into a blank sketch to get it to work.

# BELOW IS THE CODE FOR PROCESSING

```

import processing.serial.*;

// don't worry too mich about this first stuff, just leave it and it should be fine
int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port
int value = 0;
int prevValue = 0;

int serial_port_arduino; // this variable is used to tell processing which serial port to look for the arduino. defined below

// THIS IS THE VARIABLE THAT YOU WOULD CHANGE !!!!!!!
int number_slides = 4; // change this number to match the number of slides

// below is an array for the slides, which means it is like a container to store all slides for use later
PImage [] slides = new PImage[number_slides];
int slide_counter = 0;

void setup() {
  // the size of the display window
  size(900, 900); // change the numbers in the the parentheses to change the display size. first number is width, second is height
  // you may also make the display full screen by replacing "size(900,900);" with "fullScreen();"
  
  // List all the available serial ports
  printArray(Serial.list()); // this will print in the console log below, you will see a list of available ports 
  // then check which port number is the USBmodem port and change the number below to match to connect to arduino
  // for me it was 11 so below i set the variable to 11
  serial_port_arduino = 11;
  
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[serial_port_arduino], 9600); // this is where processing decides which serial port to listen to
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(lf);
  myString = null;

  // this is where we are going to load the images for the slides
  // make sure that the files are named accordingly with the proper extensions, i.e. .jpg or .png
  // for example, each file should be named "slide_1.jpg", "slide_2.jpg", "slide_3.jpg", etc.
  // they can be .png or .jpg but just make sure they match the below for loop
  for(int i = 0; i < slides.length; i++){           // this line loops through the number of slides and loads and loads the image below
      slides[i] = loadImage("slide_"+(i+1)+".jpg"); // make sure the extension in the quotes matches your file(.jpg or .png)
      slides[i].resize(width, height);              // change the size of the images to match the size of the sketch window
  }
}

void draw() {
  //background(255);
  while (myPort.available() > 0) {         // just making sure that we are receiving data from arduino
    myString = myPort.readStringUntil(lf); // reading the data from arduino here
    if (myString != null) {                // if the incoming data is not empty, let's see what that incoming data equals
      value = int(trim(myString));         // save the incoming data in a variable called value
      
      if(value!=prevValue){                // check the value of the incoming data 
        slide_counter++;                   // and if the value has changed, increase the slide_counter by 1
        if(slide_counter>=slides.length){  // if the slide_counter becomes larger than the number_slides
          slide_counter = 0;               // set the slide_counter back to 0
        }
        prevValue = value;                 // then set the prevValue to value to prepare for the next button press
      }
      
      image(slides[slide_counter], 0, 0);  // show the slide with the value of the incoming data
                                           // so, if the button has not been pressed the incoming data
                                           // will be 0 and the image shown will be slides[0]
                                           // which is the first address in the slides array
                                           // each time the button is pressed the number goes up by 1
                                           // meaning the next slide would be slides[1] then slides[2]
                                           // and so on until the end is reached and resets to slides[0]


            
    }
  }
}
```
Once you have copied the Processing code above into the sketch and dropped the slides onto your sketch, you should be able to run the sketch,
get data from the Arduino, and change the slides in succession as the button is pressed.

