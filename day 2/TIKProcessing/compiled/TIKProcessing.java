import processing.core.*; 
import processing.xml.*; 

import org.jivesoftware.smack.filter.*; 
import org.jivesoftware.smackx.provider.*; 
import org.jivesoftware.smackx.pubsub.util.*; 
import org.jivesoftware.smackx.muc.*; 
import org.jivesoftware.smackx.search.*; 
import org.jivesoftware.smack.util.collections.*; 
import org.jivesoftware.smackx.bytestreams.socks5.*; 
import org.jivesoftware.smackx.bytestreams.ibb.*; 
import org.jivesoftware.smackx.workgroup.agent.*; 
import org.jivesoftware.smackx.pubsub.listener.*; 
import org.jivesoftware.smackx.workgroup.packet.*; 
import org.jivesoftware.smack.proxy.*; 
import org.jivesoftware.smack.provider.*; 
import org.jivesoftware.smackx.commands.*; 
import org.jivesoftware.smackx.filetransfer.*; 
import org.jivesoftware.smack.*; 
import org.jivesoftware.smackx.workgroup.util.*; 
import org.jivesoftware.smackx.packet.*; 
import org.jivesoftware.smackx.bytestreams.ibb.packet.*; 
import org.jivesoftware.smackx.workgroup.ext.forms.*; 
import org.jivesoftware.smackx.bytestreams.*; 
import org.jivesoftware.smackx.workgroup.*; 
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
import org.jivesoftware.smackx.bytestreams.ibb.provider.*; 
import org.jivesoftware.smackx.workgroup.ext.history.*; 
import org.jivesoftware.smackx.bytestreams.socks5.provider.*; 
import org.jivesoftware.smack.sasl.*; 
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

/**
TIK Processing bridge by Isjtar, Jan 2011. Adapted from Christian Liljedahl.
Add smack.jar and smackx.jar to your project Sketch -> Add file...  You will need the nightly builds.
Refactor into Class
*/

int redColor = 255;
//String receivedMsg = "";

// newChat has to be declared global. If not, the MessageListener will time out after 30 seconds. Processing does this, for some reason. 
// i think he has this problem because the var got garbage collected
// test this with class!!
 Chat newChat;

class TIK
// Tik Class, wraps XMPP functions from the Smack API into easy TIK object
{ 
	//define vars
	String server = "walls.okno.be";
	String user = "inventor@walls.okno.be";
	String password = "04990499";
	Chat chat;
	String receivedMsg; 
	
	// constructor
	TIK()
	{
		//copy args to vars		
		/*server = server;
		user = user;
		password = password;*/
		chat = this.connect();
	}

	// connect to server, account shouldn't matter as we'll be using the TIK client protocol
 	public Chat connect() //maybe should provide the possibility to reconnect with different server and user
	{
		//store chat object to return
		Chat chat;
		ChatManager chatmanager;
		ConnectionConfiguration config;
		XMPPConnection connection;
		
	  // This is the connection to xmpp 
		config = new ConnectionConfiguration(server, 5222);
		config.setSASLAuthenticationEnabled(false);
		connection = new XMPPConnection(config);

	  	try 
	  	{
	    	connection.connect();
	  	} 
	  	catch (XMPPException e1) 
	  	{
			e1.printStackTrace();
	  	}

	 	try 
	 	{
	    	// we log in  
	    	connection.login("inventor@walls.okno.be", "password"); 
	 	} 

	  	catch (XMPPException e1) 
		{
	   		print("no connect");
	   		e1.printStackTrace(); 
	    }

	  	// It would be pretty to do some sort of test here, to make sure we are connected.
	  	chatmanager = connection.getChatManager();

	  	// Eventhandler, to catch incoming chat events
		//this is just an account I made up on the server, shouldn't matter in the end
	  	chat = chatmanager.createChat("adeepblackhole@walls.okno.be", new MessageListener() 
		{
	    	public void processMessage(Chat chat, Message message) 
			{
	      		// Here you do what you do with the message
				// maybe some form of callback function would be nice to get asynchronous messages coming in instead of ju storing in received msg
	      		receivedMsg = message.getBody();
	      		// debug print
	      		println(receivedMsg);
	    	}
	   	}
	  	);
		
		return chat;
	}

	//method for sending messages to the server
	public void send(String sendMsg)
	{
		try
		{
			chat.sendMessage(sendMsg);
		}
	    catch (XMPPException e1) 
		{
	    	println(e1.getXMPPError()); 
	  	}
	}		
}



public void setup() 
{
  	size(300, 300);
	noStroke();
  	background(0.1f);
  	TIK tik = new TIK();
	tik.send("test");
  
}

public void draw() 
{
   	fill(redColor, 100 , 100);
   	text(tik.receivedMsg, 30, 45);          
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "TIKProcessing" });
  }
}
