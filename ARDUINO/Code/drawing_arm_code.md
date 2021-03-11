# DRAWING ARM ARDUINO WITH PROCESSING SERIAL INPUT

This project is about connecting an Arduino and receiving data from the mouse position to move two servo motors(arms) to "draw" what the mouse is drawing when it is pressed.

In order for this to work, you will need to copy the ARDUINO CODE below and paste it into a blank Arduino project. Then you will upload the code onto the Arduino by connecting the Arduino with your computer by USB cable. When uploading to the Arduino, make sure the settings are in place for your specific board and that you are uploading through the proper port which is the USBmodem port on your computer.

Next check out the [diagram](wiring_diagram_servos_LED.png) to see how things should be connected. The "base" motor should be connected to PIN 9. The "elbow" motor should be connected to PIN 10. And the LED/magnet should be connected to PIN 13. Follow the wiring in the diagram and if you need further help just let me know.

Once you have successfully loaded the code onto the Arduino, you will move to the Processing part. Copy and paste the PROCESSING CODE below into a blank Processing sketch, save it, and then run it by pressing the 'play' button at the top of the editor. Once the sketch is running and the Arduino is connected properly(check the Serial port declaration part in the Processing code), you should see a small window open up where you can "draw" with the mouse when you press the mouse button on your trackpad. Two things should happen if everything is hooked up properly.

1. The LED/magnet should turn on when the mouse is pressed
2. The arms(servo motors) should move around to the approximate position relative to the size of the drawing window

If either of these does not happen, check the [diagram](wiring_diagram_servos_LED.png) on how to hook it up and make sure the wires are snug enough to create the connections.

If you are getting any errors when you run the code for Arduino or Processing, let me know and we can troubleshoot.

Good luck and have fun!

ARDUINO CODE

```
// two slashes like this is what is called a comment
// anything written next to it is NOT read by the computer

#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>

// called this way, it uses the default address 0x40
Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver();

// Depending on your servo make, the pulse width min and max may vary, you 
// want these to be as small/large as possible without hitting the hard stop
// for max range. You'll have to tweak them as necessary to match the servos you
// have!
#define SERVOMIN  150 // This is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX  440 // This is the 'maximum' pulse length count (out of 4096)
#define USMIN  600 // This is the rounded 'minimum' microsecond length based on the minimum pulse of 150
#define USMAX  2400 // This is the rounded 'maximum' microsecond length based on the maximum pulse of 600
#define SERVO_FREQ 50 // Analog servos run at ~50 Hz updates

// our servo # counter
uint8_t servonum = 0;

float base_angle, elbow_angle;

String command;

boolean magnet = false;

float pulselength_base, pulselength_elbow;

float potentiometer_reading = 0;

int increment = 1;

void setup() {
  Serial.begin(115200);

  pwm.begin();
  pwm.setOscillatorFrequency(27000000);
  pwm.setPWMFreq(SERVO_FREQ);  // Analog servos run at ~50 Hz updates

  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
  pinMode(A0, INPUT);
  
  
  delay(10);

  
}


void loop() { 

   if (Serial.available()) {
    
    char c = Serial.read();

    if (c == '\n') {
      parseCommand(command);
      command = "";
    } else {
      command += c;
    }
  }

  pulselength_base = map(base_angle, 0, 180, SERVOMIN, SERVOMAX);
  pulselength_elbow = map(elbow_angle, 0, 180, SERVOMIN, SERVOMAX);
  
  // once we have parsed the incoming data from Processing
  // we start by checking to see if the magnet is on(true) or off(false)
  // this says, "if magnet is true, then..."
  if(magnet){
      //turn on the LED/magnet
      digitalWrite(13, HIGH);
      
      // these two lines give the arms the angles from Processing
      pwm.setPWM(0,0,pulselength_base);
      pwm.setPWM(1,0,pulselength_elbow);
      
    } else {
      // if magnet is false, turn off the LED/magnet
      digitalWrite(13, LOW);
     
    }

  
    
  potentiometer_reading = analogRead(A0);
  potentiometer_reading = map(potentiometer_reading, 0, 1023, SERVOMIN, SERVOMAX);
  pwm.setPWM(3,0,potentiometer_reading);

}


// this is a function that takes the data from Processing
// and parses it into three parts
// base_angle, elbow_angle, and magnet
// you don't have to do anything with this at all
void parseCommand(String com) {
  String part1;
  String part2;
  String part3;

  part1 = com.substring(0, com.indexOf(" "));
  part2 = com.substring(com.indexOf(" ")+1, com.lastIndexOf(" "));
  int bool_loc = com.lastIndexOf(" ") + 1;
  part3 = com.substring(bool_loc, com.indexOf("\n"));

  elbow_angle = part1.toInt();
  base_angle = part2.toInt();
  if(part3 == "true"){
    magnet = true;
  } else {
    magnet = false;
    }
  
}
```

PROCESSING CODE
```
// again, this(two slashes) is how you make a comment 
// that the computer will NOT read
// this is importing the Serial library so we can send data to Arduino
import processing.serial.*;

// this is declaration of the myPort variable
Serial myPort;

// here we are declaring the variables for the math conversions
// of x and y into angles
int adj_mousex, adj_mousey;
float xpos, ypos, elbow_x, elbow_y;

float hyp, 
  hyp_angle, 
  outer_angle, 
  inner_angle, 
  base_angle, 
  elbow_angle, 
  draw_angle;

float inner_arm = 9; // the length of the shoulder
float outer_arm = 9; // the length of the elbow

// this is a true/false variable for the magnet/LED
boolean magnet = false;

// setup ONLY runs once
// we establish variables and drawing canvas size
void setup() {

  // size is how we set the size of the window we are drawing with the mouse
  // the two numbers are width and height and you can make them whatever if you 
  // want a bigger mouse draw window
  size(500, 300);
  
  
  
  // the line below is the line you would 'uncomment'(remove the two slashes)
  // to find the USB port that the Arduino is using
  //printArray(Serial.list());
  
  // once you have the [n] address where n is the serial port for the USBmodem
  // just make sure the line below has that number in the brackets where "11" is right now
  // these two lines will cause an error if you are not connected to the arduino OR
  // if you are trying to connect to the wrong serial port
  myPort = new Serial(this, Serial.list()[11], 115200);
  myPort.clear();
  
  // this sets the background color
  background(255); // set to white at 255
  
  // this sets the stroke and fill to black
  // change these to change the color of the mouse draw
  stroke(0);
  fill(0);

}

void draw() {

  
  
  
  // here we are checking to see if the mouse is being pressed
  if (mousePressed) {
  // if the mouse is pressed we want to:
      // turn on the magnet
       magnet = true;
    
      // everything down to line 203 is math conversion stuff
      hyp = sqrt(sq(xpos) + sq(ypos));
      hyp_angle = asin(xpos / hyp);
      //println("hyp_angle: " + degrees(hyp_angle));
  
      inner_angle = acos((sq(hyp) + sq(inner_arm) - sq(outer_arm)) / (2 * hyp * inner_arm));
      //println("inner_angle: " + degrees(inner_angle));
  
      outer_angle = acos((sq(inner_arm) + sq(outer_arm) - sq(hyp)) / (2 * inner_arm * outer_arm));
      //println("outer_angle: " + degrees(outer_angle));
  
      elbow_angle = (PI - outer_angle);
      base_angle = abs(hyp_angle - inner_angle);

      base_angle = int(degrees(base_angle));
      elbow_angle = int(degrees(elbow_angle));
    
      // and get x,y coordinates to convert to angles
      xpos = map(mouseX, 0, width, -15, 15);
      ypos = map(mouseY, 0, height, 15, 0);
    
      // draw a line where the mouse is moved while being pressed
      line(mouseX, mouseY, pmouseX, pmouseY);
    
  } else {
  
      // if the mouse is not being pressed
      // we turn the magnet off
      magnet = false;
  }

  // this part converts the math angles into a string to send to the Arduino
  String to_arduino = str(elbow_angle) + ' ' + str(base_angle) + ' ' + magnet;
  
  // this part send the data out the USB to the Arduino
  myPort.write(to_arduino + "\n");
 
  // this just prints out the string that is sent to the Arduino in the console at the bottom of the Processing sketch
  println(to_arduino);

}

```
