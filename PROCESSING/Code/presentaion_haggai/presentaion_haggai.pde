boolean [] pages = new boolean[8];
boolean middle = false;
boolean shapes = true;

String proc_url;
String proc_display;

float bg_shade = map(mouseX, 0, width, 0, 255);
float circ_shade = map(mouseX, 0, width, 255, 0);

void setup(){
  size(1200,800);
  
  for(int i = 0; i < pages.length; i++){
    pages[i] = false;
  }
  
  pages[0] = true;
}

void draw(){
  if(pages[0]){
    page_zero();
  } else if(pages[1]){
    page_one();
  }else if(pages[2]){
    page_two();
  }else if(pages[3]){
    page_three();
  }else if(pages[4]){
    page_four();
  }else if(pages[5]){
    page_five();
  } else if(pages[6]){
    page_six();
  } else if(pages[7]){
    page_seven();
  }
}

void keyPressed(){
  if(key == '1'){
    for(int i = 0; i < pages.length; i++){
    pages[i] = false;
  }
  pages[1] = true;
  }
  
  if(key == '2'){
    for(int i = 0; i < pages.length; i++){
    pages[i] = false;
  }
  pages[2] = true;
  }
  
  if(key == '3'){
    for(int i = 0; i < pages.length; i++){
    pages[i] = false;
  }
  pages[3] = true;
  }
  
  if(key == '4'){
    for(int i = 0; i < pages.length; i++){
    pages[i] = false;
  }
  pages[4] = true;
  }
  
  if(key == '5'){
    for(int i = 0; i < pages.length; i++){
    pages[i] = false;
  }
  pages[5] = true;
  }
  
  if(key == '6'){
    for(int i = 0; i < pages.length; i++){
    pages[i] = false;
  }
  pages[6] = true;
  }
  
  if(key == '7'){
    for(int i = 0; i < pages.length; i++){
    pages[i] = false;
  }
  pages[7] = true;
  }
  
}

void mouseReleased(){
  if(pages[0]){} else {
  if(mouseX>width/2-textWidth(proc_display)/2 && mouseY>height/2-100 && mouseX<width/2+textWidth(proc_display)/2 && mouseY<height/2)link(proc_url);
  }
}
