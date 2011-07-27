import processing.core.*; 
import processing.xml.*; 

import com.thoughtworks.xstream.converters.javabean.*; 
import com.thoughtworks.xstream.converters.collections.*; 
import org.jivesoftware.smack.filter.*; 
import org.jivesoftware.smackx.provider.*; 
import com.thoughtworks.xstream.annotations.*; 
import org.jivesoftware.smackx.pubsub.util.*; 
import org.jivesoftware.smackx.muc.*; 
import org.jivesoftware.smackx.search.*; 
import org.jivesoftware.smack.util.collections.*; 
import org.jivesoftware.smackx.bytestreams.socks5.*; 
import com.thoughtworks.xstream.io.path.*; 
import com.thoughtworks.xstream.io.json.*; 
import org.jivesoftware.smackx.bytestreams.ibb.*; 
import org.jivesoftware.smackx.workgroup.agent.*; 
import org.jivesoftware.smackx.pubsub.listener.*; 
import org.jivesoftware.smackx.workgroup.packet.*; 
import org.jivesoftware.smack.proxy.*; 
import com.thoughtworks.xstream.persistence.*; 
import com.thoughtworks.xstream.converters.*; 
import org.jivesoftware.smack.provider.*; 
import com.thoughtworks.xstream.io.copy.*; 
import com.thoughtworks.xstream.converters.enums.*; 
import org.jivesoftware.smackx.commands.*; 
import org.jivesoftware.smackx.filetransfer.*; 
import org.jivesoftware.smack.*; 
import com.thoughtworks.xstream.core.util.*; 
import org.jivesoftware.smackx.workgroup.util.*; 
import com.thoughtworks.xstream.converters.extended.*; 
import org.jivesoftware.smackx.debugger.*; 
import com.thoughtworks.xstream.converters.reflection.*; 
import org.jivesoftware.smackx.packet.*; 
import com.thoughtworks.xstream.converters.basic.*; 
import com.thoughtworks.xstream.io.*; 
import org.jivesoftware.smackx.bytestreams.ibb.packet.*; 
import org.jivesoftware.smackx.workgroup.ext.forms.*; 
import com.thoughtworks.xstream.io.xml.*; 
import org.jivesoftware.smackx.bytestreams.*; 
import com.thoughtworks.xstream.mapper.*; 
import org.jivesoftware.smackx.workgroup.*; 
import com.thoughtworks.xstream.io.binary.*; 
import com.jcraft.jzlib.*; 
import org.jivesoftware.smackx.pubsub.*; 
import org.jivesoftware.smackx.*; 
import org.jivesoftware.smackx.pubsub.provider.*; 
import org.jivesoftware.smackx.pubsub.packet.*; 
import org.xmlpull.v1.*; 
import org.jivesoftware.smackx.workgroup.ext.notes.*; 
import org.jivesoftware.smack.debugger.*; 
import org.jivesoftware.smackx.workgroup.user.*; 
import org.jivesoftware.smack.packet.*; 
import org.jivesoftware.smackx.workgroup.settings.*; 
import org.jivesoftware.smackx.bookmark.*; 
import org.jivesoftware.smack.util.*; 
import com.thoughtworks.xstream.io.xml.xppdom.*; 
import com.thoughtworks.xstream.core.*; 
import org.jivesoftware.smackx.bytestreams.ibb.provider.*; 
import com.thoughtworks.xstream.alias.*; 
import org.jivesoftware.smackx.workgroup.ext.history.*; 
import org.jivesoftware.smackx.bytestreams.socks5.provider.*; 
import org.jivesoftware.smack.sasl.*; 
import com.thoughtworks.xstream.*; 
import org.jivesoftware.smackx.bytestreams.socks5.packet.*; 
import org.xmlpull.mxp1.*; 
import org.jivesoftware.smackx.workgroup.ext.macros.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class TIKProcessing extends PApplet {

/* 
 * This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; version 2 of the License.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *  
 */

/*
  Processing test client subscribing to all nodes and listening to TIKS
  using Smack Library 3.1.0 nightly build (includes pubsub service)
  see http://www.igniterealtime.org/projects/smack/documentation.jsp
  https://svn.igniterealtime.org/svn/repos/smack/trunk/documentation/extensions/pubsub.html
 */
 
TIK tik;
Map<String,Integer> clockList = new HashMap<String,Integer>();  //keep track of clocks and tiks
int y = 60;

class TIK
// Tik Class, wraps XMPP functions from the Smack API into easy TIK object
{ 
  //define static vars
  String server = "walls.okno.be";
  String user = "tester@walls.okno.be";
  String password = "tester";

  //define XMPP objects
  ConnectionConfiguration config;
  XMPPConnection connection;
  PubSubManager manager;

  TIK()
  {
    config = new ConnectionConfiguration(server, 5222);
    //config.setSASLAuthenticationEnabled(true); //throws an error, set to true?
    config.setSelfSignedCertificateEnabled(true);
    connection = new XMPPConnection(config);
  }

  // connect to XMPP server   
  public void connect(){ 
    try 
    {
      connection.connect();
      text("connected", 10, 20);
      // we log in  
      connection.login(user, password);
      //connection.loginAnonymously();  //error on openfire prevents subscription of anonymous users
      text("logged in as "+connection.getUser(), 10, 30);
    } 
    catch (XMPPException e1) 
    {
      print("connection error:");
      e1.printStackTrace();
    }
    
    //open connection pubsub service
    manager = new PubSubManager(connection, "pubsub." + server);
  }

  //get list of clocks from pubsub and subscribe to them
  public void getClocks()
  {      
    try {
      DiscoverItems items = manager.discoverNodes(null);
      Iterator<DiscoverItems.Item> it = items.getItems();

      while (it.hasNext()) {
        DiscoverItems.Item item = it.next();
        clockList.put(item.getNode(),new Integer(0));
        println("Clock found:"+item.getNode());

        //subscribe to every node
        subscribe(item.getNode());
      }
    } 
    catch(XMPPException e1) {
      System.out.println("retrieving nodes failed:");
      e1.printStackTrace();
    }
  }

  //subscribe to node and listen to published TIKS
  public void subscribe(String clockId)
  {		
    try 
    {
      //retrieve nodes
      Node clock = manager.getNode(clockId);
      ItemEventListener myEventHandler = new ItemEventListener<PayloadItem>() 
      {
        // listen to new TIKS
        public void handlePublishedItems(ItemPublishEvent<PayloadItem> subNode) 
        {
          // parse TIKS we receive
          String tikEvent = subNode.getItems().toString();
          println("new tik:"+tikEvent);
          String clockId = tikEvent.substring(tikEvent.indexOf("<id>")+4,tikEvent.indexOf("</id>"));
          String tiks = tikEvent.substring(tikEvent.indexOf("<tiks>")+6,tikEvent.indexOf("</tiks>"));
          //keep track of them with clocklist
          clockList.put(clockId, Integer.parseInt(tiks));
        }
      }; 
      clock.addItemEventListener(myEventHandler);
      clock.subscribe(connection.getUser());
      println("subscribed to "+clockId);
    }
    catch (XMPPException e1)
    {
      println("xmpp error: "+e1.getXMPPError());
    }
  }
}

public void setup() 
{
  size(500, 500);
  background(0);
  fill(255, 100, 100);

  tik = new TIK();
  //connect to TIK server
  tik.connect();
  //subscribe to all nodes on XMPP pubsub service  
  tik.getClocks();
}

public void draw() {
  background(0);
  
  // print all clocks to screen
  Set set = clockList.entrySet();
  Iterator i = set.iterator();
  int pos = 0;
  
  while(i.hasNext()){
    Map.Entry me = (Map.Entry)i.next();
    text(me.getKey()+": "+me.getValue(),10,20+15*pos);
    pos++;
  }
}


    static public void main(String args[]) {
        PApplet.main(new String[] { "--bgcolor=#ECE9D8", "TIKProcessing" });
    }
}
