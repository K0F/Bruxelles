
/**
 * NONA tick client pro Jiriho a Davida
 */



/////////////////////////////////////////


import jabberlib.*;
import oscP5.*;
import netP5.*;
import processing.xml.*;



/////////////////////////////////////////

String clockName[] = {
  "vortexVaneOkno", "so-onOne"
}; // so-onOne
float maxTime = 5500.0;
float speed = 200.0;


// signals and colors
String signals[] = {
  "a", "b", "c", "d", "e", "f", "g", "h", "i"
};
color c[] = {
  #ffcc00, #FCD613, #FCF813, #D7FC13, #8FFC13, #13FC21
};

String oscRemoteAddress = "10.0.0.141";
int oscRemotePort = 12001;

String tikServerAddress = "tik.okno.be";

/////////////////////////////////////////

Jabber jabber;
OscP5 oscP5;
NetAddress myRemoteLocation;
HashMap<String, ArrayList> clockList = new HashMap<String, ArrayList>();

processing.core.PFont font;



Object[] nodes;

public int timer1[];
public int timer2[];
public float tim[];
public float timS[];


public int [][] windSpeed;



/////////////////////////////////////////

public void setup() {


  // TODO: setup application
  size(1024, 320, P2D);

  frameRate(25);



  //start listening to OSC messages on port 12000
  oscP5 = new OscP5(this, 12000);
  //start OSC service on port 12001
  myRemoteLocation = new NetAddress(oscRemoteAddress, oscRemotePort);

  font = createFont("Monaco", 9, false);
  textMode(SCREEN);

  //login to TAK
  String host = tikServerAddress;
  jabber = new Jabber(this, host, 5222);
  jabber.login("tester@" + host, "tester");
  PubSub pubsub = new PubSub(jabber, "pubsub." + host);

  //get all clocks
  nodes = pubsub.getNodes();

  println("Number of running clients: "+nodes.length);
  int cnt = nodes.length;

  timer1 = new int[cnt];
  timer2 = new int[cnt];
  tim = new float[cnt];
  timS = new float[cnt];
  windSpeed = new int[cnt][width];




  for (int i = 0; i < nodes.length; i++) {
    timS[i] = tim[i] = timer2[i] = timer1[i] = 0;


    for (int ii = 0 ; ii < windSpeed[i].length;ii++) {
      windSpeed[i][ii] = 0;
    }


    String clock = nodes[i].toString();
    clockList.put(clock, new ArrayList());
    cnt++;
    //subscribe to all clocks
    pubsub.subscribeToNode(clock);
  }
}


/////////////////////////////////////////

public void draw() {


  //text(clockList.size(), 10, 10);

  // Get all clocks in a set
  Set clockSet = clockList.entrySet();
  // Create an iterator for the set
  Iterator i = clockSet.iterator();
  int pos = 0;

  while (i.hasNext ()) {
    try { 
      Map.Entry me = (Map.Entry)i.next();
      String clockName = me.getKey().toString();
      ArrayList clockMeta = (ArrayList)me.getValue();

      if (clockMeta.size() > 0) {
        float clockValue = parseFloat(clockMeta.get(0).toString());
        text(clockName+": "+clockMeta, 10, 20+15*pos);
      } 
      else {
        text(clockName + ": undefined", 10, 20+15*pos);
      }
      pos++;
    }
    catch (ConcurrentModificationException e) {
      //exception thrown because of pubsubEvent modifying hashmap
      break;
    }
  }



  /////////////////////////////////////////

  background(0);


  for (int n = 0 ;n< timer1.length;n++) {
    timS[n] += (tim[n]-timS[n])/speed;
    windSpeed[n][frameCount%width] = (int)timS[n];
  }


  for (int n = 0 ; n < timer1.length;n++) {

    for (int x = 1 ;x < windSpeed[n].length;x++) {
      float y = map(windSpeed[n][x], 0, 127, height-10, 10);
      float y1 = map(windSpeed[n][x-1], 0, 127, height-10, 10);




      stroke(c[n], 255-abs(y-y1));
      line(x, y, x-1, y1);
    }


    fill(c[n]);
    text("< -- "+clockName[n]+" - speed:  "+(int)timS[n], frameCount%width, 4+map(windSpeed[n][frameCount%width], 0, 127, height-10, 10));


    send((int)timS[n], n);
  }
}


/////////////////////////////////////////

void send(int _val, int _which) {

  // send Osc messages
  OscMessage clockMessage = new OscMessage("/msg/"+signals[_which]);
  //clockMessage.add(clockName);
  //oscP5.send(clockMessage, myRemoteLocation);
  //OscMessage valueMessage = new OscMessage("/" + clockName);
  clockMessage.add(_val);
  oscP5.send(clockMessage, myRemoteLocation);
}




/////////////////////////////////////////

/**
 * incoming events from subscribed pubsub nodes
 */

public void pubsubEvent(String event) {



  //println("received node event: " + event);
  String xml = event.substring(event.indexOf("<item"), event.indexOf("</item>") + 7);
  String id = event.substring(event.indexOf("<item id='") + 10, event.indexOf("'>"));
  String[] xmllist = {
    xml
  };
  saveStrings("tmp/clockdata" + id + ".xml", xmllist);
  delay(100);

  XMLElement item = new XMLElement(this, "tmp/clockdata" + id + ".xml");



  String cname = item.getChild(0).getString("clockName")+"";

  // get partiluar TICK from one client

  for (int n = 0 ;n < timer1.length;n++) {

    if (cname.equals(clockName[n])) {
      //println("bang");
      timer2[n] = timer1[n];
      timer1[n] = millis();
      tim[n] = constrain(timer1[n]-timer2[n], 0, maxTime);
      tim[n] = map(tim[n], 0, maxTime, 0, 127);
    }
  }


  String itemid = item.getString("id");
  XMLElement clock = item.getChild(0);
  //for (int i = 0; i < clock.getChildCount(); i++) {
  XMLElement tik = clock.getChild(0);

  String idTik = tik.getChild(0).getContent();
  //println(itemid+":"+idTik);    
  //}


  ArrayList clockMeta = new ArrayList();
  clockMeta.add(""+(idTik));
  //has meta values?
  if (tik.getChildCount() > 1) {
    XMLElement values = tik.getChild(1);
    if (values.getName().equals("metaDataValues")) {


      for (int i = 0; i < values.getChildCount(); i++) {
        XMLElement meta = values.getChild(i);
        //println(values.getChildCount()+":"+meta.getChildCount());
        String metaString = meta.getChild(2).getContent();
        //println(metaString);

        metaString += ": " + meta.getChild(0).getContent();
        metaString += " (" + meta.getChild(1).getContent() + ")";

        //timer1[i] = millis();

        clockMeta.add(metaString);
      }
    }
  }
  clockList.put(id, clockMeta);
}

