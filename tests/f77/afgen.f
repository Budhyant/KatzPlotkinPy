C     PROGRAM No. 1: GRID GENERATOR FOR 2-D AIRFOILS
C     ----------------------------------------------
C     THIS PROGRAM IS AN AUTOMATED COMPLEX AIRFOIL TRANSFORMATION OF THE
C       TYPE PRESENTED BY VAN DE VOOREN AND DE JONG (1970). THE RESULTING
C       AIRFOIL MAY HAVE A NON-ZERO TRAILING EDGE ANGLE. THIS FORMULATION
C       IS FOR NON-CAMBERED AIRFOILS ONLY (PROGRAMMED BY STEVEN YON, 1989).

      OPEN(8,FILE='AFOIL2.DAT',STATUS='NEW')
      OPEN(10,FILE='CP.DAT',STATUS='NEW')

      WRITE(6,*) 'READY TO START VAN DE VOOREN TRANSFORMATION'
      WRITE(6,*) 'ENTER THICKNESS COEFF. E'
      READ(5,*) E
      WRITE(6,*) 'ENTER T.E. ANGLE COEFF. K'
      READ(5,*) AK
      TL=1.0
      A=2*TL*(E+1)**(AK-1)/(2**AK)
      WRITE(6,*) 'ENTER THE ANGLE OF ATTACK IN DEGREES'
      READ(5,*) ALPHA
      AL=ALPHA/57.2958
      WRITE(6,*) 'ENTER NUMBER OF AIRFOIL PANELS,M'
      WRITE(6,*) 'WITH WHICH TO MODEL THE AIRFOIL'
      WRITE(6,*)'(NOTE THAT M SHOULD BE AN EVEN FACTOR OF 360)'
      READ(5,*) M
      ITHETA=360/M

C     THE DO LOOP WILL RUN THROUGH THE CIRCLE PLANE WITH
C     THE SPECIFIED ANGULAR INTERVAL AND TRANSFORM EACH
C     POINT TO THE AIRFOIL PLANE

      DO I=0,360,ITHETA
      IF(I.EQ.0.OR.I.EQ.360) THEN
         X=1
         Y=0
         CP=1
         WRITE(8,*) X,' ,',Y
         IF(AK.EQ.2.AND.I.EQ.0) GOTO 25
         IF(AK.EQ.2.AND.I.EQ.360) GOTO 25
         WRITE(10,*) X,' ,',CP

25    CONTINUE
         GOTO 100
      ELSE
         GOTO 50
      END IF

50    CONTINUE
         TH=I/57.2958
         R1=SQRT((A*(COS(TH)-1))**2+(A*SIN(TH))**2)
         R2=SQRT((A*(COS(TH)-E))**2+(A*SIN(TH))**2)
      IF(TH.EQ.0) THEN
         TH1=1.5708
         ELSE
         TH1=(ATAN((A*SIN(TH))/(A*(COS(TH)-1))))+3.1415927
      END IF

      IF(COS(TH)-E.LT.0.AND.SIN(TH).GT.0) THEN
         TH2=(ATAN((A*SIN(TH))/(A*(COS(TH)-E))))+3.1415927
         ELSE IF(COS(TH)-E.LT.0.AND.SIN(TH).LT.0) THEN
         TH2=(ATAN((A*SIN(TH))/(A*(COS(TH)-E))))+3.1415927
         ELSE IF(COS(TH)-E.GT.0.AND.SIN(TH).LT.0) THEN
         TH2=(ATAN((A*SIN(TH))/(A*(COS(TH)-E))))+2*3.1415927
         ELSE
         TH2=(ATAN((A*SIN(TH))/(A*(COS(TH)-E))))
      END IF

C     THIS PART COMPUTES THE TRANSFORMED POSITIONS

      COM1=((R1**AK)/(R2**(AK-1)))/((COS((AK-1)*TH2))**2+(SIN((AK-1)*
     *   TH2))**2)
      X=COM1*(COS(AK*TH1)*COS((AK-1)*TH2)+SIN(AK*TH1)*SIN((AK-1)*TH2))+
     *   TL
      Y=COM1*(SIN(AK*TH1)*COS((AK-1)*TH2)-COS(AK*TH1)*SIN((AK-1)*TH2))

      WRITE(8,*) X,' ,',Y

C     THIS PART COMPUTES THE TRANSFORMED PRESSURE
C      DISTRIBUTION

      A1=COS((AK-1)*TH1)*COS(AK*TH2)+SIN((AK-1)*TH1)*SIN(AK*TH2)
      B1=SIN((AK-1)*TH1)*COS(AK*TH2)-COS((AK-1)*TH1)*SIN(AK*TH2)
      C1=(COS(AK*TH2))**2+(SIN(AK*TH2))**2
      P=A*(1-AK+AK*E)
      D1=A1*(A*COS(TH)-P)-B1*A*SIN(TH)
      D2=A1*A*SIN(TH)+B1*(A*COS(TH)-P)

      TEMP=2*C1*(SIN(AL)-SIN(AL-TH))/(D1**2+D2**2)
      COM2=TEMP*(R2**AK)/(R1**(AK-1))
      VX=D1*SIN(TH)+D2*COS(TH)
      VY=-(D1*COS(TH)-D2*SIN(TH))
      CP=1-COM2**2*(VX**2+VY**2)

      WRITE(10,*) X,' ,',CP

100   CONTINUE
      END DO

      CLOSE(8)
      CLOSE(10)
      STOP
      END
