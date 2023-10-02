#include <EEPROM.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels

// Declaration for an SSD1306 display connected to I2C (SDA, SCL pins)
#define OLED_RESET     -1 // Reset pin # (or -1 if sharing Arduino reset pin)
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

#define BUZZER_PIN 5
#define ENC_BUTTON_PIN 2
#define ENC_DATA_PIN 4
#define ENC_CLK_PIN 3
#define MOT_PWM_PIN 9
#define LED_1_PIN 14
#define LED_2_PIN 15
#define BAT_ADC_PIN A7

#define BAT_MIN 320
#define BAT_MAX 420 

//---------------EEPROM ADDRESS---------------
#define EP_ADD_PWM 10
#define EP_ADD_TIME 20
#define EP_ADD_ENABLE 30
//-------------STATE VARIABLES-----------------
#define BOOTING_STATE 0
#define PUMP_ON_OFF_STATE 1
#define SET_TIME_STATE 2
#define ENABLE_TIMER_STATE 3
#define TIMER_EXPIRE_STATE 4
#define EXIT_STATE 5

unsigned char state = BOOTING_STATE;
//---------------------------------------------
#define PWM_MAX 255
#define PWM_MIN 100

#define TIMER_MAX 999
#define TIMER_MIN 1

//---------------------------------------------
#define TIMER_EXPIRE_BUZZER 10000
//---------------------------------------------

unsigned char motor_on_off_state=0;

unsigned char animate_pump_var=0;

volatile unsigned char pwm = PWM_MIN;
volatile unsigned int timer_time = TIMER_MIN;
volatile unsigned char timer_enable = 1;
unsigned char last_pwm=0;

unsigned char enc_button_val = 0; 
unsigned int button_time=0;
unsigned long start_time=0;
unsigned long passed_seconds=0;
unsigned long display_minutes = 0;
unsigned long display_seconds = 0;

unsigned int battery_display_time = 0;
unsigned int battery_voltage_last = 0,battery_voltage_current=0,battery_voltage_difference=0;
unsigned int timer_expire_buzzer = 0;


void setup() {
  // put your setup code here, to run once:
//Serial.begin(9600);
init_motor();
init_buzzer();
init_batter_ADC();
init_encoder_sw();
oled_init();
fetch_eeprom();
delay(10);
buzzer(400);
delay(400);
buzzer(400);
}

void loop() {   
  /*
  while(1){
      display.clearDisplay();
    display.setCursor(15,10);   
    display.setTextSize(2);                
    battery_voltage_current = read_battery_voltage();      
    display.print(battery_voltage_current);
    display.display();
    delay(400);
    
    }
  */
  // put your main code here, to run repeatedly:  
 switch(state){    
    case BOOTING_STATE :
    display.clearDisplay();
    display.setCursor(15,10);   
    display.setTextSize(2);                
    display.print(F("Flo-Pump"));
    display.setCursor(58,32);   
    display.setTextSize(1);                
    display.print(F("by"));
    display.setCursor(5,50);   
    display.print(F("www.softcircuits.in"));
    display.display();
    delay(2000);
    state = PUMP_ON_OFF_STATE;
    display_pump_on_off_page();
    break;
    
    case PUMP_ON_OFF_STATE : 
    buzzer_off();                  
    if(last_pwm != pwm){
        last_pwm = pwm;
          if(motor_on_off_state == 1){
            start_motor(last_pwm);    
          }        
        display.fillRect(50, 45, 21, 7,SSD1306_BLACK);
        display.setTextSize(1);
        display.setCursor(50,45);          
        display.print(pwm);    
        display.display();
      }

      button_time=0;
    while(digitalRead(ENC_BUTTON_PIN) == LOW){        
        delay(1);
        button_time++;             
        if(button_time==3000){
            display.clearDisplay();
            display.setTextSize(1);
            display.setCursor(40,25);
            display.print(F("SET TIMER"));     
            display.display();  
        }else if(button_time==7000){
            display.clearDisplay();
            display.setTextSize(1);
            display.setCursor(30,25);
            display.print(F("ENABLE TIMER"));     
            display.display();  
        }else if(button_time==11000){
            display.clearDisplay();
            display.setTextSize(1);
            display.setCursor(48,25);
            display.print(F("EXIT"));     
            display.display();  
            delay(1000);
            break;
          }
        
      }  
    if(button_time>=100 && button_time<1000){
      if(motor_on_off_state == 0 ){
          motor_on_off_state=1;
          start_motor(pwm);
          EEPROM.update(EP_ADD_PWM, pwm);
          display.fillRect(10, 30, 21, 7,SSD1306_BLACK);          
          display.setTextSize(1);      
          display.setCursor(10,30);
          display.print("ON");
          display.display(); 
          start_time = millis();
        }else{          
          motor_on_off_state=0;  
          stop_motor();
          EEPROM.update(EP_ADD_PWM, pwm);
          display.fillRect(10, 30, 21, 7,SSD1306_BLACK);          
          display.setTextSize(1);      
          display.setCursor(10,30);
          display.print("OFF");
          display.display(); 
        }
      
      }else if(button_time>=3000 && button_time<7000){
        state = SET_TIME_STATE;
        break;
      
      }else if(button_time>=7000 && button_time<11000){
        state = ENABLE_TIMER_STATE;
        break;
        
      }else if(button_time>=11000){
        
        display_pump_on_off_page();
        break;
      }  

    if(motor_on_off_state){
        animate_running_pump();
        if(timer_enable){
            remaining_timer_routine();   
          }else{
            display.fillRect(80, 40, 40, 7,SSD1306_BLACK);          
            display.setTextSize(1);      
            display.setCursor(80,40);
            display.print("DISABLED");
            display.display(); 
            }
        
      }
     if((millis()-battery_display_time) > 10000){
        battery_voltage_current = 0;
        
        battery_voltage_current += read_battery_voltage();
        battery_voltage_current += read_battery_voltage();
        battery_voltage_current += read_battery_voltage();
        battery_voltage_current += read_battery_voltage();

        battery_voltage_current/=4;
        if(battery_voltage_current>battery_voltage_last){
          battery_voltage_difference = battery_voltage_current - battery_voltage_last;
        }else{
          battery_voltage_difference = battery_voltage_last - battery_voltage_current;  
        }        

        if(battery_voltage_difference > 5){
            if(battery_voltage_current > BAT_MIN){
                display_battery_charge(((battery_voltage_current - BAT_MIN)*100)/(BAT_MAX-BAT_MIN)); 
              }else{
                display_battery_charge(10);// this will show low battery 
                }
                
            battery_voltage_last = battery_voltage_current;  
          }
        
        battery_display_time = millis();
      }      
    delay(10);
    //state = SET_TIME_STATE;
    break;
    
    case SET_TIME_STATE :
        display.clearDisplay();
        display.setCursor(20,20);   
        display.print(F("SET TIME "));
        display.print(timer_time);
        display.print(F(" min"));
        display.display();
        delay(10);
        if(digitalRead(ENC_BUTTON_PIN) == LOW){
          state = PUMP_ON_OFF_STATE;   
          //EEPROM.update(EP_ADD_TIME, timer_time);       
          EEPROM.put(EP_ADD_TIME, timer_time);       
          delay(200);
          start_time = millis();
          display_pump_on_off_page();
          }    
    break;
    
    case ENABLE_TIMER_STATE :
        display.clearDisplay();
        display.setCursor(20,20);   
          if(timer_enable){
            display.print(F("ENABLE TIMER "));  
          }else{
            display.print(F("DISABLE TIMER "));
          }
        
        //display.print(timer_enable);
        display.display();
        delay(10);
        if(digitalRead(ENC_BUTTON_PIN) == LOW){
          state = PUMP_ON_OFF_STATE;
          EEPROM.update(EP_ADD_ENABLE, timer_enable);
          delay(200);
          display_pump_on_off_page();
          }    
    break;

    case TIMER_EXPIRE_STATE :
        
        if(timer_expire_buzzer%50 == 0){
            display.clearDisplay();
            display.setCursor(40,10);   
            display.print(F("TIMER END"));            
            display.display();  
            if(timer_expire_buzzer < (TIMER_EXPIRE_BUZZER/10)) buzzer_on();
          }else if(timer_expire_buzzer%50 == 25){
            display.clearDisplay();
            display.setCursor(40,10);   
            display.print(F("TIMER-END"));            
            display.display();
            buzzer_off();
          }
        timer_expire_buzzer++;    
        delay(10);        
        
            
           

         if(digitalRead(ENC_BUTTON_PIN) == LOW){
          buzzer_off();
          state = PUMP_ON_OFF_STATE;             
          delay(200);          
          display_pump_on_off_page();
          } 
        
    break;
    
    case EXIT_STATE :
    display.clearDisplay();
    display.setCursor(40,10);   
    display.println(F("EXIT_STATE"));
    display.display();
    delay(1000);
    state = BOOTING_STATE;
    break;
    
  }

}

void oled_init(){
     if(!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) { // Address 0x3D for 128x64
    //Serial.println(F("SSD1306 allocation failed"));
    for(;;); // Don't proceed, loop forever
  }

  // Show initial display buffer contents on the screen --
  // the library initializes this with an Adafruit splash screen.
  //display.display();
  //delay(2000); // Pause for 2 seconds

  display.setTextSize(1);
  display.setTextColor(WHITE);
  // Clear the buffer
  display.clearDisplay();  
  }
//-------------------------motor--------------
void init_motor(){
  pinMode(MOT_PWM_PIN, OUTPUT);
  digitalWrite(MOT_PWM_PIN, LOW);  
  }  
void start_motor(unsigned char mot_speed){
  analogWrite(MOT_PWM_PIN, mot_speed);
  }
void stop_motor(){
  analogWrite(MOT_PWM_PIN,0);
  }  
 
//------------------------encoder switch---------
void init_encoder_sw(){
  pinMode(ENC_BUTTON_PIN, INPUT);
  pinMode(ENC_DATA_PIN, INPUT);
  pinMode(ENC_CLK_PIN, INPUT);

  digitalWrite(ENC_BUTTON_PIN, HIGH);  
  digitalWrite(ENC_DATA_PIN, HIGH);
  digitalWrite(ENC_CLK_PIN, HIGH);  

  attachInterrupt(digitalPinToInterrupt(ENC_CLK_PIN), encoder_ISR, FALLING);
  
  }

void encoder_ISR(){
  noInterrupts ();  
  switch(state){
    case PUMP_ON_OFF_STATE :
    if(digitalRead(ENC_CLK_PIN)==LOW){    
      if(digitalRead(ENC_DATA_PIN)==HIGH){
        if(pwm>PWM_MIN)pwm--;    
      }else{
        if(pwm<PWM_MAX)pwm++;        
      }
    }
    break;

    case SET_TIME_STATE :
    if(digitalRead(ENC_CLK_PIN)==LOW){    
      if(digitalRead(ENC_DATA_PIN)==HIGH){
        if(timer_time>TIMER_MIN){
          if(timer_time<=60){
            timer_time--;        
          }else{
            timer_time-=5;            
          }
        }
      }else{
        if(timer_time<TIMER_MAX){
          if(timer_time>=60){
            timer_time+=5;        
          }else{
            timer_time++;            
          }
          
        }
      }
    }
    break;

    case ENABLE_TIMER_STATE :
    if(digitalRead(ENC_CLK_PIN)==LOW){    
      if(digitalRead(ENC_DATA_PIN)==HIGH){
        timer_enable=0;    
      }else{
        timer_enable=1;        
      }
    }
    break;
    }
    delayMicroseconds(50000);
    interrupts ();    
  }  



unsigned char read_sw(){
  unsigned int x=0;
  if(digitalRead(ENC_BUTTON_PIN) == LOW){
    for(x=0;x<10000;x++){
      delay(1);
      if(digitalRead(ENC_BUTTON_PIN) == HIGH) break;
      }
    if(x>200 && x<3000) return 1;
    if(x>=3000 && x<6000) return 2;  
    if(x>=6000 && x<9000) return 3;
    if(x>=9000) return 4;
  }else{
    return 0;
    }
  }  

void display_pump_on_off_page(){
      display.clearDisplay();
      display.setTextSize(2);      
      display.setCursor(10,10);   
      display.print(F("/"));    
      display.setTextSize(1);      
      display.setCursor(10,30);   
      display.print(F("OFF"));  
      //display.setTextSize(2);      
      display.setCursor(10,45);   
      display.print(F("SPEED")); 
      display.setCursor(50,45);   
      display.print(pwm); 
      display.setCursor(80,25);   
      display.print(F("TIMER")); 
      display.setCursor(80,40);   
      if(timer_time<10)display.print("0");
      display.print(timer_time);
      display.print(F(":00")); 
      display.display();    

      display_battery_charge(100);
  }
void display_timer_set_page(){
      display.clearDisplay();
      display.setTextSize(2);      
      display.setCursor(10,10);   
      display.print(F("SET TIMER"));    
      display.setTextSize(1);      
      display.setCursor(80,40);   
      display.print(F("Minutes"));  
      display.setTextSize(2);      
      display.setCursor(20,36);   
      display.print(F("1000")); 
      display.display();      
  }  
void display_timer_enable_page(){
      display.clearDisplay();
      display.setTextSize(2);      
      display.setCursor(40,10);   
      display.print(F("TIMER"));    
      display.setTextSize(2);      
      display.setCursor(32,36);   
      display.print(F("Enable"));        
      display.display();      
  }

void animate_running_pump(){
    display.fillRect(10, 10, 14, 14,SSD1306_BLACK);  
    display.setTextSize(2);       
    display.setCursor(10,10);
    switch(animate_pump_var){
      case 0:
        display.print(F("\\"));            
      break;
      case 1:
        display.print(F("|"));            
      break;
      case 2:
        display.print(F("/"));            
      break;
      case 3:
        display.print(F("-"));            
      break;
      }
    display.display();  
    animate_pump_var++;
    if(animate_pump_var>3)animate_pump_var=0;
    
  } 

 void remaining_timer_routine(){
      passed_seconds = (millis() - start_time)/1000;
      if(passed_seconds<timer_time*60){
          display.fillRect(80, 40, 40, 7,SSD1306_BLACK);          
          display.setTextSize(1);      
          display.setCursor(80,40);
          display_seconds = (timer_time*60 - passed_seconds)%60;
          display_minutes = (timer_time*60 - passed_seconds)/60;
          if(display_minutes<10)display.print("0");
          display.print(display_minutes);
            if(millis()%1000 > 500){
              display.print(":");  
            }else{
              display.print(" ");
            }
          if(display_seconds<10)display.print("0");
          display.print(display_seconds);
          display.display(); 
        }else{
          motor_on_off_state=0;  
          stop_motor();
          timer_expire_buzzer=0;
          state = TIMER_EXPIRE_STATE;
          EEPROM.update(EP_ADD_PWM, pwm);
          display.fillRect(10, 30, 21, 7,SSD1306_BLACK);          
          display.setTextSize(1);      
          display.setCursor(10,30);
          display.print("OFF");
          display.fillRect(80, 40, 40, 7,SSD1306_BLACK);          
          display.setCursor(80,40);
          display.print("00:00");
          display.display(); 
          } 
  }

     

void fetch_eeprom(){
    pwm = EEPROM.read(EP_ADD_PWM);
    //timer_time = EEPROM.read(EP_ADD_TIME);
    EEPROM.get(EP_ADD_TIME,timer_time);
    timer_enable = EEPROM.read(EP_ADD_ENABLE);

    if(pwm>PWM_MAX || pwm<PWM_MIN){
      pwm = PWM_MIN;
      EEPROM.update(EP_ADD_PWM, pwm);
      }
     if(timer_time>TIMER_MAX || timer_time<TIMER_MIN){
      timer_time = TIMER_MIN;
      EEPROM.update(EP_ADD_TIME, timer_time);
      } 
      if(timer_enable!=0 && timer_enable!=1){
      timer_enable = 1;
      EEPROM.update(EP_ADD_ENABLE, 1);
      }   
  }



void display_battery_charge(unsigned int charge){  
      display.fillRect(52, 0, 80, 18,SSD1306_BLACK);
      display.setTextSize(1);      
      display.setCursor(52,6);
      if(charge<=30){
        display.print(F("LOW"));
        }
      //display.print(charge);
      //display.print(F("%"));       
      display.drawRoundRect(80, 2, 39, 14,3, SSD1306_WHITE);
      display.fillRect(119, 5, 2, 8,SSD1306_WHITE); 


      if(charge>20)display.fillRect(85, 5, 5, 8,SSD1306_WHITE); 
      if(charge>40)display.fillRect(93, 5, 5, 8,SSD1306_WHITE); 
      if(charge>60)display.fillRect(101, 5, 5, 8,SSD1306_WHITE);
      if(charge>80)display.fillRect(109, 5, 5, 8,SSD1306_WHITE);
      display.display();     
  }  

void init_buzzer(){
  pinMode(BUZZER_PIN, OUTPUT);
  digitalWrite(BUZZER_PIN, LOW);  
  } 

void buzzer(unsigned long beep_time){
    digitalWrite(BUZZER_PIN, HIGH);
    delay(beep_time);
    digitalWrite(BUZZER_PIN, LOW);    
  } 

void buzzer_on(){
    digitalWrite(BUZZER_PIN, HIGH);    
  }   

void buzzer_off(){
    digitalWrite(BUZZER_PIN, LOW);    
  }

void init_batter_ADC(){
  pinMode(BAT_ADC_PIN, INPUT);
  }
 unsigned int read_battery_voltage(){
  return analogRead(BAT_ADC_PIN);    
  }          
