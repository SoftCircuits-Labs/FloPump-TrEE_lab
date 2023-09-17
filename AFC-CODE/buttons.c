#define BUTTON_ON 0b00000110
#define BUTTON_UP 0b00000110
#define BUTTON_DOWN 0b00000101
#define BUTTON_MENU 0b00000011
#define BUTTON_NONE 0b00000111


unsigned char b_long_press=0;

void button_init(){
   
}
unsigned char read_adc_buttons(){
    return ((read_adc(6) & 0b10000000)>>7) | ((read_adc(7) & 0b10000000)>>6) | ((read_adc(0) & 0b10000000)>>5);
}

unsigned char read_button(){
    unsigned char i,temp_keys,keys,long_press_timeout;
        keys=read_adc_buttons();
        if(keys == BUTTON_NONE){
            b_long_press=0;
            return BUTTON_NONE;   
        }
    delay_ms(5);
    for(i=0;i<5;i++){
        temp_keys=read_adc_buttons();
        if(temp_keys == keys){
            keys= temp_keys;   
        }else{             
            b_long_press=0;
            return BUTTON_NONE;
        }
    delay_ms(5);
    }       
    if(b_long_press){
        long_press_timeout=20;
    }else{
        long_press_timeout=100;
    }                                                     
    
    while(read_adc_buttons() != BUTTON_NONE && long_press_timeout){// wait untill all keys release or long press
        delay_ms(10);
        long_press_timeout--;     
    };
    if(long_press_timeout){
        if(b_long_press){
            b_long_press=0;
            return BUTTON_NONE;
        }
        b_long_press=0;
        return temp_keys;
    }else{             
        b_long_press=1;
        return temp_keys;
    }  
            
}
