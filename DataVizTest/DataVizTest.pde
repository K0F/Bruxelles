/**
 * Basic parser for TIK server data
 *
 */


XMLElement xml;
ArrayList records;


boolean debug = true;

Parser parser;

String filename = "takserver.log";

void setup(){
    size(1600,900,P2D);


    parser = new Parser(this,filename);

    fill(255);

    textFont(createFont("Monaco",10,false));
    textMode(SCREEN);

}



void draw(){
    background(0);


    for(int i = 0 ; i< records.size();i++){
        Record record = (Record)records.get(i);
        text(record.date + " : "+record.message,10,i*12+20);

    }


}


class Parser{

    PApplet parent;
    XMLElement root;
    String filename;


    Parser(PApplet _parent,String _filename){
        parent = _parent;
        filename = _filename;

        root = new XMLElement(parent, filename);

        records = castRecords();


    }


    ArrayList castRecords(){
        ArrayList reply = new ArrayList(0);

        // XMLElement recData;

        int dataLen = root.getChildCount();

        if(debug)
            println("got some data: "+dataLen+" entries found");

        for(int i = 0 ;i<dataLen;i++){

            String message =  root.getChild(i).getChild("message").getContent();
            String date = root.getChild(i).getChild("date").getContent();
            
           

            reply.add(new Record(date,message,i));
        }


        return reply;
    }


}


class Record{
    int id;
    String date;
    String message;
    int dateMilis;
    int sequence;
    String logger;
    String level;
    String origin;
    int thread;


    Record(String _date,String _message,int _id){
        id = _id;
        
        date = _date;
        message = _message;

    }

}
