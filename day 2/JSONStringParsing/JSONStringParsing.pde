/**
 *   JSoN bruteforce parsing
 * {"exttemp":19,"exthumid":69,"temp1":29.75,"temp2":25.19,"coretemp":48375,"corevolt":4855,"humid":58,"co2":190,"timestamp":"Tue, 12 Jul 2011 22:00:02 GMT"}
 */
 
import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam cam;

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
int resolution = 80;

float lowTemp = 20;
float highTemp = 40;

float maxValTemp1 = 0;
float minValTemp1 = MAX_FLOAT;

float maxValTemp2 = 0;
float minValTemp2 = MAX_FLOAT;


void setup() {
  // set size of canvas, third parameter is for renderer
  // P2D .. is accelerated 2d renderer for processing
  size( 400, 400, P3D );
  
  cam = new PeasyCam( this , width/2, height/2 , 0 , 400 );
  cam.setMinimumDistance( 200 );
  cam.setMaximumDistance( 1000 );


  // load data from website
  data = loadStrings(url); 

  // and print their actual length 
  println(data.length);

  // and call our parsing function
  parseVals();

  //smooth();

  for (int i = 0 ; i < records.size(); i++) {

    // get current record to operate with
    Record r = (Record)records.get(i);

    maxValTemp1 = max(maxValTemp1, r.temp1);
    minValTemp1 = min(minValTemp1, r.temp1);

    maxValTemp2 = max(maxValTemp2, r.temp2);
    minValTemp2 = min(minValTemp2, r.temp2);
  }

  lowTemp = min(minValTemp1, minValTemp2);
  highTemp = max(maxValTemp1, maxValTemp2);

  if (debug) {
    println("lowest value temp1 : "+ minValTemp1  +" highest value temp1: " + maxValTemp1);
    println("lowest value temp2: "+ minValTemp2 +" highest value temp2: " + maxValTemp2);
  }
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
    float time = map(i, 0, records.size(), -PI , PI );
    // map value from record on y axis
    float temp1 = map(r.temp1, lowTemp, highTemp, 0, width/2);
    float temp2 = map(r.temp2, lowTemp, highTemp, 0, width/2);

    // the same for humidity
    float humid1 = map(r.humid, 40, 90, 0, width/2);
    float humid2 = map(r.exthumid, 40, 90, 0, width/2);

    // end external temperature and level of co2
    float exttemp = map(r.exttemp, 10, 40, 0, width/2);   
    float co2 = map(r.co2, 0, 310, 0, width/2);

    // first circle
    float difTemp = (temp1 - temp2);
    stroke(127,255,10 , 100 );
    makeCircle( time, temp1, temp2 , 100 );


    // second circle
    float difHum = (humid1 - humid2);
    stroke(255,127,10, 100);
    makeCircle( time, humid1, humid2 , 0);


    //third circle
    stroke(255, 10, 10, 100);
    makeCircle( time, exttemp, co2 , -100 );
  }
  
}


// keypressed function is run whenewer you press a key
void keyPressed() {

  // if the key you pressed is an " " emtyspace = space button run the code below
  if ( key == ' ' ) {

    // save dumps the actual sketch into image.. in uses fileformat you define in extension
    saveFrame("images/screenshot####.png");
  }
}

// our funtion to create the circle
void makeCircle(float _time, float _value) {

  float X = cos( _time + HALF_PI ) * _value + width/2;
  float Y = sin( _time + HALF_PI ) * _value + height/2;

  point(X, Y);
}


// the same function with more parameters wiil start circle made of lines
void makeCircle(float _time, float _value1, float _value2) {

  float X1 = cos( _time + HALF_PI ) * _value1 + width/2;
  float Y1 = sin( _time + HALF_PI ) * _value1 + height/2;

  float X2 = cos( _time + HALF_PI ) * _value2 + width/2;
  float Y2 = sin( _time + HALF_PI ) * _value2 + height/2;

  line(X1, Y1, 30, X2, Y2 ,30);
}


// the same function with more parameters wiil start circle made of lines
void makeCircle(float _time, float _value1, float _value2, float _shift) {

  float X1 = cos( _time + HALF_PI ) * _value1 + width/2;
  float Y1 = sin( _time + HALF_PI ) * _value1 + height/2;

  float X2 = cos( _time + HALF_PI ) * _value2 + width/2;
  float Y2 = sin( _time + HALF_PI ) * _value2 + height/2;

  line(X1, Y1, _shift, X2, Y2 ,_shift);
}

