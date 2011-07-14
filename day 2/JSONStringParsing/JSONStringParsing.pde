
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
int resolution = 40;

float lowTemp = 20;
float highTemp = 40;


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
  
  smooth();
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
    float temp = map(r.temp1, lowTemp, highTemp, 0, width/2);
    float temp2 = map(r.temp2, lowTemp, highTemp, 0, width/2);
    
    // the same for humidity
    float humid1 = map(r.humid, 20, 100, 0, width/2);
    float humid2 = map(r.exthumid, 20, 100, 0, width/2);

    // end external temperature and level of co2
    float exttemp = map(r.exttemp, lowTemp, highTemp, 0, width/2);   
    float co2 = map(r.co2, 190, 300, 0, width/2);


    // first circle
    stroke(255,127,30 ,160);
    makeCircle( time , temp , temp2 );
    
    // second circle
    stroke(127,255,30, 160);
    makeCircle( time , humid1, humid2 );
   
    // third circle
    stroke(30,255,127, 160);
    makeCircle( time , exttemp, co2 );
  }
}


// keypressed function is run whenewer you press a key
void keyPressed(){
  
 // if the key you pressed is an " " emtyspace = space button run the code below
 if( key == ' ' ){
   
    // save dumps the actual sketch into image.. in uses fileformat you define in extension
    save("images/screenshot.png");
 }
 
}

// our funtion to create the circle
void makeCircle(float _time, float _value){
  
    float X = cos( _time + HALF_PI ) * _value + width/2;
    float Y = sin( _time + HALF_PI ) * _value + height/2;

    point(X,Y); 
}


// the same function with more parameters wiil start circle made of lines
void makeCircle(float _time, float _value1, float _value2){
  
    float X1 = cos( _time + HALF_PI ) * _value1 + width/2;
    float Y1 = sin( _time + HALF_PI ) * _value1 + height/2;

    float X2 = cos( _time + HALF_PI ) * _value2 + width/2;
    float Y2 = sin( _time + HALF_PI ) * _value2 + height/2;

    line(X1,Y1,X2,Y2); 
}

