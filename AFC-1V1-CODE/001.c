/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 11/24/2016
Author  : 
Company : 
Comments: 


Chip type               : ATmega8L
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega8.h>
#include <delay.h>
#include <7segment.c>



 // Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (1<<ADLAR))

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCH;
}





#include <buttons.c>
//-------------eeprom variables-----------------
unsigned char set_timer=50;
unsigned char timer_on_off=0;
unsigned int pump_pwm=250;

unsigned char eeprom eep_set_timer@10;
unsigned char eeprom eep_timer_on_off@11;
unsigned int eeprom eep_pump_pwm@12;

//----------------------------------------------

unsigned char timer;         // timer variable
#define ONE_MIN 60000
unsigned int time_logic=0;


#include <pump_pwm.c>
#include <state_machine.c>

// Declare your global variables here




//--------------------------------

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index=0,tx_rd_index=0;
#else
unsigned int tx_wr_index=0,tx_rd_index=0;
#endif

#if TX_BUFFER_SIZE < 256
unsigned char tx_counter=0;
#else
unsigned int tx_counter=0;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0x83;
// Place your code here
refresh_display();
//pump_subroutine();
if(timer_on_off && pump_state && timer){
    time_logic++;
    if(time_logic>=ONE_MIN){
        time_logic=0;
        timer--;    
    }
}

}

// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Place your code here
TCNT2=0x9c;
pump_subroutine();
}

void fetch_eeprom(){
    if(eep_set_timer>100){
        eep_set_timer=50;
    }
    if(eep_timer_on_off>1){
        eep_timer_on_off=0;
    }
    if(eep_pump_pwm>500){
        eep_pump_pwm=200;
    }
    set_timer=eep_set_timer;
    timer_on_off=eep_timer_on_off;
    pump_pwm=eep_pump_pwm;
}

void init(){    
    pump_init();  
    seg_init();
    button_init(); 
    fetch_eeprom(); 
    delay_ms(1000); 
}

void main(void)
{
// Declare your local variables here
unsigned char button;
// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
TCCR0=(0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=0x83;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

/*
// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;



// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 8000.000 kHz
// Mode: Normal top=0xFF
// OC2 output: Disconnected
// Timer Period: 0.032 ms
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (1<<CS20);
TCNT2=0x00;
OCR2=0x00;
*/



// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 1000.000 kHz
// Mode: Normal top=0xFF
// OC2 output: Disconnected
// Timer Period: 0.256 ms
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (1<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;



/*
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
*/
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

/*
// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
*/

// ADC initialization
// ADC Clock frequency: 62.500 kHz
// ADC Voltage Reference: AVCC pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ACME);


// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Global enable interrupts
#asm("sei")

init();

while (1)
      {
      // Place your code here
      if(timer_on_off && pump_state && !timer){
        pump(0);
        state = STATE_OFF;
      }
      
        button = read_button(); 
        switch (state) {        
        case STATE_OFF :
            if(button == BUTTON_MENU && b_long_press){      //  menu button long pressed
                state = STATE_SET_PWM;
                state_life=0;
                state_long_press_life=STATE_LONG_PRESS_LIFE;
            }else if(button == BUTTON_ON){
                pump(1);
                state = STATE_ON;
            }
            if(button == BUTTON_NONE){
                state_life++;
            }else{
                state_life=0;
            }
            
            if(state_life>100){
                state = STATE_SLEEP;
                state_life=0;
            }else{            
                do_off();
            }      
        break;  
        
        case STATE_ON :
            if(button == BUTTON_MENU && b_long_press){      //  menu button long pressed
                state = STATE_SET_PWM;
                state_life=0; 
                state_long_press_life=STATE_LONG_PRESS_LIFE;
            }else if(button == BUTTON_ON){
                pump(0);
                state = STATE_OFF;
            }            
            do_on();      
        break;
        
        case STATE_SLEEP :
            if(button == BUTTON_MENU && b_long_press){      //  menu button long pressed
                state = STATE_SET_PWM;
                state_life=0;
                state_long_press_life=STATE_LONG_PRESS_LIFE;
            }else if(button == BUTTON_ON){
                pump(1);
                state = STATE_ON;
            }            
            do_sleep();      
        break; 
        
        case STATE_SET_TIME : 
            if(button == BUTTON_MENU && b_long_press){      //  menu button long pressed
                do_set_time();
                state_long_press_life--;
                if(!state_long_press_life){
                    state = STATE_SET_TIMER_ON_OFF;
                    state_life=0;
                    state_long_press_life=STATE_LONG_PRESS_LIFE;    
                }
                
            }else if(button == BUTTON_NONE){
                state = STATE_SETTING_TIME;
            }           
                  
        break;
        
        case STATE_SET_PWM :
            if(button == BUTTON_MENU && b_long_press){      //  menu button long pressed
                do_set_pwm();
                state_long_press_life--;
                if(!state_long_press_life){
                    state = STATE_SET_TIME;
                    state_life=0;
                    state_long_press_life=STATE_LONG_PRESS_LIFE;    
                }
            }else if(button == BUTTON_NONE){
                state = STATE_SETTING_PWM;
            }            
                  
        break;        
        
        case STATE_SET_TIMER_ON_OFF :
            if(button == BUTTON_MENU && b_long_press){      //  menu button long pressed
                do_set_timer_on_off();
                state_long_press_life--;
                if(!state_long_press_life){
                    state = STATE_EXIT;
                    state_life=0;
                    state_long_press_life=STATE_LONG_PRESS_LIFE;    
                }
                
            }else if(button == BUTTON_NONE){
                state = STATE_SETTING_TIMER_ON_OFF;
            }             
                  
        break;        
        
        case STATE_EXIT :
            if(button == BUTTON_MENU && b_long_press){      //  menu button long pressed
                do_exit();       
                state_life=0;
                state = STATE_EXIT; 
                //state = STATE_SETTING_PWM; //only for testing
            }else if(button == BUTTON_NONE){       
                if(pump_state){
                    state = STATE_ON;
                }else{
                    state = STATE_SLEEP;
                }
            }             
                  
        break;      
        
        case STATE_SETTING_TIME :
            if(button == BUTTON_UP){
                if(b_long_press){
                    timer_up(5);   
                }else{
                    timer_up(1);
                }
            }else if(button == BUTTON_DOWN){
                if(b_long_press){
                    timer_down(5);   
                }else{
                    timer_down(1);
                }
            }else if(button == BUTTON_MENU){
                time_logic=0;
                timer=set_timer;
                eep_set_timer=set_timer;    // eeprom write       
                if(pump_state){
                    state = STATE_ON;
                }else{
                    state = STATE_SLEEP;
                }
            }
            if(button == BUTTON_NONE){
                state_life++;
                if(state_life>600){
                    time_logic=0;
                    timer=set_timer; 
                    eep_set_timer=set_timer;    // eeprom write      
                    if(pump_state){
                        state = STATE_ON;
                    }else{
                        state = STATE_SLEEP;
                    }    
                }
            }else{
                state_life=0;  
            }                 
            do_setting_time();      
        break;
        
        case STATE_SETTING_PWM :
            if(button == BUTTON_UP){
                if(b_long_press){
                    pump_pwm_up(5);   
                }else{
                    pump_pwm_up(1);
                }
            }else if(button == BUTTON_DOWN){
                if(b_long_press){
                    pump_pwm_down(5);   
                }else{
                    pump_pwm_down(1);
                }
            }else if(button == BUTTON_MENU){
                eep_pump_pwm=pump_pwm;    // eeprom write       
                if(pump_state){
                    state = STATE_ON;
                }else{
                    state = STATE_SLEEP;
                }
            }
            if(button == BUTTON_NONE){
                state_life++;
                if(state_life>800){
                    eep_pump_pwm=pump_pwm;    // eeprom write       
                    if(pump_state){
                        state = STATE_ON;
                    }else{
                        state = STATE_SLEEP;
                    }    
                }
            }else{
                state_life=0;  
            }                 
            do_setting_pwm();      
        break;        
        
        case STATE_SETTING_TIMER_ON_OFF :
            if(button == BUTTON_UP){
                timer_on_off = 1;
            }else if(button == BUTTON_DOWN){
                timer_on_off = 0;
            }else if(button == BUTTON_MENU){
                eep_timer_on_off=timer_on_off;    // eeprom write       
                if(pump_state){
                    state = STATE_ON;
                }else{
                    state = STATE_SLEEP;
                }
            }
            if(button == BUTTON_NONE){
                state_life++;
                if(state_life>600){
                    eep_timer_on_off=timer_on_off;    // eeprom write       
                    if(pump_state){
                        state = STATE_ON;
                    }else{
                        state = STATE_SLEEP;
                    }    
                }
            }else{
                state_life=0;  
            }                 
            do_setting_timer_on_off();      
        break;
      
        default:
            state = STATE_SLEEP;
        }        
        delay_ms(10);     
    
      }
}
