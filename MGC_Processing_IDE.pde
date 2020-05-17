import processing.serial.*;
 
Serial mySerial;
Table table;
String filename;

// startTime

int hr = 0;
int min = 0;

void setup () {
  
  mySerial = new Serial(this, "COM8", 9600);

  table = new Table();
  table.addColumn("Time");
  table.addColumn("Near?");
  
  //mySerial.write("hi");
}

void draw () {
  
  String dataString;
  
  if(mySerial.available() > 0)
  {
    //set the value recieved as a String
    dataString = mySerial.readString();
    String[] data = split(dataString,",");
    
    print(dataString);
    printArray(data);
    
    //check to make sure there is a value
    if(data != null)
    {
      print("data is found");
      
      for (int i=0;i < data.length; i++) 
      {
        //add a new row for each value
        TableRow newRow = table.addRow();
        newRow.setString("Time", hr + " " + min);
        newRow.setString("Near?", data[i]);
  
       }
    }
  }
}

void keyPressed(){
  int y = year();
  int m = month();
  int d = day();
  int s = second();
  
  filename = "MGC_" + str(d) + "-" + str(m) + "-" + str(y)+ "_" + str(s) + ".csv";
  saveTable(table, filename);
  exit();
}
