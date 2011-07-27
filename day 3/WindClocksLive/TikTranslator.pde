
class TikTranslator {

  XMLElement xml;
  boolean verbose = true;

  int sizeOfData = 0;

  TikTranslator() {
  }


  void update() {

    raw.add("</stream>");

    String tmp = "";
    for (int i = 0 ; i < raw.size() ; i++) {

      String ln = (String)raw.get(i);
      //  println(ln);  

      if (ln.indexOf("<item id=")>-1) {
        ln = ln.substring(ln.indexOf("<item id="), ln.length());
        // println("bang! "+ln);
      }

      if (ln.indexOf("[")>-1) {
        ln = ln.substring(0, ln.indexOf("["));
      }

      if (ln.indexOf("]")>-1) {
        ln = ln.substring(0, ln.indexOf("]"));
      }
      tmp += ln;
    }

    if (verbose)
      println(tmp);
            
      boolean hasEnd = false;

    try {
      xml = XMLElement.parse(tmp);
    }
    catch(Exception e) {
      println("ERROR: "+e);
      raw.remove(raw.size()-1);
      hasEnd = true;
    }
    
    for (int i = 0 ; i < raw.size() ; i++) {
     String templorary = (String)raw.get(i);
     
     println(i);
     
     if(templorary.indexOf("</stream>")>-1){
      raw.remove(i); 
     }
     
    }

    if(!hasEnd)
    raw.remove(raw.size()-1);

    int sizeOfData = xml.getChildCount();
  }
}

