ArrayList raw;
TIK tik;
PFont font;
TikTranslator translator;


int len = 0;

void setup(){
  size(640,480);
  
  translator = new TikTranslator();
 
  raw = new ArrayList();
  raw.add("<stream>");
 
  tik = new TIK();
  //connect to TIK server
  tik.connect();
  //subscribe to all nodes on XMPP pubsub service  
  tik.getClocks(); 
 
  font = loadFont("DejaVuSans-9.vlw");
  textFont(font);
  
}

void draw(){

  background(0);
  
  fill(255);
  
  if(frameCount % 120 == 0){
    translator.update();
  }
  
  text(translator.sizeOfData,20,20);
  
  for(int i = 0 ; i < raw.size(); i++){
    String tmp = (String)raw.get(i);
  }

}
