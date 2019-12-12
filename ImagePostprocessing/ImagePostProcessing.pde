PShader myShader;
Window window;
UniformFloat power;

PFont font;

ArrayList<UniformFloat> uniforms;

void setup(){
  //fullScreen(P2D);
  size(1300,800, P2D);
  /* --------------- CHOOSE YOUR IMAGE HERE ------------------*/
  window = new Window("img.jpg");
  /* ---------------------------------------------------------*/
  uniforms = new ArrayList<UniformFloat>();
  myShader = loadShader("myShader.frag", "myShader.vert");
  font = loadFont("data/Georgia-Bold-20.vlw");
  textFont(font);
  parseShader("myShader.frag");
}

void draw(){
  background(2);
  window.drawImgPlusCurve();
  if(bDragging){
    PVector dl = PVector.sub(mousePosWhenDragStart, new PVector(mouseX, mouseY)).mult(window.imScale);
    dl.x /= window.imgW; 
    dl.y /= window.imgPlusCurveH;
    window.translate(dl);
    mousePosWhenDragStart = new PVector(mouseX, mouseY);
  }
}

void mousePressed(){
  if( !mouseOverImage() ){
    for( UniformFloat uniform : uniforms ){
      uniform.onLeftClicDown();
    }
  }
  else{
    mousePosWhenDragStart = new PVector(mouseX, mouseY);
    bDragging = true;
  }
}

void mouseReleased(){
    for( UniformFloat uniform : uniforms ){
      uniform.onLeftClicUp();
    }
  bDragging = false;
}

void mouseWheel(MouseEvent e){
  if( mouseOverImage() )
    window.zoomOnMouse(1+0.1*e.getCount());
}

PVector mousePosWhenDragStart;
boolean bDragging = false;

boolean mouseOverImage(){
  return mouseX > window.imgPlusCurveH && mouseY > height - window.imgPlusCurveH;
}

void keyPressed(){
  if( key == 's' ){
    window.save();
  }
}
