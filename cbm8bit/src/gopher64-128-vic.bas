!--------------------------------------------------
!- 3/2024
!--------------------------------------------------
1 REM GOPHER64/128  1200B 2.0+
2 REM UPDATED 03/02/2024 01:33A
5 POKE254,8:IFPEEK(186)>7THENPOKE254,PEEK(186)
10 SY=PEEK(65532):IFSY=61THENPOKE58,254:CLR
12 IFSY=34THENX=23777:POKEX,170:IFPEEK(X)<>170THENPRINT"<16k":STOP
15 OPEN5,2,0,CHR$(8):IFPEEK(65532)=34THENPOKE56,87:POKE54,87:POKE52,87
17 P$="ok":POKE186,PEEK(254):BA=1200:XB=1200:TB$=CHR$(32+128)
20 CR$=CHR$(13):PRINTCHR$(14);:SY=PEEK(65532):POKE53280,254:POKE53281,246
30 CO$="{light blue}":IFSY=226THENML=49152:POKE665,73-(PEEK(678)*30):UM=ML+2048:XB=9600
35 IFSY=34THENML=22273:IFPEEK(ML)<>76THENCLOSE5:LOAD"pmlvic.bin",peek(254),1:RUN
38 IFSY=34THENPOKE36879,27:CO$=CHR$(31)
40 IFSY=226ANDPEEK(ML+1)<>209THENCLOSE5:LOAD"pml64.bin",PEEK(254),1:RUN
45 IFSY=226ANDUM>0ANDPEEK(UM+1)<>24THENCLOSE5:LOAD"up9600.bin",PEEK(254),1:RUN
50 S8=0:IFSY=61THENML=4864:POKE981,15:S8=PEEK(215)AND128:IFS8=128THENSYS30643
60 IFSY=61ANDPEEK(ML+1)<>217THENCLOSE5:LOAD"pml128.bin",PEEK(254),1:RUN
70 IFSY=61ANDS8=128THENXB=2400:CO$=CHR$(159)
80 IFSY=226ANDUM>0THENSYSUM:SYSUM+3:X=PEEK(789):SYSUM+9:IFX=234THENXB=1200
90 IFSY<>34THENPOKE56579,0:REM WHY DOES THIS WORK
100 MV=ML+18:POKEMV+14,8:DD=56577:IFSY=34THENDD=37136:REM FIX BUFAP
101 REM
102 PRINT:PRINT"{clear}{down}{left}";:NC=POS(0):NL=23:IFSY=34THENNL=21
110 REM
120 PRINTCO$;"{clear}{down*2}GOPHER v1.0":PRINT"Requires Zimodem firmware 2.0+"
140 PRINT"By Bo Zimmerman (bo@zimmers.net)":PRINT:PRINT
199 REM ---- ZIMODEM SETUP
200 UN=PEEK(254):IP$="":CR$=CHR$(13)+CHR$(10)
201 PH=0:PT=0:MV=ML+18
202 PRINT "Initializing modem..."
203 GET#5,A$:IFA$<>""THEN203
205 PRINT#5,CR$;"athz0&p0f4e0";CR$;:GOSUB900:IFP$<>"ok"THEN203
208 GET#5,A$:IFA$<>""THEN208
210 PRINT#5,CR$;"ate0n0r0v1q0";CR$;
220 GOSUB900:IFP$<>"ok"THEN208
225 GOSUB9000
228 GET#5,A$:IFA$>""THEN228
230 PRINT#5,"ate0v1x1f3q0s40=248s0=1s41=0i4";CR$;CHR$(19);:L9=248
235 GOSUB900:VR=VAL(P$):IFVR<2.0THENPRINT"Zimodem init failed: ";P$:STOP
240 GOSUB900:IFP$<>"ok"THEN203
245 GET#5,A$:IFA$<>""THEN245
280 DIMBU$(30,1):BU=0
290 DIMPA$(100):DIMPA(4):DIMSC$(25):DIMSC(25):REM top,bot,showtop,numlink
300 PRINT"Enter a host:port, eg:"
311 PRINT" gopher.quux.org:70"
320 PRINT":";:GOSUB9500:UR$=P$:IFUR$=""THENEND
330 IFVAL(RIGHT$(UR$,1))=0ANDRIGHT$(UR$,1)<>"0"THENUR$=UR$+":70"
500 BU$(0,0)=UR$:BU$(0,1)="":GOTO2000:REM -- GO BEGIN!
598 REM --- TRANSMIT P$ TO THE OPEN SOCKET !
600 OP$=P$:SYSML+9:C8$=MID$(STR$(PEEK(MV+8)),2):E$="ok":IFVR>3THENE$=C8$
610 PRINT#5,"ats42=";C8$;"tp+";QU$;P$;QU$
620 SYSML:IF(PEEK(DD)AND16)=0THENPRINT"{red}Lost connection";CO$:RETURN
625 IFP$<>E$THENPRINT"{reverse on}{red}xerr:'";P$;"'";E$;"'{reverse off}";CO$;P$:P$=OP$:GOTO600
630 RETURN
650 OP$=P$:SYSML+9:C8$=MID$(STR$(PEEK(MV+8)),2):PN$=MID$(STR$(LEN(P$)),2)
660 PRINT#5,"ats42=";C8$;"t+";PN$:PRINT#5,P$:E$="ok":IFVR>3THENE$=C8$
670 SYSML:IF(PEEK(DD)AND16)=0THENPRINT"{red}Lost connection";CO$:RETURN
675 IFP$<>E$THENPRINT"xerr:'";P$;"'";E$;"'":P$=OP$:GOTO650
680 RETURN
798 REM --- GET P$ FROM SOCKET P
800 P$="":E=0
810 GOSUB930:IFP0<>PANDP0<0THENPRINT"Unexpected packet id: ";P0;"/";P:STOP
820 IFP0=0THENE=1:RETURN:REM FAIL
830 RETURN
898 REM --- GET E$ FROM MODEM, OR ERROR
900 E$=""
910 SYSML
920 IFE$<>""ANDP$<>E$THENPRINT"{reverse on}{red}Comm error. Expected ";E$;", Got ";P$;CO$;"{reverse off}"
925 RETURN
927 REM ---- LOW LVL PACKET READ
930 PR=0:GET#5,P$:IFP$<>""THEN930
940 PRINT#5,CHR$(17);
945 SYSML+6:P0=PEEK(MV+2):P1=PEEK(MV+4):P2=PEEK(MV+6)
950 PL=PEEK(MV+0):CR=PEEK(MV+1):C8=PEEK(MV+8)
960 IFP0>0ANDP2<>C8THEN985
970 IFP1=0THENP$=""
980 IFP0>0ORCR=0THENRETURN
985 GET#5,P$:IFP$<>""THEN985
990 PRINT"{yellow}PACKET-RETRY";CO$:PRINT#5,"atl":GOTO945
995 PRINT"Expected ";E$;", got ";A$:STOP
998 REM --- CONNECT TO HOST
1000 E=0:QU$=CHR$(34):REM BEGIN!
1010 AT$="":IFXB>0ANDBA>0ANDXB<>BATHENAT$="s43="+MID$(STR$(XB),2)
1020 GET#5,A$:IFA$<>""THEN1020
1100 PRINT#5,"ath"+AT$+"&d10&m13&m10cp";QU$;UR$;QU$:E=0
1105 GOSUB900:SP=0:IFP$="ok"THEN1020
1110 IFLEN(P$)>8ANDLEFT$(P$,8)="connect "THENP=VAL(MID$(P$,9)):GOTO1200
1112 IFLEN(P$)=0ANDE<3THENE=E+1:GOTO1105
1115 PRINT"{pink}{reverse on}Unable to connect to ";UR$;"{reverse off}";CO$:E=1:RETURN
1120 IT=TI+40
1130 P9=0:GOSUB800:IFP$<>""THENIT=TI+10
1140 IFTI<ITTHEN1130
1200 PRINT"{reverse on}{light green}Connected to ";UR$;" on channel";P;", Reading...{reverse off}";CO$;
1201 IFXB<>9600THEN1205
1202 SYSUM:SYSUM+3:IFPEEK(789)=234THENSYSUM+9:GOTO1210
1203 BA=XB:POKEUM+19,1:PRINT#5,"at":GOSUB9000:GOSUB9000
1205 IFXB<>2400THEN1210
1206 NP=0:IFPEEK(2614)>0THENNP=20
1207 BA=XB:POKE2576,10:POKE2578,PEEK(59490+NP):POKE2579,PEEK(59491+NP)
1208 POKE2582,170:POKE2583,1:IFNP>0THENPOKE2582,154
1210 PRINT#5,"at":GOSUB9000:GOSUB9000
1220 RETURN
1299 REM -- REQUEST PAGE 
1300 P$=UR$:GOSUB600:FORI=0TO4:PA(I)=0:NEXT:PT=0:X=0
1310 IFPEEK(DD)AND16=0ORPT>10ORX>100THEN1390
1320 GOSUB930:IFP$=""THENPT=PT+1:GOTO1310
1330 PT=0:PA$(X)=P$:X=X+1:GOTO1310
1390 PA(1)=X-1:PRINT#5,"ath0":GOSUB9000:RETURN
1999 REM REQUEST PAGE, BUILD IT
2000 UR$=BU$(BU,0):GOSUB1000:IFE>0THEN300
2010 UR$=BU$(BU,1):GOSUB1300:PRINT"{reverse on}Parsing...{reverse off}";
2100 PL=PA(2):SL=0:FORI=0to25:SC$(I)="":SC(I)=-1:NEXT
2110 IFSL>=NLORPL>=PA(1)THEN2500
2120 P$=PA$(PL):LS$=LEFT$(P$,1):LS=VAL(LS$):P$=MID$(P$,2)
2130 IFLS$="0"ORLS=1ORLS=7THENSC(SL)=PL
2140 GOSUB9250:SC$(SL)=PN$(0)
2190 PL=PL+1:SL=SL+1:GOTO2110
2500 SE=-1:SF=0
2510 FORI=0TONL:IFSC(I)>=0ANDSE=-1THENSE=I
2520 NEXT
2600 PRINT"{clear}";
2605 PRINT"{home}";:RC$=CHR$(128+13):LC=SF+NC
2610 FORI=0TONL:IFI=SETHENPRINT"{reverse on}";
2620 IFSF=0THENPRINTLEFT$(SC$(I),NC);:GOTO2680
2625 L=LEN(SC$(I)):IFL<SFTHEN2680
2630 IFL>=LCTHENPRINTMID$(SC$(I),SF,NC);:GOTO2680
2640 PRINTMID$(SC$(I),SF);
2680 IFI=SETHENPRINT"{reverse off}";
2690 PRINTRC$;:NEXT
2695 PRINT"{reverse on}CRSR U/D/L/R, Q, RET:{reverse off}{up}";CHR$(128+13);
2699 REM -- MAIN MENU
2700 GETA$:IFA$=""THEN2700
2710 IFA$="{up}"THEN3000
2715 IFA$="{down}"THEN3100
2720 IFA$="{left}"THEN3200
2725 IFA$="{right}"THEN3300
2730 IFA$="q"THEN3400
2740 IFA$=CHR$(13)THEN3500
2750 GOTO 2700
3000 I=SE-1
3010 IFI<0THEN3050
3020 IFSC(I)>=0THENSE=I:GOTO2605
3030 I=I-1:GOTO3010
3050 IFPA(2)<=0THEN2700
3060 PA(2)=PA(2)-NL:IFPA(2)<0THENPA(2)=0
3070 PRINT"PARSING...";:GOTO2100
3100 I=SE+1
3110 IFI>=NLTHEN3150
3120 IFSC(I)>=0THENSE=I:GOTO2605
3130 I=I+1:GOTO3110
3150 IFPL>=PA(1)THEN2700
3160 PA(2)=PL:PRINT"PARSING...";:GOTO2100
3200 IFSF=0THEN3230
3210 SF=SF-NC:IFSF<0THENSF=0
3220 GOTO2600
3230 IFBU=0THEN2700
3240 GOSUB9300:PRINT"PREVIOUS PAGE (Y/N)?";
3250 GETA$:IFA$="n"THENGOSUB9300:GOTO2700
3260 IFA$<>"y"THEN3250
3270 BU=BU-1:GOSUB9300:PRINT"LOADING...";:GOSUB9000:GOTO2000
3300 IFSF+NC>80THEN2700
3310 SF=SF+NC:GOTO2600
3400 GOSUB9300:PRINT"QUIT (Y/N)?";
3410 GETA$:IFA$="n"THENGOSUB9300:GOTO2700
3420 IFA$<>"y"THEN3410
3430 PRINT#5,"atz":GOSUB900:CLOSE5:END
3500 GOSUB9300:PRINT"OPEN (Y/N)?";
3510 GETA$:IFA$="n"THENGOSUB9300:GOTO2700
3515 IFA$<>"y"THEN3510
3520 GOSUB9300:PRINT"LOADING...";:GOSUB9000
3530 IFLEFT$(PA$(SC(SE)),1)="1"THEN3600
3540 IFLEFT$(PA$(SC(SE)),1)="0"THEN4000
3550 IFLEFT$(PA$(SC(SE)),1)="7"THEN5000
3590 GOSUB9300:PRINT"ERROR.";:GOTO2700
3600 IFBU>=30THEN3590
3610 P$=PA$(SC(SE)):GOSUB9200:IFVAL(PN$(3))=0THENPN$(3)="70"
3620 BU=BU+1:BU$(BU,0)=PN$(2)+":"+PN$(3):BU$(BU,1)=PN$(1)
3630 GOTO2000
4000 IFBU>=30THEN3590
4010 P$=PA$(SC(SE)):GOSUB9200:IFVAL(PN$(3))=0THENPN$(3)="70"
4020 BU=BU+1:BU$(BU,0)=PN$(2)+":"+PN$(3):BU$(BU,1)=PN$(1)
4030 UR$=PN$(2)+":"+PN$(3):GOSUB1000:IFE>0THEN3590
4040 UR$=PN$(1):GOSUB1300
4050 FORI=0TOPA(1):PA$(I)="i"+PA$(I):IFLEN(PA$(I))<81ORPA(1)=100THEN4090
4060 FORX=PA(1)TOISTEP-1:PA$(X+1)=PA$(X):NEXT:PA(1)=PA(1)+1
4070 PA$(I+1)=MID$(PA$(I),79):PA$(I)=LEFT$(PA$(I),80)
4090 NEXT:GOTO2100
5000 GOSUB9300:PRINT"SEARCH: ";:GOSUB9500:IFP$=""THENGOSUB9300:GOTO2700
5010 SP$=P$:P$=PA$(SC(SE)):GOSUB9200:IFVAL(PN$(3))=0THENPN$(3)="70"
5020 BU=BU+1:BU$(BU,0)=PN$(2)+":"+PN$(3):BU$(BU,1)=PN$(1)+CHR$(7)+SP$
5030 GOTO2000
9000 TT=TI+100
9010 SYSML+12:IFTI<TTTHEN9010
9015 GET#5,A$:IFA$>""THEN9015
9020 RETURN
9200 X=1:I=1:PN=0:REM -- TABERATE
9210 PN$(PN)="":
9220 IFMID$(P$,I,1)=TB$ANDI>XTHENPN$(PN)=MID$(P$,X,I-X):PN=PN+1:X=I+1
9230 I=I+1:IFI<LEN(P$)ANDPN<11THEN9220
9240 RETURN
9250 I=1:X=LEN(P$)
9260 IFX=IORMID$(P$,I,1)=TB$THENPN$(0)=LEFT$(P$,I):RETURN
9270 I=I+1:GOTO9260
9300 PRINT"{up}";CHR$(128+13);:FORI=1TONC:PRINT" ";:NEXT
9310 PRINT"{up}";CHR$(128+13);:RETURN
9500 PRINT"{reverse on} {reverse off}{left}";:P$=""
9510 GETA$:IFA$=""THEN9510
9520 IFA$=CHR$(13)THENPRINT" {left}":RETURN
9530 IFA$<>CHR$(20)THENPRINTA$;"{reverse on} {reverse off}{left}";:P$=P$+A$:GOTO9510
9540 IFP$=""THEN9510
9550 P$=LEFT$(P$,LEN(P$)-1):PRINT" {left*2} {left}{reverse on} {reverse off}{left}";:GOTO9510
50000 OPEN5,2,0,CHR$(8)
50010 GET#5,A$:IFA$<>""THENPRINTA$;
50020 GETA$:IFA$<>""THENPRINT#5,A$;
50030 GOTO 50010
55555 U=8:F$="gopher":OPEN1,U,15,"s0:"+F$:CLOSE1:SAVE(F$),U:VERIFY(F$),U
