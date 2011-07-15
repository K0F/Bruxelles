
class TIK
// Tik Class, wraps XMPP functions from the Smack API into easy TIK object
{ 
  //define static vars
  String server = "tik.okno.be";
  String user = "myAccount";
  String password = "secret";
  
  boolean debug = false;

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
  void connect(){ 
    try 
    {
      connection.connect();
      //text("connected", 10, 20);
      // we log in  
      connection.login(user, password);
      //connection.loginAnonymously();  //error on openfire prevents subscription of anonymous users
      //text("logged in as "+connection.getUser(), 10, 30);
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
  void getClocks()
  {      
    try {
      DiscoverItems items = manager.discoverNodes(null);
      Iterator<DiscoverItems.Item> it = items.getItems();

      while (it.hasNext()) {
        DiscoverItems.Item item = it.next();
        //clockList.put(item.getNode(),new Integer(0));
        
        if(debug)
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
  void subscribe(String clockId)
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
          raw.add(tikEvent+"");
          /*
          println("new tik:"+tikEvent);
          String clockId = tikEvent.substring(tikEvent.indexOf("<id>")+4,tikEvent.indexOf("</id>"));
          String tiks = tikEvent.substring(tikEvent.indexOf("<tiks>")+6,tikEvent.indexOf("</tiks>"));
          */
          //keep track of them with clocklist
         
         // clockList.put(clockId, Integer.parseInt(tiks));
        }
      }; 
      clock.addItemEventListener(myEventHandler);
      clock.subscribe(connection.getUser());
      
      if(debug)
      println("subscribed to "+clockId);
    }
    catch (XMPPException e1)
    {
      println("xmpp error: "+e1.getXMPPError());
    }
  }
}
