
/**
 * NONA tick client pro Jiriho a Davida
 */



import jabberlib.*;
import oscP5.*;
import netP5.*;
import processing.xml.*;


Jabber jabber;
OscP5 oscP5;
NetAddress myRemoteLocation;
HashMap<String, ArrayList> clockList = new HashMap<String, ArrayList>();

processing.core.PFont font;

Object[] nodes;

public int timer1;
public int timer2;
public float tim = 0;
public float timS = 0;

public float speed = 30.0f;

public int [] windSpeed;


public void setup() {


  // TODO: setup application
  size(640, 240, P2D);

  frameRate(25);

  windSpeed = new int[width];


  //start listening to OSC messages on port 12000
  oscP5 = new OscP5(this, 12000);
  //start OSC service on port 12001
  myRemoteLocation = new NetAddress("10.0.0.141", 12001);

  font = createFont("Droid Sans Mono", 9, false);
  textMode(SCREEN);

  //login to TAK
  String host = "tik.okno.be";
  jabber = new Jabber(this, host, 5222);
  jabber.login("tester@" + host, "tester");
  PubSub pubsub = new PubSub(jabber, "pubsub." + host);

  //get all clocks
  nodes = pubsub.getNodes();
  int cnt = 0;
  for (int i = 0; i < nodes.length; i++) {
    String clock = nodes[i].toString();
    clockList.put(clock, new ArrayList());
    cnt++;
    //subscribe to all clocks
    pubsub.subscribeToNode(clock);
  }
}

public void draw() {
  // TODO: handle each frame of drawing
  background(0);

  fill(255);

  text(clockList.size(), 10, 10);

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


  timS += (tim-timS)/speed;
  windSpeed[frameCount%width] = (int)timS;

  stroke(255);

  for (int x = 1 ;x < windSpeed.length;x++) {
    float y = map(windSpeed[x], 0, 127, height, 0);
    float y1 = map(windSpeed[x-1], 0, 127, height, 0);
    
    line(x, y, x-1, y1);
  }

  text((int)timS, 20, height-100);

  send((int)timS);
}

void send(int _val) {

  // send Osc messages
  OscMessage clockMessage = new OscMessage("/msg/a");
  //clockMessage.add(clockName);
  //oscP5.send(clockMessage, myRemoteLocation);
  //OscMessage valueMessage = new OscMessage("/" + clockName);
  clockMessage.add(_val);
  oscP5.send(clockMessage, myRemoteLocation);
}



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

      println("bang");
      timer2 = timer1;
      timer1 = millis();
      tim = constrain(timer1-timer2, 0, 2500);
      tim = map(tim, 0, 2500, 0, 127);


      for (int i = 0; i < values.getChildCount(); i++) {
        XMLElement meta = values.getChild(i);
        //println(values.getChildCount()+":"+meta.getChildCount());
        String metaString = meta.getChild(2).getContent();
        metaString += ": " + meta.getChild(0).getContent();
        metaString += " (" + meta.getChild(1).getContent() + ")";

        //timer1[i] = millis();

        clockMeta.add(metaString);
      }
    }
  }
  clockList.put(id, clockMeta);
}


