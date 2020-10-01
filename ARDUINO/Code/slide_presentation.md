#SLIDE PRESENTATION IN PROCESSING USING A BUTTON AND ARDUINO

This example is for using Arduino button presses to advance a slide show presentation in Processing.

Check out the example for hooking up a button to Arduino - [Button Example](http://www.arduino.cc/en/Tutorial/Debounce)

Once you have the button hooked up and working, look at the code below and notice where you can change the number of slides
to match the number of slides in your presentation. At the very top of the code area is a variable called "number_slides" and
this is the number youwould change to match the number of slides. So, right now, it is equal to 4, meaning it will cycle
through four outputs starting with 0(programming concepts involve starting from 0 when establishing an order) and sequentially
increasing up to 3. So, each time the button is pressed, the counter(buttonPressCount) increases by 1 and resets when it passes
the number of slides provided by "number_slides" variable.

Copy and paste this code below into your Arduino editor to upload to the Arduino board. If you need help understanding how to 
do that, check out [Setting Up](./Resources/arduino_setting_up.pdf) or the main introduction page [here](./)

```
const int number_slides = 4; // THIS IS THE NUMBER YOU WILL CHANGE TO MATCH THE NUMBER OF SLIDES. Just change the number!

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
        buttonPressCount++;         // every time the button is pressed the button count increases by 1
      }
    }
  }

if(buttonPressCount>number_slides){ // this is comparing the number of button presses to the number of slides to make a loop
    buttonPressCount = 0;           // so when the button has been pressed more than the number of slides, it resets to 0
  }
  // set the LED:
  digitalWrite(ledPin, ledState);   // this just turns the onboard LED on/off each time the button is pressed(just visual feedback for you)
  Serial.println(buttonPressCount); // this is where the arduino sends the information through the USB to the computer

  // save the reading. Next time through the loop, it'll be the lastButtonState:
  lastButtonState = reading;
  
}
```

After you have successfully modified the code to fit your slide count and uploaded the code to your Arduino, open the Processing software
so we can look for the signal from the Arduino to change our slides. In the code below, there are two things you would need to change.

One is to make sure that the serial port you are trying to read matches the USBmodem port for the Arduino. The variable "serial_port_arduino"
in the Processing code below is set to 11 because that is here my computer registers that USB port. When you runt he sketch for the first time, 
you will see a list of serial ports printed out in the console log at the bottom of the screen below the code. That list will tell you what number
should be in the "serial_port_arduino" variable assignment where mine says "serial_port_arduino=11".

The other is to accommodate the number of slides and you just want it to match the arduino "number_slides" variable, so if "number_slides=4" on the Arduino
then "number_slides" in the Processing sketch should be "number_slides=4".

The trickiest part of all of this is making sure that your files are named correctly and placed in the sketch. You just want to make sure when you
name your files that they match the name in the code. For example, below I have named the files "slide_0.jpg", slide_1.jpg", etc. and you should do the same
just making sure that your extensions are correct whether they are .jpg or .png.

Once you have your files named, you will simply drag and drop them into your sketch.
