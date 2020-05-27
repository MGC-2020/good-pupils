import processing.serial.*;
 
Serial mySerial;
Table table;
String filename;

//table calculations
int startHour;        int startMin;
int hr = 0;           int min = 0;
int ArrayCount;

String[] nearArray;  String[] lightArray;  String[] timeArray;
//Get system time
int y = year();       int m = month();        int d = day();
int h = hour();       int n = minute();       int s = second();

//communication
String status = "null";
char counterCommand = 'c';
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
  startHour = h;              startMin = n;
  String paddedStartHour = String.format("%02d", startHour);
  String paddedStartMin = String.format("%02d", startMin);
  //save startTime in arrays
  
  println("program started, startTime is " + paddedStartHour + " " + paddedStartMin);
  
  delay(2000);
  timeArray[0] = paddedStartHour + " " + paddedStartMin;
  
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
        mySerial.write(counterCommand);
        delay(1000);
        if (mySerial.available()>0) {
          ArrayCount = mySerial.available();
          println("ArrayCount is " + ArrayCount);
          getTimeArray ();
          
          printArray(timeArray);
        } 
        else println("ArrayCount not obtained");
          
      //  nearArray = obtain("near");
      //}
        
      //if(status == "nearReceived"); //commands device to send lightArray
      //{
      //  lightArray = obtain("light");
      //}
      //if(status == "lightReceived")
      //{
      //  fillTable("Time", timeArray);
      //  fillTable("Near?", nearArray);
      //  fillTable("Light Intensity", lightArray);
      //  print("Awaiting saveTable...");
      //  delay(20000); //delay 20s to wait for keypress
      }
    }}}
    
void getTimeArray() {
    for (int i=1; i<ArrayCount; i++) //obtain entire time array
  {
    int addHour;  int addMin;
    addHour = startHour;
    addMin = startMin + 5;
    
    //calculating time
    if (addMin >= 60)
    { 
      addMin -= 60;
      addHour ++;
    }
    if (addHour == 24)
      { addHour = 0;}
      
    //save time as formatted string
    String paddedAddHour = String.format("%02d", addHour);
    String paddedAddMin = String.format("%02d", addMin);
    timeArray[i] = paddedAddHour + " " + paddedAddMin;
    
    startHour = addHour;
    startMin = addMin;
  }}       

//String[] obtain(String command) {
  
//  char Command = nearCommand;
//  switch (command)
//  {
//    case "near": Command = nearCommand; break;
//    case "light": Command = lightCommand; break;
//  }
//  mySerial.write(Command); // commands device to send nearArray
//  delay(1000);
  
//  if(mySerial.available() > 0)
//  {
//    String dataString;
//    String[] dataArray;
    
//    dataString = mySerial.readString();
//    dataArray = split(dataString,",");
    
//    if(dataArray != null) //check to make sure there is a value
//    { 
//      status = command + "Received";
//      println(status);
//      return dataArray;
//    }  
//    else {
//      println("No "+ command + " data received");
//      return dataArray;
//  }}}
      
//void fillTable(String tableColumn, String[] dataArray) {
  
//  println("Filling "+ tableColumn);
  
//  for (int i=0 ; i<ArrayCount ; i++) //filling up the table with time & near
//  {
//    //add a new row for each value
//    TableRow newRow = table.addRow();
//    newRow.setString(tableColumn, dataArray[i]);
//  }
//  println(tableColumn + " filled!");
//}


void keyPressed(){
  
  filename = "MGC_" + str(d) + "-" + str(m) + "-" + str(y)+ "_" + str(s) + ".csv"; //saves table in excel format
  saveTable(table, filename);
  exit();
}
