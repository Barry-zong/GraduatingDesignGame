const int flexSensorPin = A5; //analog pin 0
const int flexSensorPin2 = A1;
const int flexSensorPin3 = A2;
const int flexSensorPin4 = A3;
const int flexSensorPin5 = A4;

void setup(){
Serial.begin(9600); 

//blink test
//pinMode(LED_BUILTIN, OUTPUT);


/*
const float STRAIGHT_RESISTANCE =285; // L平直时的电阻值       需修改
const float BEND_RESISTANCE =560;    // L180度弯曲时的电阻值  需修改

const float STRAIGHT_RESISTANCEs =615; // s平直时的电阻值       需修改
const float BEND_RESISTANCEs =820;    // s180度弯曲时的电阻值  需修改
*/
}

void loop(){

//digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)
//digitalWrite(LED_BUILTIN, LOW);
  
int flexSensorReading = analogRead(flexSensorPin);
int flexSensorReading2 = analogRead(flexSensorPin2);
int flexSensorReading3 = analogRead(flexSensorPin3);
int flexSensorReading4 = analogRead(flexSensorPin4);
int flexSensorReading5 = analogRead(flexSensorPin5);


     
      //the short one is 612-820
      //the loger one is 285-560
int flex0to100 = map(flexSensorReading, 550, 640, 0, 100);
int flex0to200 = map(flexSensorReading2, 580, 720, 0, 100);
int flex0to300 = map(flexSensorReading3, 540, 650, 0, 100);
int flex0to400 = map(flexSensorReading4, 600, 760, 0, 100);
int flex0to500 = map(flexSensorReading5, 550, 700, 0, 100);


int numbeReads = 15 ;
int senseSum1, senseSum2, senseSum3, senseSum4, senseSum5=0 ;
int delayTime = 1;

// 100 average
for (int k=0; k<numbeReads;k++)
{
  senseSum1 += flex0to100;
  delay(delayTime);
}
int flex0to1=senseSum1/numbeReads;


// 200 average
for (int k=0; k<numbeReads;k++)
{
  senseSum2 += flex0to200;
  delay(delayTime);
}
int flex0to2=senseSum2/numbeReads;


// 300 average
for (int k=0; k<numbeReads;k++)
{
  senseSum3 += flex0to300;
  delay(delayTime);
}
int flex0to3=senseSum3/numbeReads;



// 400 average
for (int k=0; k<numbeReads;k++)
{
  senseSum4 += flex0to400;
  delay(delayTime);
}
int flex0to4=senseSum4/numbeReads;


// 500 average
for (int k=0; k<numbeReads;k++)
{
  senseSum5 += flex0to500;
  delay(delayTime);
}
int flex0to5=senseSum5/numbeReads;



//right
Serial.println(String(flex0to1)+","+String( flex0to2)+","+String( flex0to3)+","+String( flex0to4)+","+String( flex0to5));
//origin
//Serial.println(String(flexSensorReading)+","+String(flexSensorReading2)+","+String( flexSensorReading3)+","+String( flexSensorReading4)+","+String( flexSensorReading5));
//singal
//Serial.println(String( flexSensorReading4));
//Serial.println(String( flex0to4));
//Serial.println(String( flexSensorReading4));
}
