
class Record {

  int id;
  float exttemp;
  float exthumid;
  float temp1;
  float temp2;
  float coretemp;
  float corevolt;
  float humid;
  float co2;
  String timestamp;

  /*
  constructor 1 (int,float,float)
  */
  
  Record(int _id, float _exttemp, float _exthumid) {
    exttemp = _exttemp;
    exthumid = _exthumid;
  }

  /*
  contructor 2
  (int,float,float,float,float,float,float,float,float,String)
  */
  
  Record(int _id, 
  float _exttemp, 
  float _exthumid, 
  float _temp1, 
  float _temp2, 
  float _coretemp, 
  float _corevolt, 
  float _humid, 
  float _co2, 
  String _timestamp)
  {
    id = _id;
    exttemp = _exttemp;
    exthumid = _exthumid;
    temp1 = _temp1;
    temp2 = _temp2;
    coretemp = _coretemp;
    corevolt = _corevolt;
    humid = _humid;
    co2 = _co2; 
    timestamp = ""+_timestamp;
  }
}

