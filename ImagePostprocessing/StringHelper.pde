String removeFirstLine(String s){
  boolean startAdding = false;
  String res = "";
  for( int k = 0; k < s.length(); ++k){
    if(startAdding){
      res += s.charAt(k);
    }
    if (s.charAt(k) == '\n'){
      startAdding = true;
    }
  }
  
  return res;
  
}
