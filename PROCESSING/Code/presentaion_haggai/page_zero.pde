void page_zero(){
  float dist_center = dist(mouseX, mouseY, width/2, height/2);
  if (dist_center < 200) {
    background(#f1f1f1);
    stroke(0);
    middle = true;
    if (mousePressed) {
      shapes = false;
    }
  } else {
    background(0);
    stroke(#f1f1f1);
    middle = false;
    if (mousePressed) {
      shapes = true;
    }
  }
  strokeWeight(4);
  noFill();
  rectMode(CENTER);
  textAlign(CENTER);
  textSize(300);
  float wave = sin(frameCount*0.01)*400;

  ellipse(width/2, height/2, 400, 400);
  if (shapes) {

    rect(width/2- wave, height/2, 400, 400);
    pushMatrix();
    noFill();
    translate(width/2 + wave, height/2);

    float x1 = 0;
    float y1 = -200;

    float x2 = 200;
    float y2 = 200;

    float x3 = -200;
    float y3 = 200;

    triangle(x1, y1, x2, y2, x3, y3);
    popMatrix();
  } else {

    if (middle) {
      fill(0);
    } else {
      fill(#f1f1f1);
    }
    text("DYNAMIC", width/2 - wave, height/2);
    text("DESIGN", width/2 + wave, height - 180);
  }
  
}
