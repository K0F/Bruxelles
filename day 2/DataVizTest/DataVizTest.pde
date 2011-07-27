/**
 * Basic parser for TIK server data
 *
 */

XMLElement xml;

ArrayList records;

boolean debug = true;

Parser parser;

String filename = "smalltak.log";

float startTime;

void setup() {
  size(1600, 900, P2D);


  parser = new Parser(this, filename);
  startTime = parser.getStart();
  parser.toZero();

  println(startTime);


  fill(255);

  textFont(createFont("Monaco", 10, false));
  textMode(SCREEN);
}



void draw() {
  background(0);



  int cnt = 0;
  for (int i = 0 ; i< records.size();i++) {
    Record tmp = (Record)records.get(i);

    if (tmp.message.indexOf("TIK_SUCCESS")>-1) {


      text( tmp.date + " : " + tmp.milis, 10, cnt * 12 + 20 );
      cnt++;
    }
  }
}


class Parser {

  PApplet parent;
  XMLElement root;
  String filename;


  Parser(PApplet _parent, String _filename) {
    parent = _parent;
    filename = _filename;

    root = new XMLElement(parent, filename);

    records = castRecords();
  }



  float getStart() {

    float lowNumber = MAX_FLOAT;

    for (int i = 0 ;i<records.size();i++) {
      Record tmp = (Record)records.get(i);

      lowNumber = min( lowNumber, tmp.milis );
    }

    return lowNumber;
  }


  void toZero() {
    for (int i = 0 ;i<records.size();i++) {
      Record tmp = (Record)records.get(i);
      tmp.milis = tmp.milis - startTime;
    }
  }




  ArrayList castRecords() {
    ArrayList reply = new ArrayList(0);

    // XMLElement recData;

    int dataLen = root.getChildCount();

    if (debug)
      println("got some data: "+dataLen+" entries found");



    ArrayList clients = new ArrayList();

    for (int i = 0 ;i<dataLen;i++) {


      String message =  root.getChild(i).getChild("message").getContent();
      String date = root.getChild(i).getChild("date").getContent();
      String miliseconds = root.getChild(i).getChild("millis").getContent();

      miliseconds = miliseconds.substring( 6, miliseconds.length() );
    }

    for (int i = 0 ;i<dataLen;i++) {

      String message =  root.getChild(i).getChild("message").getContent();
      String date = root.getChild(i).getChild("date").getContent();
      String miliseconds = root.getChild(i).getChild("millis").getContent();

      miliseconds = miliseconds.substring( 6, miliseconds.length() );




      reply.add(new Record(date, message, miliseconds, i));
    }


    return reply;
  }
}


class Record {
  int id;
  String date;
  String message;
  int dateMilis;
  int sequence;
  String logger;
  String level;
  String origin;
  int thread;
  float milis;


  Record(String _date, String _message, String _milis, int _id) {
    id = _id;

    milis = parseFloat(_milis);
    date = _date;
    message = _message;
  }
}

