#define echoPin 4
#define trigPin 3
#define buzzer 6

#define startCommand "start"
#define nearCommand 'a'
#define lightCommand 'b'
#define counterCommand 'c'
#define haltSignal 2 //is this s good choice?

long duration;
int dist;

int nearArray[288];
int counter;

char junk;

void setup() {
  // put your setup code here, to run once:
  
  counter = 0;
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(buzzer, OUTPUT);
  Serial.begin(9600);

  while( Serial.readString() != startCommand)
  {
    Serial.println("not started");
    Serial.println("read: " + Serial.readString());
    delay(2000);
  }

  Serial.print("started");
}

void loop() {
  // put your main code here, to run repeatedly
  delay(1000); //need to adjust until readings are taken every 5 mins
  
  //GET dist
  digitalWrite(trigPin, LOW);
  delay(2);

  digitalWrite(trigPin,HIGH);
  delay(10);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH);
  dist = duration*0.034/2; 

  //GET lInt

  //Corrective actions
  if (dist < 30){
    tone(buzzer, 200);
    delay(200);
    noTone(buzzer);
    nearArray[counter] = 1;
  }
  else nearArray[counter] = 0;

  counter ++; //counter repeats each loop





//Sending data
  if (Serial.available()) // only sends data when signal is received
  { char serialCommand = (char)Serial.read();

    switch (serialCommand)
    { case counterCommand:
      { int i;
        for (i=0 ; i<counter; i++)
        {Serial.print("1");}
        Serial.println();
        delay(1000);
        break;
      }
      case nearCommand: //prints nearArray
      { nearArray[counter] = haltSignal; // note that counter has been incremented after last data point saved
        
        Serial.print(nearArray[0]);
        for (int i=1; i <= counter; i++)
       {  Serial.print(",");
          Serial.print(nearArray[i]);
       }
        delay(1000); //delay to allow printing to complete
       
//       while(Serial.available())
//       {junk = Serial.read(); //clear the serial buffer
//       }
       break;
      }

      case lightCommand: //prints lightArray
      {Serial.println("123,244,035,023,445,034,023,045,645,653");

        delay(1000); //delay to allow printing to complete

//        while(Serial.available())
//         {junk = Serial.read(); //clear the serial buffer
//         }  
       exit(0);
      } 
    }
  }
}

  
 
