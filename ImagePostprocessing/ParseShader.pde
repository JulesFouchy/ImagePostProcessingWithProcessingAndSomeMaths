void parseShader(String filepath){
  ArrayList<UniformFloat> oldUniforms = uniforms;
  uniforms = new ArrayList<UniformFloat>();
  float sliderX = 50;
  float sliderY = 50;
 BufferedReader reader = createReader(filepath);
 String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] m1 = match(line, "uniform.*");
      if( m1 != null ){
        m1 = splitTokens(m1[0], " ,;");
        String name = m1[2];
        //println("|"+m1[2]+"|");
        String[] comment = match(line, "//.*");
        //
        if( comment != null ){
          float minVal = 0, maxVal = 0, valeur = 0;
          String[] words = splitTokens( comment[0] );
          for( int k = 0; k < words.length; ++k ){
            if( words[k].equals("min") ){
              minVal = float(words[k+1]);
              k++;
            }
            else if( words[k].equals("max") ){
              maxVal = float(words[k+1]);
              k++;
            }
            else if( words[k].equals("default") ){
              valeur = float(words[k+1]);
              k++;
            }
          }
          int i = findUniform( name, oldUniforms);
          UniformFloat uni;
          if( i>-1){
            uni = oldUniforms.get(i);
            uni.minVal = minVal;
            uni.maxVal = maxVal;
          }
          else{
            uni = new UniformFloat(name, valeur, minVal, maxVal, new PVector(sliderX, sliderY));
          }
          uniforms.add(uni);
          sliderY += 50;
          if( sliderY > height - window.imgPlusCurveH - 50 ){
            sliderY = 50;
            sliderX += uni.sliderW + 100;
          }
        }
      }
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  } 
}

int findUniform(String name, ArrayList<UniformFloat> unifs){
  for( int k = 0; k < unifs.size(); ++k ){
    if( unifs.get(k).name.equals(name) ){
      return k;
    }
  }
  return -1;
}
