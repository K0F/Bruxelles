
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
boolean debug = false;

// set our resolution
int resolution = 20;

void setup() {
  // set size of canvas, third parameter is for renderer
  // P2D .. is accelerated 2d renderer for processing
  size(800, 240, P2D);

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
  background(0);

  // loop troght our records
  for (int i = 0 ; i < records.size(); i++) {
    
    // get current record to operate with
    Record r = (Record)records.get(i);

    // get x coordinate
    float x = map(i, 0, records.size(), 0, width);

    // map value from record on y axis
    float y = map(r.temp1, 15, 40, height, 0);

    stroke(255,40);
    
    // make point
    point(x, y); 

    // map another value .. to axis y
    y = map(r.temp2, 15, 40, height, 0);

    stroke(#FFCC00,30);

    // draw another point
    point(x, y);
  }
}

