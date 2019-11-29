
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8L
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8L
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _cursor=R5
	.DEF _seg_pattern=R4
	.DEF _b_long_press=R7
	.DEF _set_timer=R6
	.DEF _timer_on_off=R9
	.DEF _pump_pwm=R10
	.DEF _pump_pwm_msb=R11
	.DEF _timer=R8
	.DEF _time_logic=R12
	.DEF _time_logic_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_tx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x32,0x0
	.DB  0x0,0x0,0xFA,0x0
	.DB  0x0,0x0

_0xA4:
	.DB  0x2

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _state
	.DW  _0xA4*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 11/24/2016
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8L
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <7segment.c>
;unsigned char video_ram[4]={0,0,0,0};
;unsigned char  cursor=0,seg_pattern=0;
;//-----------------------------------------------------------------------
;void seg_init(){
; 0000 001A void seg_init(){

	.CSEG
_seg_init:
; .FSTART _seg_init
;
;    DDRD.3=1;          //  7segment led outputs
	SBI  0x11,3
;    DDRD.4=1;          //  7segment led outputs
	SBI  0x11,4
;    DDRD.5=1;          //  7segment led outputs
	SBI  0x11,5
;    DDRD.6=1;          //  7segment led outputs
	SBI  0x11,6
;    DDRD.7=1;          //  7segment led outputs
	SBI  0x11,7
;    DDRB.0=1;          //  7segment led outputs
	SBI  0x17,0
;    DDRB.6=1;          //  7segment led outputs
	SBI  0x17,6
;    DDRB.7=1;          //  7segment led outputs
	SBI  0x17,7
;
;
;    DDRB.1=1;           //  select segment 0
	SBI  0x17,1
;    DDRD.2=1;           //  select segment 1
	SBI  0x11,2
;    DDRC.5=1;           //  select segment 2
	SBI  0x14,5
;
;
;    PORTD.3=0;
	CBI  0x12,3
;    PORTD.4=0;
	CBI  0x12,4
;    PORTD.5=0;
	CBI  0x12,5
;    PORTD.6=0;
	CBI  0x12,6
;    PORTD.7=0;
	CBI  0x12,7
;    PORTB.0=0;
	CBI  0x18,0
;    PORTB.6=0;
	CBI  0x18,6
;    PORTB.7=0;
	CBI  0x18,7
;
;    PORTB.1=0;
	CBI  0x18,1
;    PORTD.2=0;
	CBI  0x12,2
;    PORTC.5=0;
	CBI  0x15,5
;
;}
	RET
; .FEND
;
;unsigned char make_pattern(unsigned char data){
_make_pattern:
; .FSTART _make_pattern
;    switch (data) {
	RCALL SUBOPT_0x0
;	data -> Y+0
	LDI  R31,0
;    case '0' :
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x32
;        return 0b01101111;
	LDI  R30,LOW(111)
	RJMP _0x2060001
;    break;
;    case '1' :
_0x32:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x33
;        return 0b00001010;
	LDI  R30,LOW(10)
	RJMP _0x2060001
;    break;
;    case '2' :
_0x33:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x34
;        return 0b11100011;
	LDI  R30,LOW(227)
	RJMP _0x2060001
;    break;
;    case '3' :
_0x34:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0x35
;        return 0b11101010;
	LDI  R30,LOW(234)
	RJMP _0x2060001
;    break;
;    case '4' :
_0x35:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0x36
;        return 0b10001110;
	LDI  R30,LOW(142)
	RJMP _0x2060001
;    break;
;    case '5' :
_0x36:
	CPI  R30,LOW(0x35)
	LDI  R26,HIGH(0x35)
	CPC  R31,R26
	BRNE _0x37
;        return 0b11101100;
	LDI  R30,LOW(236)
	RJMP _0x2060001
;    break;
;    case '6' :
_0x37:
	CPI  R30,LOW(0x36)
	LDI  R26,HIGH(0x36)
	CPC  R31,R26
	BRNE _0x38
;        return 0b11101101;
	LDI  R30,LOW(237)
	RJMP _0x2060001
;    break;
;    case '7' :
_0x38:
	CPI  R30,LOW(0x37)
	LDI  R26,HIGH(0x37)
	CPC  R31,R26
	BRNE _0x39
;        return 0b01001010;
	LDI  R30,LOW(74)
	RJMP _0x2060001
;    break;
;    case '8' :
_0x39:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0x3A
;        return 0b11101111;
	LDI  R30,LOW(239)
	RJMP _0x2060001
;    break;
;    case '9' :
_0x3A:
	CPI  R30,LOW(0x39)
	LDI  R26,HIGH(0x39)
	CPC  R31,R26
	BRNE _0x3B
;        return 0b11101110;
	LDI  R30,LOW(238)
	RJMP _0x2060001
;    break;
;    case 'a' :
_0x3B:
	CPI  R30,LOW(0x61)
	LDI  R26,HIGH(0x61)
	CPC  R31,R26
	BRNE _0x3C
;        return 0b01001111;
	LDI  R30,LOW(79)
	RJMP _0x2060001
;    break;
;    case 'A' :
_0x3C:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0x3D
;        return 0b01001111;
	LDI  R30,LOW(79)
	RJMP _0x2060001
;    break;
;    case 'V' :
_0x3D:
	CPI  R30,LOW(0x56)
	LDI  R26,HIGH(0x56)
	CPC  R31,R26
	BRNE _0x3E
;        return 0b00101111;
	LDI  R30,LOW(47)
	RJMP _0x2060001
;    break;
;    case 'v' :
_0x3E:
	CPI  R30,LOW(0x76)
	LDI  R26,HIGH(0x76)
	CPC  R31,R26
	BRNE _0x3F
;        return 0b00101111;
	LDI  R30,LOW(47)
	RJMP _0x2060001
;    break;
;    case 'C' :
_0x3F:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x40
;        return 0b01100101;
	LDI  R30,LOW(101)
	RJMP _0x2060001
;    break;
;    case 'c' :
_0x40:
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x41
;        return 0b01100101;
	LDI  R30,LOW(101)
	RJMP _0x2060001
;    break;
;    case 'D' :
_0x41:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BRNE _0x42
;        return 0b10101011;
	LDI  R30,LOW(171)
	RJMP _0x2060001
;    break;
;    case 'd' :
_0x42:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRNE _0x43
;        return 0b10101011;
	LDI  R30,LOW(171)
	RJMP _0x2060001
;    break;
;    case 'T' :
_0x43:
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BRNE _0x44
;        return 0b10100101;
	LDI  R30,LOW(165)
	RJMP _0x2060001
;    break;
;    case 't' :
_0x44:
	CPI  R30,LOW(0x74)
	LDI  R26,HIGH(0x74)
	CPC  R31,R26
	BRNE _0x45
;        return 0b10100101;
	LDI  R30,LOW(165)
	RJMP _0x2060001
;    break;
;    case 'E' :
_0x45:
	CPI  R30,LOW(0x45)
	LDI  R26,HIGH(0x45)
	CPC  R31,R26
	BRNE _0x46
;        return 0b11100101;
	LDI  R30,LOW(229)
	RJMP _0x2060001
;    break;
;    case 'e' :
_0x46:
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x47
;        return 0b11100101;
	LDI  R30,LOW(229)
	RJMP _0x2060001
;    break;
;    case 'H' :
_0x47:
	CPI  R30,LOW(0x48)
	LDI  R26,HIGH(0x48)
	CPC  R31,R26
	BRNE _0x48
;        return 0b10001111;
	LDI  R30,LOW(143)
	RJMP _0x2060001
;    break;
;    case 'h' :
_0x48:
	CPI  R30,LOW(0x68)
	LDI  R26,HIGH(0x68)
	CPC  R31,R26
	BRNE _0x49
;        return 0b10001111;
	LDI  R30,LOW(143)
	RJMP _0x2060001
;    break;
;    case 'L' :
_0x49:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BRNE _0x4A
;        return 0b00100101;
	LDI  R30,LOW(37)
	RJMP _0x2060001
;    break;
;    case 'l' :
_0x4A:
	CPI  R30,LOW(0x6C)
	LDI  R26,HIGH(0x6C)
	CPC  R31,R26
	BRNE _0x4B
;        return 0b00100101;
	LDI  R30,LOW(37)
	RJMP _0x2060001
;    break;
;    case 'O' :
_0x4B:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BRNE _0x4C
;        return 0b10101001;
	LDI  R30,LOW(169)
	RJMP _0x2060001
;    break;
;    case 'o' :
_0x4C:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x4D
;        return 0b10101001;
	LDI  R30,LOW(169)
	RJMP _0x2060001
;    break;
;    case 'P' :
_0x4D:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0x4E
;        return 0b11000111;
	LDI  R30,LOW(199)
	RJMP _0x2060001
;    break;
;    case 'p' :
_0x4E:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x4F
;        return 0b11000111;
	LDI  R30,LOW(199)
	RJMP _0x2060001
;    break;
;    case 'i' :
_0x4F:
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x50
;        return 0b00000001;
	LDI  R30,LOW(1)
	RJMP _0x2060001
;    break;
;    case 'I' :
_0x50:
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BRNE _0x51
;        return 0b00000001;
	LDI  R30,LOW(1)
	RJMP _0x2060001
;    break;
;    case 'R' :
_0x51:
	CPI  R30,LOW(0x52)
	LDI  R26,HIGH(0x52)
	CPC  R31,R26
	BRNE _0x52
;        return 0b10001000;
	LDI  R30,LOW(136)
	RJMP _0x2060001
;    break;
;    case 'r' :
_0x52:
	CPI  R30,LOW(0x72)
	LDI  R26,HIGH(0x72)
	CPC  R31,R26
	BRNE _0x53
;        return 0b10001000;
	LDI  R30,LOW(136)
	RJMP _0x2060001
;    break;
;    case 'F' :
_0x53:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BRNE _0x54
;        return 0b11000101;
	LDI  R30,LOW(197)
	RJMP _0x2060001
;    break;
;    case 'f' :
_0x54:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BRNE _0x55
;        return 0b11000101;
	LDI  R30,LOW(197)
	RJMP _0x2060001
;    break;
;    case 'N' :
_0x55:
	CPI  R30,LOW(0x4E)
	LDI  R26,HIGH(0x4E)
	CPC  R31,R26
	BRNE _0x56
;        return 0b10001001;
	LDI  R30,LOW(137)
	RJMP _0x2060001
;    break;
;    case 'n' :
_0x56:
	CPI  R30,LOW(0x6E)
	LDI  R26,HIGH(0x6E)
	CPC  R31,R26
	BRNE _0x57
;        return 0b10001001;
	LDI  R30,LOW(137)
	RJMP _0x2060001
;    break;
;    case '-' :
_0x57:
	CPI  R30,LOW(0x2D)
	LDI  R26,HIGH(0x2D)
	CPC  R31,R26
	BRNE _0x58
;        return 0b10000000;
	LDI  R30,LOW(128)
	RJMP _0x2060001
;    break;
;    case 0 :
_0x58:
	SBIW R30,0
	BRNE _0x59
;        return 0b00000000;
	LDI  R30,LOW(0)
	RJMP _0x2060001
;    break;
;    case 10 :
_0x59:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x5A
;        return 0b11110111;
	LDI  R30,LOW(247)
	RJMP _0x2060001
;    break;
;    case 11 :
_0x5A:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x5B
;        return 0b00110001;
	LDI  R30,LOW(49)
	RJMP _0x2060001
;    break;
;    case 12 :
_0x5B:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x5C
;        return 0b11011011;
	LDI  R30,LOW(219)
	RJMP _0x2060001
;    break;
;    case 13 :
_0x5C:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x5D
;        return 0b01111011;
	LDI  R30,LOW(123)
	RJMP _0x2060001
;    break;
;    case 14 :
_0x5D:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x5E
;        return 0b00111101;
	LDI  R30,LOW(61)
	RJMP _0x2060001
;    break;
;    case 15 :
_0x5E:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x5F
;        return 0b01111110;
	LDI  R30,LOW(126)
	RJMP _0x2060001
;    break;
;    case 16 :
_0x5F:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x60
;        return 0b11111110;
	LDI  R30,LOW(254)
	RJMP _0x2060001
;    break;
;    case 17 :
_0x60:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x61
;        return 0b00110011;
	LDI  R30,LOW(51)
	RJMP _0x2060001
;    break;
;    case 18 :
_0x61:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x62
;        return 0b11111111;
	LDI  R30,LOW(255)
	RJMP _0x2060001
;    break;
;    case 19 :
_0x62:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0x64
;        return 0b01111111;
	LDI  R30,LOW(127)
	RJMP _0x2060001
;    break;
;
;    default:
_0x64:
;        return data;
	LD   R30,Y
	RJMP _0x2060001
;    };
;}
; .FEND
;
;void display(unsigned char position, unsigned char data){
_display:
; .FSTART _display
;    video_ram[position]=data;
	ST   -Y,R26
;	position -> Y+1
;	data -> Y+0
	LDD  R30,Y+1
	LDI  R31,0
	SUBI R30,LOW(-_video_ram)
	SBCI R31,HIGH(-_video_ram)
	LD   R26,Y
	STD  Z+0,R26
;}
	ADIW R28,2
	RET
; .FEND
;
;
;void refresh_display(){
_refresh_display:
; .FSTART _refresh_display
;    cursor++;
	INC  R5
;    switch(cursor & 0b00000011){
	MOV  R30,R5
	LDI  R31,0
	ANDI R30,LOW(0x3)
	ANDI R31,HIGH(0x3)
;        case 0 :
	SBIW R30,0
	BRNE _0x68
;             seg_pattern = make_pattern(video_ram[0]);
	LDS  R26,_video_ram
	RCALL SUBOPT_0x1
;             PORTD = ((seg_pattern<<2) & 0b11111000) | (PORTD & 0b00000111);
;             PORTB = (seg_pattern & 0b11000001) | (PORTB & 0b00111110);
;             PORTB.1=1;
	SBI  0x18,1
;             PORTD.2=0;
	CBI  0x12,2
;             PORTC.5=0;
	CBI  0x15,5
;        break;
	RJMP _0x67
;        case 1 :
_0x68:
	RCALL SUBOPT_0x2
	BRNE _0x6F
;             seg_pattern = make_pattern(video_ram[1]);
	__GETB2MN _video_ram,1
	RCALL SUBOPT_0x1
;             PORTD = ((seg_pattern<<2) & 0b11111000) | (PORTD & 0b00000111);
;             PORTB = (seg_pattern & 0b11000001) | (PORTB & 0b00111110);
;             PORTB.1=0;
	CBI  0x18,1
;             PORTD.2=1;
	SBI  0x12,2
;             PORTC.5=0;
	CBI  0x15,5
;        break;
	RJMP _0x67
;        case 2 :
_0x6F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x67
;             seg_pattern = make_pattern(video_ram[2]);
	__GETB2MN _video_ram,2
	RCALL SUBOPT_0x1
;             PORTD = ((seg_pattern<<2) & 0b11111000) | (PORTD & 0b00000111);
;             PORTB = (seg_pattern & 0b11000001) | (PORTB & 0b00111110);
;             PORTB.1=0;
	CBI  0x18,1
;             PORTD.2=0;
	CBI  0x12,2
;             PORTC.5=1;
	SBI  0x15,5
;        break;
;    }
_0x67:
;}
	RET
; .FEND
;
;
;
; // Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (1<<ADLAR))
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0024 {
_read_adc:
; .FSTART _read_adc
; 0000 0025 ADMUX=adc_input | ADC_VREF_TYPE;
	RCALL SUBOPT_0x0
;	adc_input -> Y+0
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 0026 // Delay needed for the stabilization of the ADC input voltage
; 0000 0027 delay_us(10);
	__DELAY_USB 27
; 0000 0028 // Start the AD conversion
; 0000 0029 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 002A // Wait for the AD conversion to complete
; 0000 002B while ((ADCSRA & (1<<ADIF))==0);
_0x7D:
	SBIS 0x6,4
	RJMP _0x7D
; 0000 002C ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 002D return ADCH;
	IN   R30,0x5
	RJMP _0x2060001
; 0000 002E }
; .FEND
;
;
;
;
;
;#include <buttons.c>
;#define BUTTON_ON 0b00000110
;#define BUTTON_UP 0b00000110
;#define BUTTON_DOWN 0b00000101
;#define BUTTON_MENU 0b00000011
;#define BUTTON_NONE 0b00000111
;
;
;unsigned char b_long_press=0;
;
;void button_init(){
; 0000 0034 void button_init(){
_button_init:
; .FSTART _button_init
;
;}
	RET
; .FEND
;unsigned char read_adc_buttons(){
_read_adc_buttons:
; .FSTART _read_adc_buttons
;    return ((read_adc(6) & 0b10000000)>>7) | ((read_adc(7) & 0b10000000)>>6) | ((read_adc(0) & 0b10000000)>>5);
	LDI  R26,LOW(6)
	RCALL SUBOPT_0x3
	RCALL __ASRW3
	RCALL __ASRW4
	PUSH R30
	LDI  R26,LOW(7)
	RCALL SUBOPT_0x3
	RCALL __ASRW2
	RCALL __ASRW4
	POP  R26
	OR   R30,R26
	PUSH R30
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x3
	ASR  R31
	ROR  R30
	RCALL __ASRW4
	POP  R26
	OR   R30,R26
	RET
;}
; .FEND
;
;unsigned char read_button(){
_read_button:
; .FSTART _read_button
;    unsigned char i,temp_keys,keys,long_press_timeout;
;        keys=read_adc_buttons();
	RCALL __SAVELOCR4
;	i -> R17
;	temp_keys -> R16
;	keys -> R19
;	long_press_timeout -> R18
	RCALL _read_adc_buttons
	MOV  R19,R30
;        if(keys == BUTTON_NONE){
	CPI  R19,7
	BRNE _0x80
;            b_long_press=0;
	CLR  R7
;            return BUTTON_NONE;
	LDI  R30,LOW(7)
	RJMP _0x2060003
;        }
;    delay_ms(5);
_0x80:
	LDI  R26,LOW(5)
	RCALL SUBOPT_0x4
;    for(i=0;i<5;i++){
	LDI  R17,LOW(0)
_0x82:
	CPI  R17,5
	BRSH _0x83
;        temp_keys=read_adc_buttons();
	RCALL _read_adc_buttons
	MOV  R16,R30
;        if(temp_keys == keys){
	CP   R19,R16
	BRNE _0x84
;            keys= temp_keys;
	MOV  R19,R16
;        }else{
	RJMP _0x85
_0x84:
;            b_long_press=0;
	CLR  R7
;            return BUTTON_NONE;
	LDI  R30,LOW(7)
	RJMP _0x2060003
;        }
_0x85:
;    delay_ms(5);
	LDI  R26,LOW(5)
	RCALL SUBOPT_0x4
;    }
	SUBI R17,-1
	RJMP _0x82
_0x83:
;    if(b_long_press){
	TST  R7
	BREQ _0x86
;        long_press_timeout=20;
	LDI  R18,LOW(20)
;    }else{
	RJMP _0x87
_0x86:
;        long_press_timeout=100;
	LDI  R18,LOW(100)
;    }
_0x87:
;
;    while(read_adc_buttons() != BUTTON_NONE && long_press_timeout){// wait untill all keys release or long press
_0x88:
	RCALL _read_adc_buttons
	CPI  R30,LOW(0x7)
	BREQ _0x8B
	CPI  R18,0
	BRNE _0x8C
_0x8B:
	RJMP _0x8A
_0x8C:
;        delay_ms(10);
	LDI  R26,LOW(10)
	RCALL SUBOPT_0x4
;        long_press_timeout--;
	SUBI R18,1
;    };
	RJMP _0x88
_0x8A:
;    if(long_press_timeout){
	CPI  R18,0
	BREQ _0x8D
;        if(b_long_press){
	TST  R7
	BREQ _0x8E
;            b_long_press=0;
	CLR  R7
;            return BUTTON_NONE;
	LDI  R30,LOW(7)
	RJMP _0x2060003
;        }
;        b_long_press=0;
_0x8E:
	CLR  R7
;        return temp_keys;
	MOV  R30,R16
	RJMP _0x2060003
;    }else{
_0x8D:
;        b_long_press=1;
	LDI  R30,LOW(1)
	MOV  R7,R30
;        return temp_keys;
	MOV  R30,R16
;    }
;
;}
_0x2060003:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;//-------------eeprom variables-----------------
;unsigned char set_timer=50;
;unsigned char timer_on_off=0;
;unsigned int pump_pwm=250;
;
;unsigned char eeprom eep_set_timer@10;
;unsigned char eeprom eep_timer_on_off@11;
;unsigned int eeprom eep_pump_pwm@12;
;
;//----------------------------------------------
;
;unsigned char timer;         // timer variable
;#define ONE_MIN 60000
;unsigned int time_logic=0;
;
;
;#include <pump_pwm.c>
;//--------------created by Arpit singh-------------------------------------
;//   call pump_subroutine() function inside timer which is interrupted 1 ms
;//   need to call pump_init() for PORT initilization
;//   use pump() function to turn on/off pump
;//   use set_pump_pwm() function to set pump speed(duty cycle)
;//   could use pump_state variable to get pump current state (on/off)-(1/0)
;//--------------------------------------------------------------------------
;
;
;#define MAX_PWM_COUNTER 500
;unsigned int pwm_counter=0,pump_state=0;
;void pump_init(){
; 0000 0045 void pump_init(){
_pump_init:
; .FSTART _pump_init
;
;    PORTB.2=0;
	CBI  0x18,2
;    DDRB.2=1;       //use for pump(on/off) relay
	SBI  0x17,2
;}
	RET
; .FEND
;void pump_on(){
_pump_on:
; .FSTART _pump_on
;    PORTB.2=1;
	SBI  0x18,2
;}
	RET
; .FEND
;
;void pump_off(){
_pump_off:
; .FSTART _pump_off
;    PORTB.2=0;
	CBI  0x18,2
;}
	RET
; .FEND
;void set_pump_pwm(unsigned char x){
;    pump_pwm = x;
;	x -> Y+0
;}
;void pump_subroutine(){
_pump_subroutine:
; .FSTART _pump_subroutine
;    if(pump_state == 1 && pump_pwm>0){
	LDS  R26,_pump_state
	LDS  R27,_pump_state+1
	SBIW R26,1
	BRNE _0x99
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BRLO _0x9A
_0x99:
	RJMP _0x98
_0x9A:
;        pwm_counter++;
	LDI  R26,LOW(_pwm_counter)
	LDI  R27,HIGH(_pwm_counter)
	RCALL SUBOPT_0x5
;        if(pwm_counter >= MAX_PWM_COUNTER){
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLO _0x9B
;            pwm_counter = 0 ;
	LDI  R30,LOW(0)
	STS  _pwm_counter,R30
	STS  _pwm_counter+1,R30
;            pump_on();
	RCALL _pump_on
;        }else if(pwm_counter == pump_pwm){
	RJMP _0x9C
_0x9B:
	RCALL SUBOPT_0x6
	CP   R10,R26
	CPC  R11,R27
	BRNE _0x9D
;            pump_off();
	RCALL _pump_off
;        }
;    }
_0x9D:
_0x9C:
;
;}
_0x98:
	RET
; .FEND
;
;void pump(unsigned char x){     // pass 1 to turn on pump and 0 to turn off pump
_pump:
; .FSTART _pump
;    if(x){
	RCALL SUBOPT_0x0
;	x -> Y+0
	CPI  R30,0
	BREQ _0x9E
;        pump_state=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _pump_state,R30
	STS  _pump_state+1,R31
;        time_logic=0;
	RCALL SUBOPT_0x7
;        timer=set_timer;
	MOV  R8,R6
;    }else{
	RJMP _0x9F
_0x9E:
;        pump_state = 0;
	LDI  R30,LOW(0)
	STS  _pump_state,R30
	STS  _pump_state+1,R30
;        pump_off();
	RCALL _pump_off
;    }
_0x9F:
;}
	RJMP _0x2060001
; .FEND
;
;void pump_pwm_up(unsigned char x){
_pump_pwm_up:
; .FSTART _pump_pwm_up
;    if(pump_pwm+x <= MAX_PWM_COUNTER){
	RCALL SUBOPT_0x0
;	x -> Y+0
	LDI  R31,0
	ADD  R30,R10
	ADC  R31,R11
	CPI  R30,LOW(0x1F5)
	LDI  R26,HIGH(0x1F5)
	CPC  R31,R26
	BRSH _0xA0
;        pump_pwm+=x;
	LD   R30,Y
	LDI  R31,0
	__ADDWRR 10,11,30,31
;    }else{
	RJMP _0xA1
_0xA0:
;        pump_pwm=MAX_PWM_COUNTER;
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	MOVW R10,R30
;    }
_0xA1:
;}
	RJMP _0x2060001
; .FEND
;void pump_pwm_down(unsigned char x){
_pump_pwm_down:
; .FSTART _pump_pwm_down
;    if(pump_pwm>=x){
	RCALL SUBOPT_0x0
;	x -> Y+0
	MOVW R26,R10
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRLO _0xA2
;        pump_pwm-=x;
	LD   R26,Y
	CLR  R27
	__SUBWRR 10,11,26,27
;    }else{
	RJMP _0xA3
_0xA2:
;        pump_pwm=0;
	CLR  R10
	CLR  R11
;    }
_0xA3:
;}
	RJMP _0x2060001
; .FEND
;#include <state_machine.c>
;
;//-----------------------state machine --------------------
;#define STATE_OFF 0
;#define STATE_ON 1
;#define STATE_SLEEP 2
;#define STATE_SET_TIME 3
;#define STATE_SET_PWM 4
;#define STATE_SET_TIMER_ON_OFF 5
;#define STATE_EXIT 6
;#define STATE_SETTING_TIME 7
;#define STATE_SETTING_PWM 8
;#define STATE_SETTING_TIMER_ON_OFF 9
;
;//---------------------life times---------------------------
;#define STATE_LONG_PRESS_LIFE 8
;//--------------------global variables----------------------
;
;#define MAX_TIMER_COUNTER 99
;
;unsigned char state=STATE_SLEEP,state_1=0,toggle=0;

	.DSEG
;unsigned int temp;
;unsigned char state_long_press_life=0;
;unsigned int state_life=0,state_life_1=0;
;
;
;
;
;
;
;
;//-----------------functions--------------------------------
;void do_on(){
; 0000 0046 void do_on(){

	.CSEG
_do_on:
; .FSTART _do_on
;        if(!timer_on_off){
	TST  R9
	BRNE _0xA5
;            state_1=1;
	LDI  R30,LOW(1)
	STS  _state_1,R30
;        }
;        state_life_1++;
_0xA5:
	LDI  R26,LOW(_state_life_1)
	LDI  R27,HIGH(_state_life_1)
	RCALL SUBOPT_0x5
;        switch (state_1) {
	LDS  R30,_state_1
	LDI  R31,0
;        case 0 :
	SBIW R30,0
	BRNE _0xA9
;            temp=timer;
	MOV  R30,R8
	RCALL SUBOPT_0x8
;            display(2,temp%10+'0');
;            temp/=10;
;            display(1,temp%10+'0');
;            if(state_life_1%10 == 0){
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
	SBIW R30,0
	BRNE _0xAA
;                if(toggle){
	LDS  R30,_toggle
	CPI  R30,0
	BREQ _0xAB
;                    toggle=0;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0xB
;                    display(0,'T');
	LDI  R26,LOW(84)
	RJMP _0x134
;                }else{
_0xAB:
;                    toggle=1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xB
;                    display(0,0);
	LDI  R26,LOW(0)
_0x134:
	RCALL _display
;                }
;            }
;            //display(0,'T');
;        if(state_life_1>200){
_0xAA:
	RCALL SUBOPT_0xC
	BRLO _0xAD
;            state_life_1=0;
	RCALL SUBOPT_0xD
;            state_1=1;
	LDI  R30,LOW(1)
	STS  _state_1,R30
;        }
;        break;
_0xAD:
	RJMP _0xA8
;        case 1 :
_0xA9:
	RCALL SUBOPT_0x2
	BRNE _0xA8
;            temp=pump_pwm;
	RCALL SUBOPT_0xE
;            display(2,temp%10+'0');
	RCALL SUBOPT_0xF
;            temp/=10;
;            display(1,temp%10+'0');
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0xF
;            /*
;            if(state_life_1%10 == 0){
;                if(toggle){
;                    toggle=0;
;                    display(0,'P');
;                }else{
;                    toggle=1;
;                    display(0,0);
;                }
;            }
;            */
;            temp/=10;
;            display(0,temp%10+'0');
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x11
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RCALL _display
;        if(state_life_1>200){
	RCALL SUBOPT_0xC
	BRLO _0xAF
;            state_life_1=0;
	RCALL SUBOPT_0xD
;            state_1=0;
	LDI  R30,LOW(0)
	STS  _state_1,R30
;        }
;        break;
_0xAF:
;        };
_0xA8:
;}
	RET
; .FEND
;void do_off(){
_do_off:
; .FSTART _do_off
;    display(0,'o');
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
;    display(1,'F');
	RCALL SUBOPT_0x14
;    display(2,'F');
	RJMP _0x2060002
;}
; .FEND
;void do_sleep(){
_do_sleep:
; .FSTART _do_sleep
;    display(0,'-');
	RCALL SUBOPT_0x12
	LDI  R26,LOW(45)
	RCALL SUBOPT_0x15
;    display(1,'-');
	LDI  R26,LOW(45)
	RCALL SUBOPT_0x16
;    display(2,'-');
	LDI  R26,LOW(45)
	RJMP _0x2060002
;}
; .FEND
;void do_set_pwm(){
_do_set_pwm:
; .FSTART _do_set_pwm
;    display(0,'5');
	RCALL SUBOPT_0x12
	LDI  R26,LOW(53)
	RCALL SUBOPT_0x15
;    display(1,'P');
	LDI  R26,LOW(80)
	RCALL SUBOPT_0x16
;    display(2,'d');
	LDI  R26,LOW(100)
	RJMP _0x2060002
;}
; .FEND
;void do_set_time(){
_do_set_time:
; .FSTART _do_set_time
;    display(0,'T');
	RCALL SUBOPT_0x12
	LDI  R26,LOW(84)
	RCALL SUBOPT_0x15
;    display(1,'n');
	LDI  R26,LOW(110)
	RCALL SUBOPT_0x16
;    display(2,'R');
	LDI  R26,LOW(82)
	RJMP _0x2060002
;}
; .FEND
;void do_set_timer_on_off(){
_do_set_timer_on_off:
; .FSTART _do_set_timer_on_off
;    display(0,'T');
	RCALL SUBOPT_0x12
	LDI  R26,LOW(84)
	RCALL SUBOPT_0x15
;    display(1,'E');
	LDI  R26,LOW(69)
	RCALL SUBOPT_0x16
;    display(2,'N');
	LDI  R26,LOW(78)
	RJMP _0x2060002
;}
; .FEND
;void do_exit(){
_do_exit:
; .FSTART _do_exit
;    display(0,'E');
	RCALL SUBOPT_0x12
	LDI  R26,LOW(69)
	RCALL SUBOPT_0x15
;    display(1,'N');
	LDI  R26,LOW(78)
	RCALL SUBOPT_0x16
;    display(2,'D');
	LDI  R26,LOW(68)
	RJMP _0x2060002
;}
; .FEND
;void do_setting_pwm(){
_do_setting_pwm:
; .FSTART _do_setting_pwm
;    temp=pump_pwm;
	RCALL SUBOPT_0xE
;    display(2,temp%10+'0');
	RCALL SUBOPT_0xF
;    temp/=10;
;    display(1,temp%10+'0');
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0xF
;    temp/=10;
;    display(0,temp%10+'0');
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x11
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RJMP _0x2060002
;    //display(0,'P');
;}
; .FEND
;void do_setting_time(){
_do_setting_time:
; .FSTART _do_setting_time
;    temp=set_timer;
	MOV  R30,R6
	RCALL SUBOPT_0x8
;    display(2,temp%10+'0');
;    temp/=10;
;    display(1,temp%10+'0');
;    display(0,'T');
	RCALL SUBOPT_0x12
	LDI  R26,LOW(84)
_0x2060002:
	RCALL _display
;}
	RET
; .FEND
;void do_setting_timer_on_off(){
_do_setting_timer_on_off:
; .FSTART _do_setting_timer_on_off
;    if(timer_on_off){
	TST  R9
	BREQ _0xB0
;        display(0,'o');
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
;        display(1,'N');
	LDI  R26,LOW(78)
	RCALL SUBOPT_0x16
;        display(2,0);
	LDI  R26,LOW(0)
	RJMP _0x135
;    }else{
_0xB0:
;        display(0,'o');
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
;        display(1,'F');
	RCALL SUBOPT_0x14
;        display(2,'F');
_0x135:
	RCALL _display
;    }
;
;}
	RET
; .FEND
;
;void timer_up(unsigned char x){
_timer_up:
; .FSTART _timer_up
;    if(set_timer+x <= MAX_TIMER_COUNTER){
	ST   -Y,R26
;	x -> Y+0
	MOV  R26,R6
	CLR  R27
	LD   R30,Y
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRGE _0xB2
;        set_timer+=x;
	LD   R30,Y
	ADD  R6,R30
;    }else{
	RJMP _0xB3
_0xB2:
;        set_timer=MAX_TIMER_COUNTER;
	LDI  R30,LOW(99)
	MOV  R6,R30
;    }
_0xB3:
;}
	RJMP _0x2060001
; .FEND
;void timer_down(unsigned char x){
_timer_down:
; .FSTART _timer_down
;    if(set_timer>=(x+1)){
	RCALL SUBOPT_0x0
;	x -> Y+0
	LDI  R31,0
	ADIW R30,1
	MOV  R26,R6
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRLT _0xB4
;        set_timer-=x;
	LD   R26,Y
	SUB  R6,R26
;    }else{
	RJMP _0xB5
_0xB4:
;        set_timer=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
;    }
_0xB5:
;}
_0x2060001:
	ADIW R28,1
	RET
; .FEND
;
;// Declare your global variables here
;
;
;
;
;//--------------------------------
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index=0,tx_rd_index=0;
;#else
;unsigned int tx_wr_index=0,tx_rd_index=0;
;#endif
;
;#if TX_BUFFER_SIZE < 256
;unsigned char tx_counter=0;
;#else
;unsigned int tx_counter=0;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 0067 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0068 if (tx_counter)
	LDS  R30,_tx_counter
	CPI  R30,0
	BREQ _0xB6
; 0000 0069    {
; 0000 006A    --tx_counter;
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0000 006B    UDR=tx_buffer[tx_rd_index++];
	LDS  R30,_tx_rd_index
	SUBI R30,-LOW(1)
	STS  _tx_rd_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 006C #if TX_BUFFER_SIZE != 256
; 0000 006D    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDS  R26,_tx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0xB7
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
; 0000 006E #endif
; 0000 006F    }
_0xB7:
; 0000 0070 }
_0xB6:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 0077 {
; 0000 0078 while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
; 0000 0079 #asm("cli")
; 0000 007A if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
; 0000 007B    {
; 0000 007C    tx_buffer[tx_wr_index++]=c;
; 0000 007D #if TX_BUFFER_SIZE != 256
; 0000 007E    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
; 0000 007F #endif
; 0000 0080    ++tx_counter;
; 0000 0081    }
; 0000 0082 else
; 0000 0083    UDR=c;
; 0000 0084 #asm("sei")
; 0000 0085 }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 008E {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	RCALL SUBOPT_0x17
; 0000 008F // Reinitialize Timer 0 value
; 0000 0090 TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 0091 // Place your code here
; 0000 0092 refresh_display();
	RCALL _refresh_display
; 0000 0093 //pump_subroutine();
; 0000 0094 if(timer_on_off && pump_state && timer){
	TST  R9
	BREQ _0xC1
	RCALL SUBOPT_0x18
	BREQ _0xC1
	TST  R8
	BRNE _0xC2
_0xC1:
	RJMP _0xC0
_0xC2:
; 0000 0095     time_logic++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	SBIW R30,1
; 0000 0096     if(time_logic>=ONE_MIN){
	LDI  R30,LOW(60000)
	LDI  R31,HIGH(60000)
	CP   R12,R30
	CPC  R13,R31
	BRLO _0xC3
; 0000 0097         time_logic=0;
	RCALL SUBOPT_0x7
; 0000 0098         timer--;
	DEC  R8
; 0000 0099     }
; 0000 009A }
_0xC3:
; 0000 009B 
; 0000 009C }
_0xC0:
	RJMP _0x141
; .FEND
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 00A0 {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	RCALL SUBOPT_0x17
; 0000 00A1 // Place your code here
; 0000 00A2 TCNT2=0x9c;
	LDI  R30,LOW(156)
	OUT  0x24,R30
; 0000 00A3 pump_subroutine();
	RCALL _pump_subroutine
; 0000 00A4 }
_0x141:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void fetch_eeprom(){
; 0000 00A6 void fetch_eeprom(){
_fetch_eeprom:
; .FSTART _fetch_eeprom
; 0000 00A7     if(eep_set_timer>100){
	RCALL SUBOPT_0x19
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x65)
	BRLO _0xC4
; 0000 00A8         eep_set_timer=50;
	RCALL SUBOPT_0x19
	LDI  R30,LOW(50)
	RCALL __EEPROMWRB
; 0000 00A9     }
; 0000 00AA     if(eep_timer_on_off>1){
_0xC4:
	RCALL SUBOPT_0x1A
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRLO _0xC5
; 0000 00AB         eep_timer_on_off=0;
	RCALL SUBOPT_0x1A
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 00AC     }
; 0000 00AD     if(eep_pump_pwm>500){
_0xC5:
	RCALL SUBOPT_0x1B
	RCALL __EEPROMRDW
	CPI  R30,LOW(0x1F5)
	LDI  R26,HIGH(0x1F5)
	CPC  R31,R26
	BRLO _0xC6
; 0000 00AE         eep_pump_pwm=200;
	RCALL SUBOPT_0x1B
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL __EEPROMWRW
; 0000 00AF     }
; 0000 00B0     set_timer=eep_set_timer;
_0xC6:
	RCALL SUBOPT_0x19
	RCALL __EEPROMRDB
	MOV  R6,R30
; 0000 00B1     timer_on_off=eep_timer_on_off;
	RCALL SUBOPT_0x1A
	RCALL __EEPROMRDB
	MOV  R9,R30
; 0000 00B2     pump_pwm=eep_pump_pwm;
	RCALL SUBOPT_0x1B
	RCALL __EEPROMRDW
	MOVW R10,R30
; 0000 00B3 }
	RET
; .FEND
;
;void init(){
; 0000 00B5 void init(){
_init:
; .FSTART _init
; 0000 00B6     pump_init();
	RCALL _pump_init
; 0000 00B7     seg_init();
	RCALL _seg_init
; 0000 00B8     button_init();
	RCALL _button_init
; 0000 00B9     fetch_eeprom();
	RCALL _fetch_eeprom
; 0000 00BA     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 00BB }
	RET
; .FEND
;
;void main(void)
; 0000 00BE {
_main:
; .FSTART _main
; 0000 00BF // Declare your local variables here
; 0000 00C0 unsigned char button;
; 0000 00C1 // Input/Output Ports initialization
; 0000 00C2 // Port B initialization
; 0000 00C3 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00C4 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
;	button -> R17
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 00C5 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00C6 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 00C7 
; 0000 00C8 // Port C initialization
; 0000 00C9 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00CA DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 00CB // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00CC PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 00CD 
; 0000 00CE // Port D initialization
; 0000 00CF // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00D0 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 00D1 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00D2 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 00D3 
; 0000 00D4 // Timer/Counter 0 initialization
; 0000 00D5 // Clock source: System Clock
; 0000 00D6 // Clock value: 125.000 kHz
; 0000 00D7 TCCR0=(0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 00D8 TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 00D9 
; 0000 00DA // Timer/Counter 1 initialization
; 0000 00DB // Clock source: System Clock
; 0000 00DC // Clock value: Timer1 Stopped
; 0000 00DD // Mode: Normal top=0xFFFF
; 0000 00DE // OC1A output: Disconnected
; 0000 00DF // OC1B output: Disconnected
; 0000 00E0 // Noise Canceler: Off
; 0000 00E1 // Input Capture on Falling Edge
; 0000 00E2 // Timer1 Overflow Interrupt: Off
; 0000 00E3 // Input Capture Interrupt: Off
; 0000 00E4 // Compare A Match Interrupt: Off
; 0000 00E5 // Compare B Match Interrupt: Off
; 0000 00E6 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 00E7 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00E8 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00E9 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00EA ICR1H=0x00;
	OUT  0x27,R30
; 0000 00EB ICR1L=0x00;
	OUT  0x26,R30
; 0000 00EC OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00ED OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00EE OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00EF OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00F0 
; 0000 00F1 /*
; 0000 00F2 // Timer/Counter 2 initialization
; 0000 00F3 // Clock source: System Clock
; 0000 00F4 // Clock value: Timer2 Stopped
; 0000 00F5 // Mode: Normal top=0xFF
; 0000 00F6 // OC2 output: Disconnected
; 0000 00F7 ASSR=0<<AS2;
; 0000 00F8 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
; 0000 00F9 TCNT2=0x00;
; 0000 00FA OCR2=0x00;
; 0000 00FB 
; 0000 00FC 
; 0000 00FD 
; 0000 00FE // Timer/Counter 2 initialization
; 0000 00FF // Clock source: System Clock
; 0000 0100 // Clock value: 8000.000 kHz
; 0000 0101 // Mode: Normal top=0xFF
; 0000 0102 // OC2 output: Disconnected
; 0000 0103 // Timer Period: 0.032 ms
; 0000 0104 ASSR=0<<AS2;
; 0000 0105 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (1<<CS20);
; 0000 0106 TCNT2=0x00;
; 0000 0107 OCR2=0x00;
; 0000 0108 */
; 0000 0109 
; 0000 010A 
; 0000 010B 
; 0000 010C // Timer/Counter 2 initialization
; 0000 010D // Clock source: System Clock
; 0000 010E // Clock value: 1000.000 kHz
; 0000 010F // Mode: Normal top=0xFF
; 0000 0110 // OC2 output: Disconnected
; 0000 0111 // Timer Period: 0.256 ms
; 0000 0112 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0113 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (1<<CS21) | (0<<CS20);
	LDI  R30,LOW(2)
	OUT  0x25,R30
; 0000 0114 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0115 OCR2=0x00;
	OUT  0x23,R30
; 0000 0116 
; 0000 0117 
; 0000 0118 
; 0000 0119 /*
; 0000 011A // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 011B TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
; 0000 011C */
; 0000 011D // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 011E TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 011F 
; 0000 0120 // External Interrupt(s) initialization
; 0000 0121 // INT0: Off
; 0000 0122 // INT1: Off
; 0000 0123 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0124 
; 0000 0125 // USART initialization
; 0000 0126 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0127 // USART Receiver: Off
; 0000 0128 // USART Transmitter: On
; 0000 0129 // USART Mode: Asynchronous
; 0000 012A // USART Baud Rate: 9600
; 0000 012B UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 012C UCSRB=(0<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(72)
	OUT  0xA,R30
; 0000 012D UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 012E UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 012F UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0130 
; 0000 0131 // Analog Comparator initialization
; 0000 0132 // Analog Comparator: Off
; 0000 0133 // The Analog Comparator's positive input is
; 0000 0134 // connected to the AIN0 pin
; 0000 0135 // The Analog Comparator's negative input is
; 0000 0136 // connected to the AIN1 pin
; 0000 0137 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0138 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0139 
; 0000 013A /*
; 0000 013B // ADC initialization
; 0000 013C // ADC disabled
; 0000 013D ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
; 0000 013E */
; 0000 013F 
; 0000 0140 // ADC initialization
; 0000 0141 // ADC Clock frequency: 62.500 kHz
; 0000 0142 // ADC Voltage Reference: AVCC pin
; 0000 0143 // Only the 8 most significant bits of
; 0000 0144 // the AD conversion result are used
; 0000 0145 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 0146 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0147 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0148 
; 0000 0149 
; 0000 014A // SPI initialization
; 0000 014B // SPI disabled
; 0000 014C SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 014D 
; 0000 014E // TWI initialization
; 0000 014F // TWI disabled
; 0000 0150 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0151 
; 0000 0152 // Global enable interrupts
; 0000 0153 #asm("sei")
	sei
; 0000 0154 
; 0000 0155 init();
	RCALL _init
; 0000 0156 
; 0000 0157 while (1)
_0xC7:
; 0000 0158       {
; 0000 0159       // Place your code here
; 0000 015A       if(timer_on_off && pump_state && !timer){
	TST  R9
	BREQ _0xCB
	RCALL SUBOPT_0x18
	BREQ _0xCB
	TST  R8
	BREQ _0xCC
_0xCB:
	RJMP _0xCA
_0xCC:
; 0000 015B         pump(0);
	RCALL SUBOPT_0x1C
; 0000 015C         state = STATE_OFF;
; 0000 015D       }
; 0000 015E 
; 0000 015F         button = read_button();
_0xCA:
	RCALL _read_button
	MOV  R17,R30
; 0000 0160         switch (state) {
	LDS  R30,_state
	LDI  R31,0
; 0000 0161         case STATE_OFF :
	SBIW R30,0
	BRNE _0xD0
; 0000 0162             if(button == BUTTON_MENU && b_long_press){      //  menu button long pressed
	CPI  R17,3
	BRNE _0xD2
	TST  R7
	BRNE _0xD3
_0xD2:
	RJMP _0xD1
_0xD3:
; 0000 0163                 state = STATE_SET_PWM;
	RCALL SUBOPT_0x1D
; 0000 0164                 state_life=0;
; 0000 0165                 state_long_press_life=STATE_LONG_PRESS_LIFE;
; 0000 0166             }else if(button == BUTTON_ON){
	RJMP _0xD4
_0xD1:
	CPI  R17,6
	BRNE _0xD5
; 0000 0167                 pump(1);
	RCALL SUBOPT_0x1E
; 0000 0168                 state = STATE_ON;
; 0000 0169             }
; 0000 016A             if(button == BUTTON_NONE){
_0xD5:
_0xD4:
	CPI  R17,7
	BRNE _0xD6
; 0000 016B                 state_life++;
	RCALL SUBOPT_0x1F
; 0000 016C             }else{
	RJMP _0xD7
_0xD6:
; 0000 016D                 state_life=0;
	RCALL SUBOPT_0x20
; 0000 016E             }
_0xD7:
; 0000 016F 
; 0000 0170             if(state_life>100){
	RCALL SUBOPT_0x21
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLO _0xD8
; 0000 0171                 state = STATE_SLEEP;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x22
; 0000 0172                 state_life=0;
; 0000 0173             }else{
	RJMP _0xD9
_0xD8:
; 0000 0174                 do_off();
	RCALL _do_off
; 0000 0175             }
_0xD9:
; 0000 0176         break;
	RJMP _0xCF
; 0000 0177 
; 0000 0178         case STATE_ON :
_0xD0:
	RCALL SUBOPT_0x2
	BRNE _0xDA
; 0000 0179             if(button == BUTTON_MENU && b_long_press){      //  menu button long pressed
	CPI  R17,3
	BRNE _0xDC
	TST  R7
	BRNE _0xDD
_0xDC:
	RJMP _0xDB
_0xDD:
; 0000 017A                 state = STATE_SET_PWM;
	RCALL SUBOPT_0x1D
; 0000 017B                 state_life=0;
; 0000 017C                 state_long_press_life=STATE_LONG_PRESS_LIFE;
; 0000 017D             }else if(button == BUTTON_ON){
	RJMP _0xDE
_0xDB:
	CPI  R17,6
	BRNE _0xDF
; 0000 017E                 pump(0);
	RCALL SUBOPT_0x1C
; 0000 017F                 state = STATE_OFF;
; 0000 0180             }
; 0000 0181             do_on();
_0xDF:
_0xDE:
	RCALL _do_on
; 0000 0182         break;
	RJMP _0xCF
; 0000 0183 
; 0000 0184         case STATE_SLEEP :
_0xDA:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xE0
; 0000 0185             if(button == BUTTON_MENU && b_long_press){      //  menu button long pressed
	CPI  R17,3
	BRNE _0xE2
	TST  R7
	BRNE _0xE3
_0xE2:
	RJMP _0xE1
_0xE3:
; 0000 0186                 state = STATE_SET_PWM;
	RCALL SUBOPT_0x1D
; 0000 0187                 state_life=0;
; 0000 0188                 state_long_press_life=STATE_LONG_PRESS_LIFE;
; 0000 0189             }else if(button == BUTTON_ON){
	RJMP _0xE4
_0xE1:
	CPI  R17,6
	BRNE _0xE5
; 0000 018A                 pump(1);
	RCALL SUBOPT_0x1E
; 0000 018B                 state = STATE_ON;
; 0000 018C             }
; 0000 018D             do_sleep();
_0xE5:
_0xE4:
	RCALL _do_sleep
; 0000 018E         break;
	RJMP _0xCF
; 0000 018F 
; 0000 0190         case STATE_SET_TIME :
_0xE0:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xE6
; 0000 0191             if(button == BUTTON_MENU && b_long_press){      //  menu button long pressed
	CPI  R17,3
	BRNE _0xE8
	TST  R7
	BRNE _0xE9
_0xE8:
	RJMP _0xE7
_0xE9:
; 0000 0192                 do_set_time();
	RCALL _do_set_time
; 0000 0193                 state_long_press_life--;
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x24
; 0000 0194                 if(!state_long_press_life){
	BRNE _0xEA
; 0000 0195                     state = STATE_SET_TIMER_ON_OFF;
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x22
; 0000 0196                     state_life=0;
; 0000 0197                     state_long_press_life=STATE_LONG_PRESS_LIFE;
	RCALL SUBOPT_0x25
; 0000 0198                 }
; 0000 0199 
; 0000 019A             }else if(button == BUTTON_NONE){
_0xEA:
	RJMP _0xEB
_0xE7:
	CPI  R17,7
	BRNE _0xEC
; 0000 019B                 state = STATE_SETTING_TIME;
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x26
; 0000 019C             }
; 0000 019D 
; 0000 019E         break;
_0xEC:
_0xEB:
	RJMP _0xCF
; 0000 019F 
; 0000 01A0         case STATE_SET_PWM :
_0xE6:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xED
; 0000 01A1             if(button == BUTTON_MENU && b_long_press){      //  menu button long pressed
	CPI  R17,3
	BRNE _0xEF
	TST  R7
	BRNE _0xF0
_0xEF:
	RJMP _0xEE
_0xF0:
; 0000 01A2                 do_set_pwm();
	RCALL _do_set_pwm
; 0000 01A3                 state_long_press_life--;
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x24
; 0000 01A4                 if(!state_long_press_life){
	BRNE _0xF1
; 0000 01A5                     state = STATE_SET_TIME;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x22
; 0000 01A6                     state_life=0;
; 0000 01A7                     state_long_press_life=STATE_LONG_PRESS_LIFE;
	RCALL SUBOPT_0x25
; 0000 01A8                 }
; 0000 01A9             }else if(button == BUTTON_NONE){
_0xF1:
	RJMP _0xF2
_0xEE:
	CPI  R17,7
	BRNE _0xF3
; 0000 01AA                 state = STATE_SETTING_PWM;
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x26
; 0000 01AB             }
; 0000 01AC 
; 0000 01AD         break;
_0xF3:
_0xF2:
	RJMP _0xCF
; 0000 01AE 
; 0000 01AF         case STATE_SET_TIMER_ON_OFF :
_0xED:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xF4
; 0000 01B0             if(button == BUTTON_MENU && b_long_press){      //  menu button long pressed
	CPI  R17,3
	BRNE _0xF6
	TST  R7
	BRNE _0xF7
_0xF6:
	RJMP _0xF5
_0xF7:
; 0000 01B1                 do_set_timer_on_off();
	RCALL _do_set_timer_on_off
; 0000 01B2                 state_long_press_life--;
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x24
; 0000 01B3                 if(!state_long_press_life){
	BRNE _0xF8
; 0000 01B4                     state = STATE_EXIT;
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x22
; 0000 01B5                     state_life=0;
; 0000 01B6                     state_long_press_life=STATE_LONG_PRESS_LIFE;
	RCALL SUBOPT_0x25
; 0000 01B7                 }
; 0000 01B8 
; 0000 01B9             }else if(button == BUTTON_NONE){
_0xF8:
	RJMP _0xF9
_0xF5:
	CPI  R17,7
	BRNE _0xFA
; 0000 01BA                 state = STATE_SETTING_TIMER_ON_OFF;
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x26
; 0000 01BB             }
; 0000 01BC 
; 0000 01BD         break;
_0xFA:
_0xF9:
	RJMP _0xCF
; 0000 01BE 
; 0000 01BF         case STATE_EXIT :
_0xF4:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xFB
; 0000 01C0             if(button == BUTTON_MENU && b_long_press){      //  menu button long pressed
	CPI  R17,3
	BRNE _0xFD
	TST  R7
	BRNE _0xFE
_0xFD:
	RJMP _0xFC
_0xFE:
; 0000 01C1                 do_exit();
	RCALL _do_exit
; 0000 01C2                 state_life=0;
	RCALL SUBOPT_0x20
; 0000 01C3                 state = STATE_EXIT;
	LDI  R30,LOW(6)
	RJMP _0x136
; 0000 01C4                 //state = STATE_SETTING_PWM; //only for testing
; 0000 01C5             }else if(button == BUTTON_NONE){
_0xFC:
	CPI  R17,7
	BRNE _0x100
; 0000 01C6                 if(pump_state){
	RCALL SUBOPT_0x18
	BREQ _0x101
; 0000 01C7                     state = STATE_ON;
	LDI  R30,LOW(1)
	RJMP _0x136
; 0000 01C8                 }else{
_0x101:
; 0000 01C9                     state = STATE_SLEEP;
	LDI  R30,LOW(2)
_0x136:
	STS  _state,R30
; 0000 01CA                 }
; 0000 01CB             }
; 0000 01CC 
; 0000 01CD         break;
_0x100:
	RJMP _0xCF
; 0000 01CE 
; 0000 01CF         case STATE_SETTING_TIME :
_0xFB:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x103
; 0000 01D0             if(button == BUTTON_UP){
	CPI  R17,6
	BRNE _0x104
; 0000 01D1                 if(b_long_press){
	TST  R7
	BREQ _0x105
; 0000 01D2                     timer_up(5);
	LDI  R26,LOW(5)
	RJMP _0x137
; 0000 01D3                 }else{
_0x105:
; 0000 01D4                     timer_up(1);
	LDI  R26,LOW(1)
_0x137:
	RCALL _timer_up
; 0000 01D5                 }
; 0000 01D6             }else if(button == BUTTON_DOWN){
	RJMP _0x107
_0x104:
	CPI  R17,5
	BRNE _0x108
; 0000 01D7                 if(b_long_press){
	TST  R7
	BREQ _0x109
; 0000 01D8                     timer_down(5);
	LDI  R26,LOW(5)
	RJMP _0x138
; 0000 01D9                 }else{
_0x109:
; 0000 01DA                     timer_down(1);
	LDI  R26,LOW(1)
_0x138:
	RCALL _timer_down
; 0000 01DB                 }
; 0000 01DC             }else if(button == BUTTON_MENU){
	RJMP _0x10B
_0x108:
	CPI  R17,3
	BRNE _0x10C
; 0000 01DD                 time_logic=0;
	RCALL SUBOPT_0x27
; 0000 01DE                 timer=set_timer;
; 0000 01DF                 eep_set_timer=set_timer;    // eeprom write
; 0000 01E0                 if(pump_state){
	BREQ _0x10D
; 0000 01E1                     state = STATE_ON;
	LDI  R30,LOW(1)
	RJMP _0x139
; 0000 01E2                 }else{
_0x10D:
; 0000 01E3                     state = STATE_SLEEP;
	LDI  R30,LOW(2)
_0x139:
	STS  _state,R30
; 0000 01E4                 }
; 0000 01E5             }
; 0000 01E6             if(button == BUTTON_NONE){
_0x10C:
_0x10B:
_0x107:
	CPI  R17,7
	BRNE _0x10F
; 0000 01E7                 state_life++;
	RCALL SUBOPT_0x1F
; 0000 01E8                 if(state_life>600){
	RCALL SUBOPT_0x28
	BRLO _0x110
; 0000 01E9                     time_logic=0;
	RCALL SUBOPT_0x27
; 0000 01EA                     timer=set_timer;
; 0000 01EB                     eep_set_timer=set_timer;    // eeprom write
; 0000 01EC                     if(pump_state){
	BREQ _0x111
; 0000 01ED                         state = STATE_ON;
	LDI  R30,LOW(1)
	RJMP _0x13A
; 0000 01EE                     }else{
_0x111:
; 0000 01EF                         state = STATE_SLEEP;
	LDI  R30,LOW(2)
_0x13A:
	STS  _state,R30
; 0000 01F0                     }
; 0000 01F1                 }
; 0000 01F2             }else{
_0x110:
	RJMP _0x113
_0x10F:
; 0000 01F3                 state_life=0;
	RCALL SUBOPT_0x20
; 0000 01F4             }
_0x113:
; 0000 01F5             do_setting_time();
	RCALL _do_setting_time
; 0000 01F6         break;
	RJMP _0xCF
; 0000 01F7 
; 0000 01F8         case STATE_SETTING_PWM :
_0x103:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x114
; 0000 01F9             if(button == BUTTON_UP){
	CPI  R17,6
	BRNE _0x115
; 0000 01FA                 if(b_long_press){
	TST  R7
	BREQ _0x116
; 0000 01FB                     pump_pwm_up(5);
	LDI  R26,LOW(5)
	RJMP _0x13B
; 0000 01FC                 }else{
_0x116:
; 0000 01FD                     pump_pwm_up(1);
	LDI  R26,LOW(1)
_0x13B:
	RCALL _pump_pwm_up
; 0000 01FE                 }
; 0000 01FF             }else if(button == BUTTON_DOWN){
	RJMP _0x118
_0x115:
	CPI  R17,5
	BRNE _0x119
; 0000 0200                 if(b_long_press){
	TST  R7
	BREQ _0x11A
; 0000 0201                     pump_pwm_down(5);
	LDI  R26,LOW(5)
	RJMP _0x13C
; 0000 0202                 }else{
_0x11A:
; 0000 0203                     pump_pwm_down(1);
	LDI  R26,LOW(1)
_0x13C:
	RCALL _pump_pwm_down
; 0000 0204                 }
; 0000 0205             }else if(button == BUTTON_MENU){
	RJMP _0x11C
_0x119:
	CPI  R17,3
	BRNE _0x11D
; 0000 0206                 eep_pump_pwm=pump_pwm;    // eeprom write
	RCALL SUBOPT_0x29
; 0000 0207                 if(pump_state){
	BREQ _0x11E
; 0000 0208                     state = STATE_ON;
	LDI  R30,LOW(1)
	RJMP _0x13D
; 0000 0209                 }else{
_0x11E:
; 0000 020A                     state = STATE_SLEEP;
	LDI  R30,LOW(2)
_0x13D:
	STS  _state,R30
; 0000 020B                 }
; 0000 020C             }
; 0000 020D             if(button == BUTTON_NONE){
_0x11D:
_0x11C:
_0x118:
	CPI  R17,7
	BRNE _0x120
; 0000 020E                 state_life++;
	RCALL SUBOPT_0x1F
; 0000 020F                 if(state_life>800){
	RCALL SUBOPT_0x21
	CPI  R26,LOW(0x321)
	LDI  R30,HIGH(0x321)
	CPC  R27,R30
	BRLO _0x121
; 0000 0210                     eep_pump_pwm=pump_pwm;    // eeprom write
	RCALL SUBOPT_0x29
; 0000 0211                     if(pump_state){
	BREQ _0x122
; 0000 0212                         state = STATE_ON;
	LDI  R30,LOW(1)
	RJMP _0x13E
; 0000 0213                     }else{
_0x122:
; 0000 0214                         state = STATE_SLEEP;
	LDI  R30,LOW(2)
_0x13E:
	STS  _state,R30
; 0000 0215                     }
; 0000 0216                 }
; 0000 0217             }else{
_0x121:
	RJMP _0x124
_0x120:
; 0000 0218                 state_life=0;
	RCALL SUBOPT_0x20
; 0000 0219             }
_0x124:
; 0000 021A             do_setting_pwm();
	RCALL _do_setting_pwm
; 0000 021B         break;
	RJMP _0xCF
; 0000 021C 
; 0000 021D         case STATE_SETTING_TIMER_ON_OFF :
_0x114:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x132
; 0000 021E             if(button == BUTTON_UP){
	CPI  R17,6
	BRNE _0x126
; 0000 021F                 timer_on_off = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 0220             }else if(button == BUTTON_DOWN){
	RJMP _0x127
_0x126:
	CPI  R17,5
	BRNE _0x128
; 0000 0221                 timer_on_off = 0;
	CLR  R9
; 0000 0222             }else if(button == BUTTON_MENU){
	RJMP _0x129
_0x128:
	CPI  R17,3
	BRNE _0x12A
; 0000 0223                 eep_timer_on_off=timer_on_off;    // eeprom write
	RCALL SUBOPT_0x2A
; 0000 0224                 if(pump_state){
	BREQ _0x12B
; 0000 0225                     state = STATE_ON;
	LDI  R30,LOW(1)
	RJMP _0x13F
; 0000 0226                 }else{
_0x12B:
; 0000 0227                     state = STATE_SLEEP;
	LDI  R30,LOW(2)
_0x13F:
	STS  _state,R30
; 0000 0228                 }
; 0000 0229             }
; 0000 022A             if(button == BUTTON_NONE){
_0x12A:
_0x129:
_0x127:
	CPI  R17,7
	BRNE _0x12D
; 0000 022B                 state_life++;
	RCALL SUBOPT_0x1F
; 0000 022C                 if(state_life>600){
	RCALL SUBOPT_0x28
	BRLO _0x12E
; 0000 022D                     eep_timer_on_off=timer_on_off;    // eeprom write
	RCALL SUBOPT_0x2A
; 0000 022E                     if(pump_state){
	BREQ _0x12F
; 0000 022F                         state = STATE_ON;
	LDI  R30,LOW(1)
	RJMP _0x140
; 0000 0230                     }else{
_0x12F:
; 0000 0231                         state = STATE_SLEEP;
	LDI  R30,LOW(2)
_0x140:
	STS  _state,R30
; 0000 0232                     }
; 0000 0233                 }
; 0000 0234             }else{
_0x12E:
	RJMP _0x131
_0x12D:
; 0000 0235                 state_life=0;
	RCALL SUBOPT_0x20
; 0000 0236             }
_0x131:
; 0000 0237             do_setting_timer_on_off();
	RCALL _do_setting_timer_on_off
; 0000 0238         break;
	RJMP _0xCF
; 0000 0239 
; 0000 023A         default:
_0x132:
; 0000 023B             state = STATE_SLEEP;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x26
; 0000 023C         }
_0xCF:
; 0000 023D         delay_ms(10);
	LDI  R26,LOW(10)
	RCALL SUBOPT_0x4
; 0000 023E 
; 0000 023F       }
	RJMP _0xC7
; 0000 0240 }
_0x133:
	RJMP _0x133
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_video_ram:
	.BYTE 0x4

	.ESEG

	.ORG 0xA
_eep_set_timer:
	.BYTE 0x1

	.ORG 0x0

	.ORG 0xB
_eep_timer_on_off:
	.BYTE 0x1

	.ORG 0x0

	.ORG 0xC
_eep_pump_pwm:
	.BYTE 0x2

	.ORG 0x0

	.DSEG
_pwm_counter:
	.BYTE 0x2
_pump_state:
	.BYTE 0x2
_state:
	.BYTE 0x1
_state_1:
	.BYTE 0x1
_toggle:
	.BYTE 0x1
_temp:
	.BYTE 0x2
_state_long_press_life:
	.BYTE 0x1
_state_life:
	.BYTE 0x2
_state_life_1:
	.BYTE 0x2
_tx_buffer:
	.BYTE 0x8
_tx_wr_index:
	.BYTE 0x1
_tx_rd_index:
	.BYTE 0x1
_tx_counter:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	LD   R30,Y
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x1:
	RCALL _make_pattern
	MOV  R4,R30
	LSL  R30
	LSL  R30
	ANDI R30,LOW(0xF8)
	MOV  R26,R30
	IN   R30,0x12
	ANDI R30,LOW(0x7)
	OR   R30,R26
	OUT  0x12,R30
	MOV  R30,R4
	ANDI R30,LOW(0xC1)
	MOV  R26,R30
	IN   R30,0x18
	ANDI R30,LOW(0x3E)
	OR   R30,R26
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	RCALL _read_adc
	ANDI R30,LOW(0x80)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x5:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R26,_pwm_counter
	LDS  R27,_pwm_counter+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CLR  R12
	CLR  R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x8:
	LDI  R31,0
	STS  _temp,R30
	STS  _temp+1,R31
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDS  R26,_temp
	LDS  R27,_temp+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RCALL _display
	LDS  R26,_temp
	LDS  R27,_temp+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	STS  _temp,R30
	STS  _temp+1,R31
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDS  R26,_temp
	LDS  R27,_temp+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RJMP _display

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	LDS  R26,_state_life_1
	LDS  R27,_state_life_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	STS  _toggle,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	RCALL SUBOPT_0x9
	CPI  R26,LOW(0xC9)
	LDI  R30,HIGH(0xC9)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	STS  _state_life_1,R30
	STS  _state_life_1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xE:
	__PUTWMRN _temp,0,10,11
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDS  R26,_temp
	LDS  R27,_temp+1
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xF:
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RCALL _display
	LDS  R26,_temp
	LDS  R27,_temp+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	STS  _temp,R30
	STS  _temp+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x11:
	LDS  R26,_temp
	LDS  R27,_temp+1
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(111)
	RCALL _display
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(70)
	RCALL _display
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(70)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	RCALL _display
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x16:
	RCALL _display
	LDI  R30,LOW(2)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x17:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x18:
	LDS  R30,_pump_state
	LDS  R31,_pump_state+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(_eep_set_timer)
	LDI  R27,HIGH(_eep_set_timer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(_eep_timer_on_off)
	LDI  R27,HIGH(_eep_timer_on_off)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(_eep_pump_pwm)
	LDI  R27,HIGH(_eep_pump_pwm)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(0)
	RCALL _pump
	LDI  R30,LOW(0)
	STS  _state,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(4)
	STS  _state,R30
	LDI  R30,LOW(0)
	STS  _state_life,R30
	STS  _state_life+1,R30
	LDI  R30,LOW(8)
	STS  _state_long_press_life,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(1)
	RCALL _pump
	LDI  R30,LOW(1)
	STS  _state,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(_state_life)
	LDI  R27,HIGH(_state_life)
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(0)
	STS  _state_life,R30
	STS  _state_life+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	LDS  R26,_state_life
	LDS  R27,_state_life+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	STS  _state,R30
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	LDS  R30,_state_long_press_life
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	SUBI R30,LOW(1)
	STS  _state_long_press_life,R30
	RCALL SUBOPT_0x23
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(8)
	STS  _state_long_press_life,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	STS  _state,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	RCALL SUBOPT_0x7
	MOV  R8,R6
	MOV  R30,R6
	RCALL SUBOPT_0x19
	RCALL __EEPROMWRB
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0x21
	CPI  R26,LOW(0x259)
	LDI  R30,HIGH(0x259)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	MOVW R30,R10
	RCALL SUBOPT_0x1B
	RCALL __EEPROMWRW
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	MOV  R30,R9
	RCALL SUBOPT_0x1A
	RCALL __EEPROMWRB
	RJMP SUBOPT_0x18


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
