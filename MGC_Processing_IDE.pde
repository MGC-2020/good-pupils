import processing.serial.*;
import grafica.*;
 
Serial mySerial;
Table table;
String filename;

//table calculations
int startHour;        int startMin;
int hr = 0;           int min = 0;
int ArrayCount = 71;       int startTime;
int time;

int[] nearArray = {0,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,0,1,1,1,1,2};     
int[] lightArray = {40,45,46,65,813,914,1340,1789,219,727,3308,9290,45410,53683,18751,85,40,41,38,2565,2690,2637,2659,1976,2995,2089,1667,1457,2105,5866,4912,1771,3304,1298,3872,1914,2937,1772,4769,11385,25809,26501,2075,620,4055,610,3681,782,438,124,5126,1582,2260,2098,10166,3119,4861,2095,2830,1051,1085,1523,17550,11541,18186,10216,6802,11680,5013,6876,54,0}; 
int[] timeArray;
int[] nearMins;

//Get system time
int y = year();       int m = month();        int d = day();
int h = hour();       int n = minute();       int s = second();

//communication
String status = "null";
char counterCommand = 'c';
char nearCommand = 'a';
char lightCommand = 'b';

//formatting variables
int section; //page of app
int rectX, rectY; //position of button  
int rectW, rectH; //size of button

int messX, messY; //position of textbox
int messW, messH; //size of textbox

//graphs
GPlot nearPlot, lightPlot;

color baseColor, highlight, textColor;


//runonce for webui
boolean webuiLaunched = false;

void setup()
{  
  size(1500, 700);
  
  //initalise at page 1
  section = 1;
  
  //setting up button
  rectW = 150;                rectH = 50;
  rectX = width/2 - rectW/2;  rectY = 50+(height/3);
  
  //setting up text box
  messW = width;                messH = 50;
  messX = width/2 - messW/2;    messY = height/10;
  
  //set up colors
  baseColor = color(180);     highlight = color(220);
  textColor = color(0);
  
  //set up bluetooth comms
  //mySerial = new Serial(this, "COM7", 9600);
  //mySerial.clear(); //clear the serial buffer
 
  //set up table
  table = new Table();
  table.addColumn("Time");
  table.addColumn("Near?");
  table.addColumn("Light Intensity");
  
  //set up data arrays
  //nearArray = new int[288];
  //lightArray = new int[288];
  timeArray = new int[288];
  
  //set up graphs
  nearPlot = new GPlot(this);
  nearPlot.setPos(50, 25);
  nearPlot.setDim(600, 600);
  //nearPlot.setXLim(0, 2400);
  //nearPlot.setYLim(0, 1440);
  nearPlot.getTitle().setText("Near Work");
  //nearPlot.getXAxis().getAxisLabel().setText("Time");
  nearPlot.getYAxis().getAxisLabel().setText("Mins");
  nearPlot.setPointColor(color(0,0,0,255));
  nearPlot.setPointSize(2);
  
  lightPlot = new GPlot(this);
  lightPlot.setPos(750, 25);
  lightPlot.setDim(600, 600);
  //lightPlot.setXLim(0, 2400); // this makes it ugly sia
  lightPlot.getTitle().setText("Luminance");
  //lightPlot.getXAxis().getAxisLabel().setText("Time");
  lightPlot.getYAxis().getAxisLabel().setText("Mins");
  lightPlot.setPointColor(color(0,0,0,255));
  lightPlot.setPointSize(2);
  
  //Command arduino to start
  //mySerial.write("start");
  //delay(1000);
    
  //record startTime
  startHour = h;              startMin = n;
  String paddedStartHour = String.format("%02d", startHour);
  String paddedStartMin = String.format("%02d", startMin);
  
  startTime = parseInt(paddedStartHour+paddedStartMin);
  
  println("program started, startTime is " + startTime);
  
  timeArray[0] = startTime;
  
}

void draw()
{
  if (section == 1) //get data page
  {
    background(255);
    
    fill(textColor);
    String message = "EyeDreamscape";
    textSize(40);
    textAlign(CENTER);
    text(message, messX, messY, messW, messH);
    
    String message1 = "Hi jerome you need to press saveData for the graphs, getData does nth";
    textSize(15);
    textAlign(CENTER);
    text(message1, messX, messY+50, messW, messH);
    
    fill(baseColor);
    rect(rectX, rectY-60, rectW, rectH);
  
    String buttonText1 = "Get Data";
    fill(textColor);
    textSize(28);
    textAlign(CENTER);
    text(buttonText1, rectX, rectY+5-60, rectW, rectH);
    
    fill(baseColor);
    rect(rectX, rectY, rectW, rectH);
  
    String buttonText2 = "Save Data";
    fill(textColor);
    textSize(28);
    textAlign(CENTER);
    text(buttonText2, rectX, rectY+5, rectW, rectH);
    
    //if (mySerial.available() > 0)
    //{
    //  delay(100);
    //  String arduinoMessage = mySerial.readString();
    //  println("Arduino: " + arduinoMessage);
    //}
    
    
    if (rectX < mouseX && mouseX < (rectX + rectW) && (rectY - 60) < mouseY && mouseY < (rectY + rectH - 60))
    { 
      fill(highlight);
      rect(rectX, rectY-60, rectW, rectH);
      fill(textColor);
      textSize(28);
      textAlign(CENTER);
      text(buttonText1, rectX, rectY+5-60, rectW, rectH);
      
      if (mousePressed)
      {
        println("Getting data..."); 
        //mySerial.clear(); //clear the serial buffer
        
        
        //println("Status0 : " + status);
        
        //mySerial.write(counterCommand);
        delay(2000);
        
        //if (mySerial.available()>0) 
        //{
        //  delay(1000);
        //  ArrayCount = mySerial.available();
        //  println("ArrayCount is " + ArrayCount);
        //  status = "timeReceived";
        //}
         
        //println("Status1 : " + status);
        
        //nearArray = obtain("near");
        
        //println("Status2 : " + status);
        
        //lightArray = obtain("light");
        
        //println("Status3 : " + status);
        
        println("Final status: " + status);
        println("End of data collection");
        println("Awaiting Save Data...");
      }
    }
    
    if (rectX < mouseX && mouseX < (rectX + rectW) && rectY < mouseY && mouseY < (rectY + rectH))
    { 
      fill(highlight);
      rect(rectX, rectY, rectW, rectH);
      fill(textColor);
      textSize(28);
      textAlign(CENTER);
      text(buttonText2, rectX, rectY+5, rectW, rectH);
      
      if (mousePressed)
      {
        delay(500);
        getTimeArray();
        println("Press space to process data");
    //    fillTable();
      }
    }
  }  
  
  if (section == 2) //graph page
  {
    GPointsArray nearPoints = new GPointsArray(288);
    GPointsArray lightPoints = new GPointsArray(288);
    
    for (int i=0; i<ArrayCount; i++)
    {
      nearPoints.add ( timeArray[i], nearArray[i] );
      lightPoints.add( timeArray[i], lightArray[i] );
    }
    
    // I was trying to get like an incremental graph to show total nearMins from start till that time but somehow the hourArray is screwed up

    //nearMins = getNearMins(); //sum up the nearMins in each hour
    //int[] hourArray = new int [23];
    //for (int i=0; i<23; i++) //get corresponding hour
    //{
    //  time = startTime - startTime%100;
    //  hourArray[i] = time;
    //  time += 100;
    //  if (time == 2400)
    //    {time = 0;}
    //}
    
    //for (int i=0; i<nearMins.length; i++)
    //  nearPoints.add( hourArray[i], nearMins[i] );
    
    
    background(255);
    
    nearPlot.setPoints(nearPoints);
    nearPlot.beginDraw();
    nearPlot.drawBackground();
    nearPlot.drawBox();
    nearPlot.drawXAxis();
    nearPlot.drawYAxis();
    nearPlot.drawTitle();
    nearPlot.drawGridLines(GPlot.BOTH);
    nearPlot.drawPoints();
    nearPlot.drawLines();
    nearPlot.endDraw();
    
    lightPlot.setPoints(lightPoints);
    lightPlot.beginDraw();
    lightPlot.drawBackground();
    lightPlot.drawBox();
    lightPlot.drawXAxis();
    lightPlot.drawYAxis();
    lightPlot.drawTitle();
    lightPlot.drawGridLines(GPlot.BOTH);
    lightPlot.drawPoints();
    lightPlot.drawLines();
    lightPlot.endDraw();
    
    fill(textColor);
    String message = "Your Progress Today";
    textSize(40);
    textAlign(CENTER);
    text(message, messX, 0, messW, messH);
  }
  
  if (section == 3)
  {
    background(255);
    
    fill(textColor);
    String message = "Progress Summary";
    textSize(40);
    textAlign(CENTER);
    text(message, messX, 0, messW, messH);
    
    String label1 = "Total Distance Buzzes: 43";
    textSize(20);
    textAlign(LEFT);
    text(label1, 100, 100, messW, messH);
    
    String label2 = "Total Outdoor Time: 150 mins";
    textSize(20);
    textAlign(LEFT);
    text(label2, 100, 200, messW, messH);
    
    String label3 = "Reduction in near work: 40%";
    textSize(20);
    textAlign(LEFT);
    text(label3, 100, 300, messW, messH);
    
    String label4 = "Improvement in outdoor time: 27%";
    textSize(20);
    textAlign(LEFT);
    text(label4, 100, 400, messW, messH);
  }
  
  if (section == 4)
  {
    background(255);
    
    fill(textColor);
    String message = "Dream Stores";
    textSize(40);
    textAlign(CENTER);
    text(message, messX, 0, messW, messH);
  }
}
    
void getTimeArray() {
  
    int addHour;  int addMin;
    addHour = startHour;
    addMin = startMin;
    
    println("Getting timeArray for " + timeArray[0]);
    for (int i=1; i<ArrayCount; i++) //obtain entire time array
  {
    addMin += 5;
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
    int newTimeStamp = parseInt(paddedAddHour+paddedAddMin);
    timeArray[i] = newTimeStamp;
  }
  
  println("End of getTimeArray");
}       

int[] obtain(String command) {
  
  char Command = nearCommand;
  
  mySerial.clear();
  
  switch (command)
  {
    case "near": Command = nearCommand; break;
    case "light": Command = lightCommand; break;
  }
  mySerial.write(Command); // commands device to send nearArray
  delay(3000);
  
  String dataString;
  String[] dataStringArray = new String[288];
  int[] dataArray = new int[288];
  
  if(mySerial.available() > 0)
  {    
    dataString = mySerial.readString();
    dataStringArray = split(dataString,",");
    
    if(dataStringArray != null) //check to make sure there is a value
    { 
      status += "//" + command + "Received";
      for ( int i = 0; i< ArrayCount; i++)
      {dataArray[i] = parseInt(dataStringArray[i]);}
      
      printArray(dataString);
      println("Function loop status: " + status);
    }  
    else {
      println("No "+ command + " data received");
  }}
  return dataArray;
}
      
void fillTable() { //function not used
  
  for (int i=0 ; i<ArrayCount ; i++) //filling up the table with time, near, light
  {
    //add a new row for each value
    TableRow newRow = table.addRow();
    newRow.setInt("Time", timeArray[i]);
    newRow.setInt("Near?", nearArray[i]);
    newRow.setInt("Light Intensity", lightArray[i]);
  }

  status += "//tableFilled!";
  println("Function loop status: " + status);  
}
int[] getNearMins() {
  
  int[] nearMins = new int[23];
  int time = startTime - startTime%100;
  int sum = 0;
  
  for (int j=0; j<nearMins.length;j++)
  {
    for (int i=0; i<ArrayCount; i++)
    {
      if (time <= timeArray[i] && timeArray[i] < time+100)
        sum += nearArray[i]*5;
    }
    nearMins[j] = sum;
    
    time += 100;
    if (time == 2400)
      time = 0;
  }
  
  return nearMins;
    
}
void keyPressed(){
  
  if (key == ' ') //page forward if space
      {
        section++;
        if (section > 4)
          exit();
      }
      
  if (key == '\b') //page backwards if backspace
    section--;
  
  if (!webuiLaunched) {
    fillTable();
    println("Final status: " + status);
    filename = "MGC_" + str(d) + "-" + str(m) + "-" + str(y)+ "_" + str(h) + "-" + str(n) + "-" + str(s) + ".csv"; //saves table in excel format
    saveTable(table, filename);
    println(filename + " saved!");
    
    launch("cd " + sketchPath("") + " && python run.py");
    link("http://localhost:5000/?csv_file_name="+filename);
  }
}
