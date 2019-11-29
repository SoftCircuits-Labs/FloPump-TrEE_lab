
//-----------------------state machine --------------------
#define STATE_OFF 0
#define STATE_ON 1 
#define STATE_SLEEP 2
#define STATE_SET_TIME 3
#define STATE_SET_PWM 4
#define STATE_SET_TIMER_ON_OFF 5
#define STATE_EXIT 6
#define STATE_SETTING_TIME 7
#define STATE_SETTING_PWM 8
#define STATE_SETTING_TIMER_ON_OFF 9

//---------------------life times---------------------------
#define STATE_LONG_PRESS_LIFE 8
//--------------------global variables----------------------

#define MAX_TIMER_COUNTER 99

unsigned char state=STATE_SLEEP,state_1=0,toggle=0;
unsigned int temp;
unsigned char state_long_press_life=0;
unsigned int state_life=0,state_life_1=0;



  



//-----------------functions--------------------------------
void do_on(){
        if(!timer_on_off){
            state_1=1;   
        }
        state_life_1++;
        switch (state_1) {
        case 0 :
            temp=timer;    
            display(2,temp%10+'0');
            temp/=10;
            display(1,temp%10+'0');
            if(state_life_1%10 == 0){
                if(toggle){
                    toggle=0;
                    display(0,'T');
                }else{            
                    toggle=1;
                    display(0,0);
                }
            }
            //display(0,'T');
        if(state_life_1>200){
            state_life_1=0;
            state_1=1;
        }
        break;
        case 1 :
            temp=pump_pwm;    
            display(2,temp%10+'0');
            temp/=10;
            display(1,temp%10+'0');
            /*
            if(state_life_1%10 == 0){
                if(toggle){
                    toggle=0;
                    display(0,'P');
                }else{            
                    toggle=1;
                    display(0,0);
                }
            } 
            */
            temp/=10;
            display(0,temp%10+'0');
        if(state_life_1>200){
            state_life_1=0;
            state_1=0;
        }
        break;
        }; 
}
void do_off(){
    display(0,'o');
    display(1,'F');
    display(2,'F');
}
void do_sleep(){
    display(0,'-');
    display(1,'-');
    display(2,'-');
}
void do_set_pwm(){
    display(0,'5');
    display(1,'P');
    display(2,'d');
}
void do_set_time(){
    display(0,'T');
    display(1,'n');
    display(2,'R');
}
void do_set_timer_on_off(){
    display(0,'T');
    display(1,'E');
    display(2,'N');
}
void do_exit(){
    display(0,'E');
    display(1,'N');
    display(2,'D');
}
void do_setting_pwm(){
    temp=pump_pwm;    
    display(2,temp%10+'0');
    temp/=10;
    display(1,temp%10+'0');
    temp/=10;
    display(0,temp%10+'0');
    //display(0,'P');
}
void do_setting_time(){
    temp=set_timer;    
    display(2,temp%10+'0');
    temp/=10;
    display(1,temp%10+'0');
    display(0,'T');
}
void do_setting_timer_on_off(){
    if(timer_on_off){
        display(0,'o');
        display(1,'N');
        display(2,0);
    }else{
        display(0,'o');
        display(1,'F');
        display(2,'F');
    }
    
}

void timer_up(unsigned char x){
    if(set_timer+x <= MAX_TIMER_COUNTER){
        set_timer+=x;    
    }else{
        set_timer=MAX_TIMER_COUNTER;  
    }   
}
void timer_down(unsigned char x){
    if(set_timer>=(x+1)){
        set_timer-=x;    
    }else{
        set_timer=1;  
    }   
}