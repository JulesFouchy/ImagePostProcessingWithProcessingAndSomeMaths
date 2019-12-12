class UniformFloat{
  String name;
  float value;
  
  PVector sliderPos;
  float sliderW = 150;
  float sliderH = 15;
  float handleRelPos;
  float minVal;
  float maxVal;
  
  boolean bFollowMouse = false;
  
  float textSize = 15;
  
  UniformFloat(String _name, float _value, float _minVal, float _maxVal, PVector _sliderPos){
    name = _name;
    value = _value;
    minVal = _minVal;
    maxVal = _maxVal;
    sliderPos = _sliderPos;
    handleRelPos = (value - minVal) / (maxVal - minVal);
  }
  
  void set(){
    myShader.set(name, value);
  }
  
  void slider(){
    // Background
    fill(#5B4FE0);
    rect(sliderPos.x, sliderPos.y, sliderW, sliderH);
    // Name and values
    fill(255);
    textAlign(LEFT,TOP);
    textSize(textSize);
      // Name
    text(name + " : ", sliderPos.x, sliderPos.y - textSize-5 );
      // Val
    text(value, sliderPos.x + textWidth(name + " : "), sliderPos.y - textSize-5 );
      // Min val
    text(str(minVal), sliderPos.x - textWidth(str(minVal)) -5, sliderPos.y);
      // Max val
    text(str(maxVal), sliderPos.x + sliderW + 5, sliderPos.y);
    // Handle
    fill(#A19AFA);
    rectMode(CENTER);
    rect(handleCenterX(), handleCenterY(), sliderH, sliderH);
    rectMode(CORNER);
    // Check move
    if( bFollowMouse ){
      handleRelPos = (mouseX - sliderPos.x) / sliderW;
    }
    // Update value
    value = minVal + handleRelPos * (maxVal - minVal);
  }
  
  float handleCenterX(){
    return sliderPos.x + handleRelPos * sliderW;
  }
  
  float handleCenterY(){
    return sliderPos.y + sliderH/2;
  }
  
  void onLeftClicDown(){
    if( (abs(mouseX - (sliderPos.x+sliderW/2)) < sliderW/2 && abs(mouseY - (sliderPos.y+sliderH/2)) < sliderH/2)
     || (abs(mouseX - (sliderPos.x+sliderW*handleRelPos)) < sliderH/2 && abs(mouseY - (sliderPos.y+sliderH/2)) < sliderH/2)){
       bFollowMouse = true;
    }
  }
  
  void onLeftClicUp(){
    bFollowMouse = false;
  }
}
