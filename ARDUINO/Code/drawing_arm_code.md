# DRAWING ARM ARDUINO WITH PROCESSING SERIAL INPUT

ARDUINO CODE

```
#include <Servo.h>
#include <Math.h>

Servo myservo_1, myservo_2;

float hyp,
      hyp_angle,
      outer_angle,
      inner_angle,
      base_angle,
      elbow_angle;

String command;

boolean magnet = false;
boolean set = false;

void setup() {
  // put your setup code here, to run once:
  myservo_1.attach(9);
  myservo_2.attach(10);
  Serial.begin(115200);
  //Serial.begin(9600);
  
//  myservo_1.write(-90);
//  myservo_2.write(90);
  // LED for testing magnet boolean
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);

}

void loop() {

  if (!set) {
    myservo_1.writeMicroseconds(500);
    myservo_2.writeMicroseconds(1500);
    set = true;
  }

  if (Serial.available()) {
    
    char c = Serial.read();

    if (c == '\n') {
      parseCommand(command);
      command = "";
    } else {
      command += c;
    }
  }

  if(magnet){
      digitalWrite(13, HIGH);
     // Serial.println("on");
    } else {
      digitalWrite(13, LOW);
      //Serial.println("off");
    }
      
  myservo_1.write(base_angle);
  myservo_2.write(elbow_angle);



  // x servo, y sero
//    myservo_1.write(170);
//    myservo_2.write(170);
//    magnet = !magnet;
//    delay(1000);
//    myservo_1.write(90);
//    myservo_2.write(90);
//    magnet = !magnet;
//    delay(1000);
//    myservo_1.write(0);
//    myservo_2.write(0);
//    magnet = !magnet;
//    delay(1000);

   

    
}

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
import processing.serial.*;
Serial myPort;


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

boolean magnet = false;

void setup() {
  size(500, 300);
  background(148);
  //printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[11], 115200);
  myPort.clear();
  //frameRate(1);

  background(255);

  stroke(0);
  fill(0);


  xpos = 4;
  ypos = 10;

}

void draw() {

  //brush.step_horizontal();
  //brush.display_horizontal();


  



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

  if (mousePressed) {
    magnet = true;
    xpos = map(mouseX, 0, width, -15, 15);
    ypos = map(mouseY, 0, height, 15, 0);
    line(mouseX, mouseY, pmouseX, pmouseY);
    //myPort.write(str(elbow_angle)+' '+str(base_angle) + ' ' + magnet + "\n");
  } else {
    magnet = false;
  }


  //myPort.write(str(elbow_angle)+' '+str(base_angle) + "\n");
  String to_arduino = str(elbow_angle) + ' ' + str(base_angle) + ' ' + magnet;
  myPort.write(to_arduino + "\n");
 
  
  println(to_arduino);

  
  
  
  //println("x: " + xpos);
  //println("y: " + ypos);

  println("elbow: " + elbow_angle);
  println("base: " + base_angle);
  println("magnet: " + magnet);
  
  //delay(200);
  //myPort.clear();

  //line(width/2, height, elbow_x, elbow_y);
  //line(elbow_x, elbow_y, mouseX, mouseY);
}

void keyPressed() {
  if (key =='1') {
    xpos = 4;
    ypos = 10;
  }
  if (key == '2') {
    xpos = 8;
    ypos = 8;
  }
  if (key == '3') {
    xpos = -8;
    ypos = 8;
  }
}
```
