
/**
 *   JSoN bruteforce parsing
 * {"exttemp":19,"exthumid":69,"temp1":29.75,"temp2":25.19,"coretemp":48375,"corevolt":4855,"humid":58,"co2":190,"timestamp":"Tue, 12 Jul 2011 22:00:02 GMT"}
 */

// URL to datafile
// "http://isjtar.org/hoursOfHive.txt";

String url = "hoursOfHive.txt";


// Array container for our raw data
String data[];

// our inner format of records stored in ArrayList
ArrayList records;

// verbosity of error messages
boolean debug = true;

// set our resolution
int resolution = 20;

void setup() {
  // set size of canvas, third parameter is for renderer
  // P2D .. is accelerated 2d renderer for processing
  size(400, 400, P2D);

  // load data from website
  data = loadStrings(url); 

  // and print their actual length 
  println(data.length);
  
  // and call our parsing function
  parseVals();
}

// draw something here
void draw() {
  
  // background black
  background(255);

  // loop troght our records
  for (int i = 0 ; i < records.size(); i++) {
    
    // get current record to operate with
    Record r = (Record)records.get(i);


    // get x coordinate
    float time = map(i, 0, records.size(), -PI, PI);
    // map value from record on y axis
    float temp = map(r.temp1, 20, 37, 0, width/2);
    float temp2 = map(r.temp2, 20, 37, 0, height/2);

    stroke(0,15);
    
    
    makeCircle2( time , temp , temp2 );
    

  }
}



void makeCircle(float _time, float _value){
  
    float X = cos( _time + HALF_PI ) * _value + width/2;
    float Y = sin( _time + HALF_PI ) * _value + height/2;

    point(X,Y); 
}



void makeCircle2(float _time, float _value1, float _value2){
  
    float X1 = cos( _time + HALF_PI ) * _value1 + width/2;
    float Y1 = sin( _time + HALF_PI ) * _value1 + height/2;

    float X2 = cos( _time + HALF_PI ) * _value2 + width/2;
    float Y2 = sin( _time + HALF_PI ) * _value2 + height/2;

    line(X1,Y1,X2,Y2); 
}

