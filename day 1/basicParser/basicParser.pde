/**
 * Basic Parser, day 1
 */

float myValues[];
float myValues2[];
String data[];

void setup() {
  size(400, 400);

  data = loadStrings("data.txt");

  println("number of values stored: "+data.length);

  myValues = new float[data.length];
  myValues2 = new float[data.length];


  for ( int i = 0 ; i < data.length ; i = i + 1 ) {
    myValues[i] = 0;
    myValues2[i] = parseFloat( data[i] );
  }  

  //rect( firstNumber , 10 , 10 , 10 );
}

void draw() {

  background(0); 

  for ( int i = 0 ; i < data.length ; i++ ) {
    
    myValues[i] += (myValues2[i]-myValues[i]) / 300.0;
    
    rect( myValues[i], i, 3, 3 );
  }
}

