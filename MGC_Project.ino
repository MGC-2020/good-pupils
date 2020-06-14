#define DHT11_PIN 4
#define echoPin 8    
#define trigPin 9
#define buzzer 7
#define ledPin 12

#define startCommand "start"
#define nearCommand 'a'   
#define lightCommand 'b'    
#define counterCommand 'c'
#define haltSignal 2

#include <BH1750FVI.h>
#include <SoftwareSerial.h>
#include <dht.h>

dht DHT;

SoftwareSerial BTSerial (10, 11);

long duration;
int dist;
int dataCounter;
boolean nearWork, sendData;
int currentMillis, lastMillis;

BH1750FVI lightSensor;

int nearArray[288];
uint16_t lightArray[288];
int counter;

void setup() {
  // put your setup code here, to run once:
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);
  
  counter = 0;
  dataCounter = 0;
  nearWork = false;
  sendData = false;
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(buzzer, OUTPUT);
  
  BTSerial.begin(9600);
  BTSerial.println("BTSerial started");
  
  lightSensor.begin();
  lightSensor.SetAddress(Device_Address_H);//Address 0x5C
  lightSensor.SetMode(Continuous_H_resolution_Mode);
  BTSerial.println("lightSensor started");

  while( BTSerial.readString() != startCommand)
  {
    BTSerial.println("not started");
    delay(2000);
  }

  BTSerial.println("started");
  digitalWrite(buzzer, HIGH);
  delay(500);
  digitalWrite(buzzer, LOW);

  lastMillis = millis();
}

void loop() {
  // safety feature
  int chk = DHT.read11(DHT11_PIN);
  if (DHT.temperature > 40)
  { 
    digitalWrite(ledPin, LOW);
    exit(0);
  }

  if (sendData == false)
  {
    currentMillis = millis();
    if ( currentMillis - lastMillis > 1000) //need to adjust until readings are taken every 5 mins
    {    
      //GET dist
      digitalWrite(trigPin, LOW);
      delay(2);
      digitalWrite(trigPin,HIGH);
      delay(10);
      digitalWrite(trigPin, LOW);
    
      duration = pulseIn(echoPin, HIGH);
      dist = duration*0.034/2; 
    
      //GET lInt
      uint16_t lux = lightSensor.GetLightIntensity(); 
      lightArray[counter] = lux;
    
       //Corrective actions
      if (dist < 30){
        nearArray[counter] = 1;
        if (nearArray[counter-1] == 1) //buzz if 2 consecutive times
        {
          digitalWrite(buzzer, HIGH);
          delay(100);
          digitalWrite(buzzer, LOW);
          nearWork = true;
        }
       } 
       else 
       {
        nearArray[counter] = 0;
        if (nearArray[counter-1] == 1) //if no consecutive, set previous to 0 too
         {
          if (nearWork == false)
          nearArray[counter-1] = 0;
          else 
          {
            nearWork = false;
          }
         }
       }
    
      counter ++; //counter increments each loop
      if (dataCounter != 0)
        nearArray[dataCounter] = haltSignal;
  
     lastMillis = currentMillis;
    }
  }





//Sending data
  if (BTSerial.available()) // only sends data when signal is received
  {   
    sendData = true;
      char serialCommand = (char)BTSerial.read();
  
      switch (serialCommand)
      { case counterCommand:
        { 
          int i;
          
          if(dataCounter == 0)
          {dataCounter = counter;}
          
          for (i=0 ; i<dataCounter; i++)
          {BTSerial.print("2");}
          nearArray[dataCounter] = haltSignal; // note that counter has been incremented after last data point saved
          delay(1000);
          break;
        }
        case nearCommand: //prints nearArray
        {         
          BTSerial.print(nearArray[0]);
          for (int i=1; i <= dataCounter; i++)
         {  BTSerial.print(",");
            BTSerial.print(nearArray[i]);
         }
         delay(1000); //delay to allow printing to complete
         
         break;
        }
  
        case lightCommand: //prints lightArray
        { 
          BTSerial.print(lightArray[0]);
          for (int i=1; i <= dataCounter; i++)
         {  BTSerial.print(",");
            BTSerial.print(lightArray[i]);
         }
          delay(1000); //delay to allow printing to complete 

          break;
        }
      }
  }  
}

  
 
