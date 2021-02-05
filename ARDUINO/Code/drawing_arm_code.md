# DRAWING ARM ARDUINO WITH PROCESSING SERIAL INPUT

This project is about connecting an Arduino and receiving data from the mouse position to move two servo motors(arms) to "draw" what the mouse is drawing when it is pressed.

In order for this to work, you will need to copy the ARDUINO CODE below and paste it into a blank Arduino project. Then you will upload the code onto the Arduino by connecting the Arduino with your computer by USB cable. When uploading to the Arduino, make sure the settings are in place for your specific board and that you are uploading through the proper port which is the USBmodem port on your computer.

Next check out the [diagram](wiring_diagram_servos_LED.png) to see how things should be connected. The "base" motor should be connected to PIN 9. The "elbow" motor should be connected to PIN 10. And the LED/magnet should be connected to PIN 13. Follow the wiring in the diagram and if you need further help just let me know.

Once you have successfully loaded the code onto the Arduino, you will move to the Processing part. Copy and paste the PROCESSING CODE below into a blank Processing sketch, save it, and then run it byt pressing the 'play' button at the top of the editor. Once the sketch is running and the Arduino is connected properly(check the Serial port declaration part in the Processing code), you should see a small window open up where you can "draw" with the mouse when you press the mouse button on your trackpad. Two things should happen if everything is hooked up properly.

1. The LED/magnet should turn on when the mouse is pressed
2. The arms(servo motors) should move around to the approximate position relative to the size of the drawing window

If either of these does not happen, check the [diagram](wiring_diagram_servos_LED.png) on how to hook it up and make sure the wires are snug enough to create the connections.

If you are getting any errors when you run the code for Arduino or Processing, let me know and we can troubleshoot.

Good luck and have fun!

ARDUINO CODE

```
// two slashes like this is what is called a comment
// anything written after it is NOT read by the computer

// these two lines include libraries for the servo and some math
#include <Servo.h>
#include <Math.h>

// below we are declaring two Servo(s): myservo_1, myservo_2
// this lets us use the Servo library commands on two servos
Servo myservo_1, myservo_2;

// these are the variables for the computation of the math
// to get angles for the elbow and base angles
// you do not need to do anything with them 
float hyp,
      hyp_angle,
      outer_angle,
      inner_angle,
      base_angle,
      elbow_angle;

// this variable called "command" is where we receive the two angles and magnet(true/false)
String command;

// this variable is used to turn the magent on and off
boolean magnet = false;

// this variable is used to set the arm angles when the sketch starts
boolean set = false;

// this setup part runs ONLY one time to establish which PINs we are using
void setup() {
  // the two lines below are setting the motors attached to PIN 9 and 10
  myservo_1.attach(9);
  myservo_2.attach(10);
  
  // the line below starts a serial connection to receive info from Processing
  Serial.begin(115200);
  
  // LED for testing magnet boolean(true/false)
  // you will hook up the magnet to the same PIN #13 on the Arduino
  pinMode(13, OUTPUT);
  // this line turns the LED/magnet off to begin
  digitalWrite(13, LOW);

}


// the loop below runs continuously to accept data from Processing and 
// make things move around and turn on/off
void loop() {

  // this sets the motors to a start position
  if (!set) {
    myservo_1.writeMicroseconds(500);
    myservo_2.writeMicroseconds(1500);
    set = true;
  }


  // here we are checking to see if there is a connection through the USB
  // and if so, we are parsing the data into three parts (base_angle, elbow_angle, and magnet)
  // this all happens down at the bottom in the part called parseCommand()
  if (Serial.available()) {
    
    char c = Serial.read();

    if (c == '\n') {
      parseCommand(command);
      command = "";
    } else {
      command += c;
    }
  }

  // once we have parsed the incoming data from Processing
  // we start by checking to see if the magnet is on(true) or off(false)
  // this says, "if magnet is true, then..."
  if(magnet){
      //turn on the LED/magnet
      digitalWrite(13, HIGH);
     
    } else {
      // if magnet is false, turn off the LED/magnet
      digitalWrite(13, LOW);
     
    }
      
  // these two lines give the arms the angles from Processing
  myservo_1.write(base_angle);
  myservo_2.write(elbow_angle);
    
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
  
  
  // here we are checking to see if the mouse is being pressed
  if (mousePressed) {
    // if the mouse is pressed we want to:
    // turn on the magnet
    magnet = true;
    
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
 
  // this just prints out in the console at the bottom of the Processing sketch
  println(to_arduino);

}

```
