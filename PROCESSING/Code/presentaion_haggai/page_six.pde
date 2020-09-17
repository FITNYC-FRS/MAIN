void page_six(){
  proc_url = "https://github.com/FITNYC-FRS/MAIN";
  proc_display = "frs github";
  textSize(100);
  //bg_shade = map(mouseX, 0, width, 0, 255);
  //circ_shade = map(mouseX, 0, width, 255, 0);
  background(bg_shade);
  fill(circ_shade);
  ellipse(mouseX, mouseY, 400, 400);
  cursor(ARROW);

  if (mouseX>width/2-textWidth(proc_display)/2 && mouseY>height/2-100 && mouseX<width/2+textWidth(proc_display)/2 && mouseY<height/2) {
    //background(#f1f1f1);
    fill(0);
    cursor(HAND);
  }
  text(proc_display, width/2, height/2);
  
}
