import processing.serial.*;
 
Serial mySerial;
Table table;
String filename;

//table calculations
int startHour;
int startMin;
int hr = 0;
int min = 0;
int ArrayCount;

//Get system time
int y = year();
int m = month();
int d = day();
int h = hour();
int n = minute();
int s = second();

//communication
String status = "null";
char nearCommand = 'a';
char lightCommand = 'b';
int haltCommand = 2;
int lineFeed = 10; //10 is ASCII value for line feed character

void setup () {
    
  mySerial = new Serial(this, "COM8", 9600);

  table = new Table();
  table.addColumn("Time");
  table.addColumn("Near?");
  table.addColumn("Light Intensity");
  
  mySerial.clear(); //clear the serial buffer
  mySerial.write("start");
  
  String startCommand=mySerial.readString();
  while ( startCommand != "started" )
  {}
  startHour = h;
  startMin = n;
  
  delay(10000); //delay for 10s to allow time to turn off bluetooth
}

void draw () {
  
  if(status == "null")
  {
    mySerial.write(nearCommand); //repeatedly commands device to send nearArray
    
    if(mySerial.available() > 0)
    {
      byte[] nearArray = new byte[288];
      ArrayCount = mySerial.readBytesUntil(haltCommand, nearArray);
      
      printArray(nearArray);
      
      status = "nearReceived";
      print(status);
      
      if(ArrayCount != 0) //check to make sure there is a value
      {     
        for (int i=0 ; i<ArrayCount ; i++) //filling up the table with time & near
        {
          //add a new row for each value
          TableRow newRow = table.addRow();
          newRow.setString("Time", hr + " " + min);
          newRow.setInt("Near?", nearArray[i]);
    
         }
      }
      else print("No Near data received");
    }
  }
    
  if(status == "nearReceived"); //repeatedly commands device to send lightArray
  {
    mySerial.write(lightCommand);
      
    if(mySerial.available() > 0)
    {
      String lightString;
      String[] lightArray;
      
      lightString = mySerial.readStringUntil(lineFeed);
      lightArray = split(lightString,",");
      
      status = "lightReceived";
      print(status);
    
      if(lightArray != null)
      {
        for (int i=0 ; i<ArrayCount ; i++) //filling up the table with light intensity
        {
          //add a new row for each value
          TableRow newRow = table.addRow();
          newRow.setString("Light Intensity", lightArray[i]);    
        }
      }
      else print("No Light data received");
    }
  }
  if(status == "lightReceived")
  {
    print("Awaiting saveTable...");
    while(true)
    {}
  }
}

void keyPressed(){
  
  filename = "MGC_" + str(d) + "-" + str(m) + "-" + str(y)+ "_" + str(s) + ".csv"; //saves table in excel format
  saveTable(table, filename);
  exit();
}
