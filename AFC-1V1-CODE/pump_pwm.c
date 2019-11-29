//--------------created by Arpit singh-------------------------------------
//   call pump_subroutine() function inside timer which is interrupted 1 ms
//   need to call pump_init() for PORT initilization 
//   use pump() function to turn on/off pump
//   use set_pump_pwm() function to set pump speed(duty cycle)
//   could use pump_state variable to get pump current state (on/off)-(1/0)
//--------------------------------------------------------------------------


#define MAX_PWM_COUNTER 500
unsigned int pwm_counter=0,pump_state=0;
void pump_init(){

    PORTB.2=0;
    DDRB.2=1;       //use for pump(on/off) relay 
}
void pump_on(){
    PORTB.2=1;   
}

void pump_off(){
    PORTB.2=0;   
}
void set_pump_pwm(unsigned char x){
    pump_pwm = x;   
}
void pump_subroutine(){
    if(pump_state == 1 && pump_pwm>0){
        pwm_counter++; 
        if(pwm_counter >= MAX_PWM_COUNTER){
            pwm_counter = 0 ;
            pump_on();   
        }else if(pwm_counter == pump_pwm){
            pump_off();
        }
    }
      
}

void pump(unsigned char x){     // pass 1 to turn on pump and 0 to turn off pump
    if(x){
        pump_state=1;     
        time_logic=0;
        timer=set_timer;   
    }else{
        pump_state = 0;
        pump_off();
    }
}

void pump_pwm_up(unsigned char x){
    if(pump_pwm+x <= MAX_PWM_COUNTER){
        pump_pwm+=x;    
    }else{
        pump_pwm=MAX_PWM_COUNTER;  
    }   
}
void pump_pwm_down(unsigned char x){
    if(pump_pwm>=x){
        pump_pwm-=x;    
    }else{
        pump_pwm=0;  
    }   
}