**Processing Receiving Serial Data From Arduino**


In order these steps must be taken for this to work:
1. Follow the directions to hookup a button and upload the [arduino_usb_processing](/arduino_usb_processing) code.
2. You **MUST** have your Arduino connected up to your computer through a USB cable for this to work!
3. Copy and paste the code below into an empty Processing sketch.
4. Run the Processing sketch.

Now you should be able to press the button on your Arduino hookup and see the display change from "on/off" everytime you press the button.

```

import processing.serial.*;

int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port
int value = 0;
int prevValue = 0;

void setup() {
  size(200, 200);
  // List all the available serial ports
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[11], 9600);
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(lf);
  myString = null;

  textSize(24);
  fill(0);
  textAlign(CENTER);
}

void draw() {
  //background(255);
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(lf);
    if (myString != null) {
      value = int(trim(myString));
      println(value);


      if (value == 0) {
        background(255, 0, 0);
        text("off", width/2, height/2);
      } else {
        background(0, 255, 0);
        text("on", width/2, height/2);
      }      
    }
  }
}
```
