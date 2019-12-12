class Window{
  float W;
  float H;
  float ratio;
  
  float imgW;
  float imgPlusCurveW;
  float imgPlusCurveH;
  float limRatio;
  
  PVector imTopLeftUV = new PVector(0,0);
  float imScale = 1;
  
  PShape quad;
  
  PGraphics saveBuffer;
  PShape saveQuad;
  
  Window( String imgFilepath ){
    // Window size
    W = width;
    H = height;
    ratio = W/H;
    // Load image
    PImage img = loadImage(imgFilepath);
    saveBuffer = createGraphics(img.width, img.height, P2D);
    // Get ratio
    float imgPlusCurveRatio = (float(img.width+img.height))/img.height;
    limRatio = float(img.height)/(img.width+img.height);
    // Fit quad size inside window
    if( imgPlusCurveRatio > ratio ){
      imgPlusCurveW = W;
      imgPlusCurveH = W / imgPlusCurveRatio;
      if( imgPlusCurveH > height - 150 ){
        float r = imgPlusCurveH / (height - 150);
        imgPlusCurveH /= r;
        imgPlusCurveW /= r;
      }
    }
    else{
      imgPlusCurveH = height*0.8;
      imgPlusCurveW = imgPlusCurveH * imgPlusCurveRatio;
    }
    imgW = imgPlusCurveW * (1-limRatio);
    // Gen quad
    textureMode(NORMAL);
    quad = createShape();
    quad.beginShape(TRIANGLE_STRIP);
    quad.noStroke();
    quad.texture(img);
      quad.vertex(0, height-imgPlusCurveH, 0, 0);
      quad.vertex(imgPlusCurveW, height-imgPlusCurveH, 1, 0);
      quad.vertex(imgPlusCurveW, height, 1, 1);
      //
      quad.vertex(0, height-imgPlusCurveH, 0, 0);
      quad.vertex(imgPlusCurveW, height, 1, 1);
      quad.vertex(0, height, 0, 1);
    quad.endShape();
    //
    saveQuad = createShape();
    saveQuad.beginShape(TRIANGLE_STRIP);
    saveQuad.noStroke();
    saveQuad.texture(img);
      saveQuad.vertex(0, 0, 0, 0);
      saveQuad.vertex(img.width, 0, 1, 0);
      saveQuad.vertex(img.width, img.height, 1, 1);
      //
      saveQuad.vertex(0, 0, 0, 0);
      saveQuad.vertex(img.width, img.height, 1, 1);
      saveQuad.vertex(0, img.height, 0, 1);
    saveQuad.endShape();
  }
  
  void drawImgPlusCurve(){
    // Load and setup shader
    myShader = loadShader("myShader.frag", "myShader.vert");
    if( frameCount%5 == 0 )
      parseShader("myShader.frag");
    myShader.set("limRatio", limRatio);
    myShader.set("imTopLeftU", imTopLeftUV.x);
    myShader.set("imTopLeftV", imTopLeftUV.y);
    myShader.set("imScale", imScale);
    resetShader();
    for( UniformFloat uniform : uniforms ){
      uniform.slider();
      uniform.set();
    }
    myShader.set("applyFunction", !(keyPressed && key == ' ') );
    myShader.set("fullScreenImage", false);
    try{
      shader(myShader);
      // Draw
      shape(quad);
    }
    catch(Exception e){
      text(removeFirstLine(e.toString()), width*0.2,height/2);
    }
  }
  
  void setImScale( float s ){
    imScale = constrain(s, 0, 1);
    imTopLeftUV.x = constrain(imTopLeftUV.x, 0, 1-imScale);
    imTopLeftUV.y = constrain(imTopLeftUV.y, 0, 1-imScale);
  }
  void setImTopLeftUV( PVector v ){
    imTopLeftUV.x = constrain(v.x, 0, 1-imScale);
    imTopLeftUV.y = constrain(v.y, 0, 1-imScale);
  }
  void zoomOnMouse( float s){
    float prevScale = imScale;
    setImScale( imScale * s );
    PVector dl = (new PVector(mouseX-(imgPlusCurveW-imgW), mouseY-(height-imgPlusCurveH))).mult(prevScale-window.imScale);
    dl.x /= window.imgW; 
    dl.y /= window.imgPlusCurveH;
    translate(dl);
  }
  void translate( PVector v ){
    setImTopLeftUV(PVector.add(imTopLeftUV,v));
  }
  
  void save(){
    println("Saving...") ;
      saveBuffer.beginDraw();
      saveBuffer.shader(myShader);
      myShader.set("fullScreenImage", true);
      saveBuffer.shape(saveQuad);
      saveBuffer.endDraw();
      saveBuffer.save( "EXPORT/"+year()+"_"+month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second()+".jpg") ;
    println("Saved!") ;
  }
}
