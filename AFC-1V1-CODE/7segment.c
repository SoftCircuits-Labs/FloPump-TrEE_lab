unsigned char video_ram[4]={0,0,0,0};
unsigned char  cursor=0,seg_pattern=0;
//-----------------------------------------------------------------------
void seg_init(){
    
    DDRD.3=1;          //  7segment led outputs
    DDRD.4=1;          //  7segment led outputs
    DDRD.5=1;          //  7segment led outputs
    DDRD.6=1;          //  7segment led outputs
    DDRD.7=1;          //  7segment led outputs    
    DDRB.0=1;          //  7segment led outputs
    DDRB.6=1;          //  7segment led outputs
    DDRB.7=1;          //  7segment led outputs
    
    
    DDRB.1=1;           //  select segment 0
    DDRD.2=1;           //  select segment 1
    DDRC.5=1;           //  select segment 2
    
    
    PORTD.3=0;
    PORTD.4=0;
    PORTD.5=0;
    PORTD.6=0;
    PORTD.7=0;
    PORTB.0=0;
    PORTB.6=0;
    PORTB.7=0;
                                           
    PORTB.1=0;           
    PORTD.2=0;           
    PORTC.5=0;
    
}

unsigned char make_pattern(unsigned char data){
    switch (data) {
    case '0' : 
        return 0b01101111;  
    break;
    case '1' : 
        return 0b00001010;  
    break;
    case '2' : 
        return 0b11100011;  
    break;
    case '3' : 
        return 0b11101010;  
    break;
    case '4' : 
        return 0b10001110;  
    break;
    case '5' : 
        return 0b11101100;  
    break;
    case '6' : 
        return 0b11101101;  
    break;
    case '7' : 
        return 0b01001010;  
    break;
    case '8' : 
        return 0b11101111;  
    break;
    case '9' : 
        return 0b11101110;  
    break;
    case 'a' : 
        return 0b01001111;  
    break;
    case 'A' : 
        return 0b01001111;  
    break;
    case 'V' : 
        return 0b00101111;  
    break;  
    case 'v' : 
        return 0b00101111;  
    break;
    case 'C' : 
        return 0b01100101;  
    break;
    case 'c' : 
        return 0b01100101;  
    break; 
    case 'D' : 
        return 0b10101011;  
    break; 
    case 'd' : 
        return 0b10101011;  
    break;
    case 'T' : 
        return 0b10100101;  
    break;
    case 't' : 
        return 0b10100101;  
    break;
    case 'E' : 
        return 0b11100101;  
    break;
    case 'e' : 
        return 0b11100101;  
    break;
    case 'H' : 
        return 0b10001111;  
    break;
    case 'h' : 
        return 0b10001111;  
    break; 
    case 'L' : 
        return 0b00100101;  
    break;
    case 'l' : 
        return 0b00100101;  
    break;
    case 'O' : 
        return 0b10101001;  
    break;
    case 'o' : 
        return 0b10101001;  
    break; 
    case 'P' : 
        return 0b11000111;  
    break;
    case 'p' : 
        return 0b11000111;  
    break;
    case 'i' : 
        return 0b00000001;  
    break;
    case 'I' : 
        return 0b00000001;  
    break;
    case 'R' : 
        return 0b10001000;  
    break;
    case 'r' : 
        return 0b10001000;  
    break;
    case 'F' : 
        return 0b11000101;  
    break;
    case 'f' : 
        return 0b11000101;  
    break;
    case 'N' : 
        return 0b10001001;  
    break;
    case 'n' : 
        return 0b10001001;  
    break;
    case '-' : 
        return 0b10000000;  
    break;
    case 0 : 
        return 0b00000000;  
    break;
    case 10 : 
        return 0b11110111;  
    break;
    case 11 : 
        return 0b00110001;  
    break;
    case 12 : 
        return 0b11011011;  
    break;
    case 13 : 
        return 0b01111011;  
    break;
    case 14 : 
        return 0b00111101;  
    break;
    case 15 : 
        return 0b01111110;  
    break;
    case 16 : 
        return 0b11111110;  
    break;
    case 17 : 
        return 0b00110011;  
    break;
    case 18 : 
        return 0b11111111;  
    break;
    case 19 : 
        return 0b01111111;  
    break;
       
    default:
        return data;
    };
}
 
void display(unsigned char position, unsigned char data){
    video_ram[position]=data;
}


void refresh_display(){
    cursor++;
    switch(cursor & 0b00000011){
        case 0 :    
             seg_pattern = make_pattern(video_ram[0]);
             PORTD = ((seg_pattern<<2) & 0b11111000) | (PORTD & 0b00000111); 
             PORTB = (seg_pattern & 0b11000001) | (PORTB & 0b00111110);          
             PORTB.1=1;           
             PORTD.2=0;           
             PORTC.5=0;   
        break;
        case 1 : 
             seg_pattern = make_pattern(video_ram[1]);
             PORTD = ((seg_pattern<<2) & 0b11111000) | (PORTD & 0b00000111); 
             PORTB = (seg_pattern & 0b11000001) | (PORTB & 0b00111110);          
             PORTB.1=0;           
             PORTD.2=1;           
             PORTC.5=0;   
        break;
        case 2 : 
             seg_pattern = make_pattern(video_ram[2]);
             PORTD = ((seg_pattern<<2) & 0b11111000) | (PORTD & 0b00000111); 
             PORTB = (seg_pattern & 0b11000001) | (PORTB & 0b00111110);          
             PORTB.1=0;           
             PORTD.2=0;           
             PORTC.5=1;   
        break;
    }
}
