import processing.serial.*;
 
Serial mySerial;
Table table;
String filename;

//table calculations
int startHour;        int startMin;
int hr = 0;           int min = 0;
int ArrayCount;

//Get system time
int y = year();       int m = month();        int d = day();
int h = hour();       int n = minute();       int s = second();

//communication
String status = "null";
char nearCommand = 'a';
char lightCommand = 'b';
int haltCommand = 2;
int lineFeed = 10; //10 is ASCII value for line feed character

//formatting variables
int rectX, rectY; //position of button  
int rectW, rectH; //size of button

int messX, messY; //position of textbox
int messW, messH; //size of textbox

color baseColor, highlight, textColor;

void setup()
{
  size(250,180);
  
  //setting up button
  rectW = 150;                rectH = 50;
  rectX = width/2 - rectW/2;  rectY = 40+(height/3);
  
  //setting up text box
  messX = width/10;           messY = height/5;
  messW = 200;                messH = 50;
  
  //set up colors
  baseColor = color(180);     highlight = color(220);
  textColor = color(0);
  
  //set up bluetooth comms
  mySerial = new Serial(this, "COM8", 9600);
  mySerial.clear(); //clear the serial buffer
 
  //set up table
  table = new Table();
  table.addColumn("Time");
  table.addColumn("Near?");
  table.addColumn("Light Intensity");
  
  //Command arduino to start
  mySerial.write("start");
  delay(1000);
  
  String startCommand=mySerial.readString();
  if(mySerial.available() > 0)
  {
    print(startCommand);
  }
  
  //record startTime
  startHour = h;
  startMin = n;
  String paddedStartHour = String.format("%02d", startHour);
  String paddedStartMin = String.format("%02d", startMin);
  println("program started, startTime is " + paddedStartHour + " " + paddedStartMin);
  
  //delay(1000); //delay for 10s to allow time to turn off bluetooth
  
}

void draw()
{
  background(200);
  
  fill(textColor);
  String message = "Good Pupils App";
  textSize(20);
  textAlign(CENTER);
  text(message, messX, messY, messW, messH);
  
  fill(baseColor);
  rect(rectX, rectY, rectW, rectH);
  
  String buttonText = "Get Data";
  fill(textColor);
  textSize(32);
  textAlign(CENTER);
  text(buttonText, rectX, rectY+5, rectW, rectH);
  
  if (rectX < mouseX && mouseX < (rectX + rectW) && rectY < mouseY && mouseY < (rectY + rectH))
  { 
    fill(highlight);
    rect(rectX, rectY, rectW, rectH);
    fill(textColor);
    textSize(32);
    textAlign(CENTER);
    text(buttonText, rectX, rectY+5, rectW, rectH);
    
    if (mousePressed)
    {
      print("Getting data..."); 
      mySerial.clear(); //clear the serial buffer
      
      if(status == "null")
  {
    mySerial.write(nearCommand); // commands device to send nearArray
    delay(1000);
    
    if(mySerial.available() > 0)
    {
      print(mySerial.available());
      ArrayCount = (mySerial.available()-1)/2;
      println("ArrayCount is " + ArrayCount);
      
      String nearString;
      String[] nearArray;
      
      nearString = mySerial.readString();
      nearArray = split(nearString,",");
      
      
      if(nearArray != null) //check to make sure there is a value
      { 
        status = "nearReceived";
        println(status);
        
        for (int i=0 ; i<ArrayCount ; i++) //filling up the table with time & near
        {
          //add a new row for each value
          TableRow newRow = table.addRow();
          newRow.setString("Time", hr + " " + min);
          newRow.setString("Near?", nearArray[i]);
    
         }
      }
      else println("No Near data received");
    }
  }
    
  if(status == "nearReceived"); //repeatedly commands device to send lightArray
  {
    mySerial.write(lightCommand);
    delay(1000);
      
    if(mySerial.available() > 0)
    {
      print(mySerial.available());
      String lightString;
      String[] lightArray;
      
      lightString = mySerial.readStringUntil(lineFeed);
      lightArray = split(lightString,",");
      
      if(lightArray != null)
      {
        status = "lightReceived";
        print(status);
    
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
    delay(20000); //delay 20s to wait for keypress
  }
}
    }
  }
