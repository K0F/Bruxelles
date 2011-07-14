/**
*  functions .. some helpful functions for parsing
*/

void parseVals(){
  // initiate empty ArrayList
  records = new ArrayList(0);

  // this is our counter .. set it to 0
  int cntr = 0;
  
  // now loop trough all raw lines of text
  // skip lines to get lower resolution
  for (int i = 0 ; i < data.length ; i += resolution) {

    // and split into pieces by this pattern ...
    String[] tmp = splitTokens(data[i], "{,}\":"); 

    // check the lenght of values
    if (tmp.length == 21) {

      // now get the values from pieces 
      float exttemp = parseFloat(tmp[1]);
      float exthumid = parseFloat(tmp[3]);
      float temp1 = parseFloat(tmp[5]);
      float temp2 = parseFloat(tmp[7]);
      float coretemp = parseFloat(tmp[9]);
      float corevolt = parseFloat(tmp[11]);
      float humid = parseFloat(tmp[13]);
      float co2 = parseFloat(tmp[15]); 

      // timestamp is in String format .. bit of dirty parsing
      String timestamp = tmp[16] + ", " + tmp[17] + 
        ":" +tmp[19] + ":" + tmp[20];


      /* add .. adds an element into ArrayList new Record
       is our class .. our object where we can store the informations */

      //records.add(new Record(cntr , exttemp , exthumid ));

      records.add(new Record(cntr, exttemp, exthumid, temp1, temp2, coretemp, corevolt, humid, co2, timestamp));


      /* add one to our counter so we can keep track of what number
       we are curently operating */
      cntr++;


      // if values are not the length we want print error
    }
    else {

      if (debug)  
        println("Got some weird thigs here: " + tmp.length);
    }
  } 
  
}
