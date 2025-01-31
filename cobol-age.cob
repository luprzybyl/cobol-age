IDENTIFICATION DIVISION.
       PROGRAM-ID. COBOL-AGE.
       AUTHOR. CLAUDE.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  COBOL-BIRTH-DATE.
           05  BIRTH-YEAR    PIC 9(4) VALUE 1959.
           05  BIRTH-MONTH   PIC 99   VALUE 12.
           05  BIRTH-DAY     PIC 99   VALUE 17.
           
       01  CURRENT-DATE-DATA.
           05  CURR-YEAR     PIC 9(4).
           05  CURR-MONTH    PIC 99.
           05  CURR-DAY      PIC 99.
           05  CURR-HOURS    PIC 99.
           05  CURR-MINUTES  PIC 99.
           05  CURR-SECONDS  PIC 99.
           05  CURR-HUND     PIC 99.
           05  CURR-GMT      PIC S9(4).
           
       01  AGE-DATA.
           05  YEARS         PIC 9(4).
           05  MONTHS        PIC 99.
           05  DAYS          PIC 99.
           
       01  FORMATTED-DATA.
           05  DISP-YEARS    PIC Z(4).
           05  DISP-MONTHS   PIC Z9.
           05  DISP-DAYS     PIC Z9.
           
       01  TEMP-DAYS        PIC 9(5).
       01  DAYS-IN-MONTH    PIC 99.
       01  MONTH-NUM        PIC 99.
       
       01  WS-DISPLAY-MSG   PIC X(80).
       
       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM GET-CURRENT-DATE
           PERFORM CALCULATE-AGE
           PERFORM DISPLAY-RESULT
           GOBACK.
           
       GET-CURRENT-DATE.
           MOVE FUNCTION CURRENT-DATE TO CURRENT-DATE-DATA.
           
       CALCULATE-AGE.
           COMPUTE YEARS = CURR-YEAR - BIRTH-YEAR
           
           IF CURR-MONTH < BIRTH-MONTH
               SUBTRACT 1 FROM YEARS
               COMPUTE MONTHS = 12 - (BIRTH-MONTH - CURR-MONTH)
           ELSE
               COMPUTE MONTHS = CURR-MONTH - BIRTH-MONTH
           END-IF
           
           IF CURR-DAY < BIRTH-DAY
               SUBTRACT 1 FROM MONTHS
               MOVE CURR-MONTH TO MONTH-NUM
               
               IF MONTH-NUM = 1 OR MONTH-NUM = 3 OR 
                  MONTH-NUM = 5 OR MONTH-NUM = 7 OR
                  MONTH-NUM = 8 OR MONTH-NUM = 10 OR
                  MONTH-NUM = 12
                   MOVE 31 TO DAYS-IN-MONTH
               END-IF
               
               IF MONTH-NUM = 4 OR MONTH-NUM = 6 OR
                  MONTH-NUM = 9 OR MONTH-NUM = 11
                   MOVE 30 TO DAYS-IN-MONTH
               END-IF
               
               IF MONTH-NUM = 2
                   IF FUNCTION MOD(CURR-YEAR 4) = 0
                       MOVE 29 TO DAYS-IN-MONTH
                   ELSE
                       MOVE 28 TO DAYS-IN-MONTH
                   END-IF
               END-IF
               
               COMPUTE DAYS = DAYS-IN-MONTH - (BIRTH-DAY - CURR-DAY)
           ELSE
               COMPUTE DAYS = CURR-DAY - BIRTH-DAY
           END-IF
           
           IF MONTHS < 0
               ADD 12 TO MONTHS
               SUBTRACT 1 FROM YEARS
           END-IF.
           
       DISPLAY-RESULT.
           MOVE YEARS TO DISP-YEARS
           MOVE MONTHS TO DISP-MONTHS
           MOVE DAYS TO DISP-DAYS
           STRING "COBOL is " DELIMITED BY SIZE
                  FUNCTION TRIM(DISP-YEARS) DELIMITED BY SIZE
                  " years, " DELIMITED BY SIZE
                  FUNCTION TRIM(DISP-MONTHS) DELIMITED BY SIZE
                  " months, and " DELIMITED BY SIZE
                  FUNCTION TRIM(DISP-DAYS) DELIMITED BY SIZE
                  " days old (counting from December 17, 1959)"
                  DELIMITED BY SIZE
                  INTO WS-DISPLAY-MSG
           DISPLAY FUNCTION TRIM(WS-DISPLAY-MSG).

