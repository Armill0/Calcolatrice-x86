name "calcolatrice completa"

; Mini-Calcolatrice in Assembly x86 per Emu8086
; Supporta addizione, sottrazione, moltiplicazione e divisione
                                                              
.model small 

data segment
    ; DICHIARAZIONE DELLE VARIABILI 
    msgNum1 db "Inserisci il primo numero (0-9): $"
    msgNum2 db 10,13, "Inserisci il secondo numero (0-9): $"
    msgOp db 10,13, "Scegli operazione (+,-,*,/): $"
    msgRisultato db 10,13, "Risultato: $"
    msgResto db 10,13, "Resto: $"
    msgErrore db 10,13, "Operazione non valida. $"
    msgDivZero db 10,13, "Errore: Divisione per zero. $"
    
    num1 db ?
    num2 db ?
    operazione db ?
    risultato dw ?   ; DEFINE WORD (2 byte)
    resto db ?
    
data ends
    
code segment 
    .startup
    
    ; RICHIESTA DEL PRIMO NUMERO
    LEA DX, msgNum1
    MOV AH, 09H
    INT 21H
    
    ; INPUT PRIMO NUMERO
    MOV AH, 01H
    INT 21H
    
    ; CONVERSIONE ASCII
    SUB AL, 48
    MOV num1, AL
    
    ; RICHIESTA DEL SECONDO NUMERO
    LEA DX, msgNum2
    MOV AH, 09H
    INT 21H
    
    ; INPUT SECONDO NUMERO
    MOV AH, 01H
    INT 21H
    
    ; CONVERSIONE ASCII
    SUB AL, 48
    MOV num2, AL
    
    ; RICHIESTA TIPO OPERAZIONE
    LEA DX, msgOp
    MOV AH, 09H
    INT 21H
    
    ; INPUT OPERAZIONE
    MOV AH, 01H
    INT 21H
    MOV operazione, AL
    
    ; SWITCH CASE PER OPERAZIONI CON FUNZIONI INTEGRATE
    MOV AL, operazione           ; sposto l'operazione scelta per poterla analizzare, come se fosse uno switch case
    
    CMP AL, "+"                  ; case +  
    JE faiAddizione         
    
    CMP AL, "-"                  ; case -
    JE faiSottrazione 
    
    CMP AL, "*"                  ; case *
    JE faiMoltiplicazione
    
    CMP AL, "/"                  ; case /
    JE faiDivisione
    
    JMP erroreOperazione         ; controllo dell'errore di battitura / scelta dell'operazione
    
    ; CASISTICHE E CONTROLLI
    
    ; ADDIZIONE
    faiAddizione:
    MOV AL, num1          ; sposto il primo valore nel registro accumulator register (nella sua sezione low a 8 bit)
    ADD AL, num2          ; utilizzo il registro AL per effettuare la somma
    MOV AH, 0             ; a scopo dimostrativo, pulisco la parte high del registro AX, per azzerarla
    MOV risultato, AX     ; salvo il risultato ottenuto 
    JMP mostraRisultato   ; saltiamo alla stampa del risultato prima di terminare il programma, senza eseguire il resto del codice
    
    ; SOTTRAZIONE
    faiSottrazione:
    MOV AL, num1          ; sposto il primo valore nel registro, come nell'addizione, stesso motivo
    SUB AL, num2          ; effettuo la sottrazione in maniera similare all'addizione
    CBW                   ; Convert Byte to Word. Questo passaggio permette di distinguere un risultato positivo da uno negativo
    MOV risultato, AX     ; salvo il risultato ottenuto
    JMP mostraRisultato   ; salto alla stampa del risultato prima di terminare il programma, senza eseguire il resto del codice
    
    ; MOLTIPLICAZIONE (metodo delle addizioni ripetute)
    faiMoltiplicazione:
    MOV AL, 0     ; risultato
    MOV BL, num2  ; contatore
    MOV CL, num1  ; valore da sommare
    
    CMP BL, 0     ; se moltiplichiamo per zero, dobbiamo ottenere zero
    JE moltFine   ; salto alla funzione
    
    moltLoop:
    ADD AL, CL    ; somma ripetuta in loop
    DEC BL        ; decrementa contatore per interrompere loop
    JNZ moltLoop  ; continua fin quando contatore > 0 
    
    moltFine:
    MOV AH, 0            ; reset della parte H del registro, come ho fatto nelle precedenti operazioni
    MOV risultato, AX    ; salvo il risultato
    JMP mostraRisultato  ; salto alla stampa del risultato prima di terminare il programma, senza eseguire il resto del codice
    
    ; DIVISIONE (metodo delle sottrazioni successive)
    faiDivisione:
    MOV AL, num2      ; sposto il divisore per poterlo confrontare
    CMP AL, 0         ; controllo divisione per zero
    JE erroreDivZero  ; jump errore 
    
    MOV AL, num1      ; dividendo
    MOV BL, num2      ; divisore
    MOV CL, 0         ; quoziente (contatore) 
    
    divLoop:
    CMP AL, BL        ; confrontiamo dividendo e divisore
    JL divFine        ; SE dividendo < divisore, termina il ciclo
    
    SUB AL, BL        ; sottrazioni ripetute in loop
    INC CL            ; ad ogni ciclo, incrementa il valore del quoziente
    JMP divLoop       ; loop
    
    divFine:
    MOV resto, AL       ; salva il risultato prima di sovrascrivere AL
    MOV AH, 0           ; reset del registro 
    MOV AL, CL          ; sposta il quoziente da CL ad AL (uso CL solo temporaneamente)
    MOV risultato, AX   ; salvataggio del quoziente 
    JMP mostraDivisione
    
    stampaNumero:
    PUSH AX          ; metto tutti i valori originali dell'accumulator register nello stack
    PUSH BX          ; metto tutti i valori originali del base register nello stack
    PUSH CX          ; metto tutti i valori originali del counter register nello stack
    PUSH DX          ; metto tutti i valori originali del data register nello stack
    
    MOV BX, AX
    TEST BX, 8000H   ; testiamo il bit di segno
    JZ numPositivo   ; se 0, lo considero positivo
    
    MOV DL, '-'      ; stampo il segno meno
    MOV AH, 02H
    INT 21H
    NEG BX           ; rendo il numero positivo
    
    numPositivo:
    MOV AX, BX       ; AX adesso e' un numero da convertire, positivo 
    MOV CX, 0        ; contatore delle cifre (inizia da zero)
    MOV BX, 10       ; BX e' un divisore fisso per permettermi di gestire i risultati a doppia cifra
    
    estraiCifre:
    MOV DX, 0          ; azzero DX per evitare problemi con il calcolo
    DIV BX             ; AX / 10
    PUSH DX            ; metto il resto nello stack
    INC CX             ; incremento di 1 il contatore delle cifre
    CMP AX, 0          ; controllo se il quoziente e' uguale a 0
    JNE estraiCifre    ; se non lo e', continuo il loop
    
    stampaCifre:
    POP DX             ; POP prende dallo stack DX (sfrutto la politica LIFO) 
    ADD DL, 48         ; Conversione ASCII
   
    MOV AH, 02H        ; Stampa del carattere
    INT 21H
    LOOP stampaCifre   ; Loop per CX volte, per poter stampare tutte le cifre 
    
    ; RIPRISTINO DEI REGISTRI IN ORDINE INVERSO (LIFO)
    POP DX             
    POP CX
    POP BX
    POP AX
    RET
    
    ; STAMPA DEL RISULTATO
    mostraRisultato:
    LEA DX, msgRisultato  ; STAMPA DELLA FRASE CHE PRESENTA IL RISULTATO
    MOV AH, 09H
    INT 21H 
    
    MOV AX, risultato     ; STAMPA DEL RISULTATO
    CALL stampaNumero
    
    JMP fine           ; SALTIAMO ALLA FINE DEL PROGRAMMA
    
    ; E SE FOSSE UNA DIVISIONE? AVREMMO PIU VALORI DA MANDARE IN OUTPUT! PER CUI...
    mostraDivisione:
    LEA DX, msgRisultato  ; STAMPA DELLA FRASE CHE PRESENTA IL QUOZIENTE
    MOV AH, 09H
    INT 21H
    
    MOV AX, risultato      ; Sposto il risultato nel registro accumulatore e...
    CALL stampaNumero      ; Chiamo la funzione per la gestione delle cifre
      
    LEA DX, msgResto   ; STAMPA DELLA FRASE CHE PRESENTA IL RESTO
    MOV AH, 09H
    INT 21H
    
    MOV AL, resto      ; Carica il valore del resto
    ADD AL, 48         ; Conversione ASCII
    MOV DL, AL         ; Sposta in DL per la stampa
    MOV AH, 02H        ; Funzione per stampare carattere
    INT 21H            ; Stampa il resto
    
    JMP fine           ; Salta alla fine del programma
    
    ; E SE RISCONTRASSIMO UN ERRORE NEI CONTROLLI EFFETTUATI IN PRECEDENZA? DOVREMMO INDICARE ALL'UTENTE LA PRESENZA DELL'ERRORE!
    erroreOperazione:
    LEA DX, msgErrore  ; STAMPA DEL MESSAGGIO DI ERRORE
    MOV AH, 09H
    INT 21H
    
    JMP fine
    
    ; E SE DIVIDESSIMO UN NUMERO PER ZERO? DOVREMMO INDICARLO ALL'UTENTE!
    erroreDivZero:
    LEA DX, msgDivZero ; STAMPA DEL MESSAGGIO DI ERRORE
    MOV AH, 09H
    INT 21H
    
    JMP fine
    
    ; SIAMO DUNQUE ARRIVATI ALLA FINE DELLE OPERAZIONI E DEI CONTROLLI
    fine:
    MOV AH, 4CH        ; INTERRUZIONE DEL PROGRAMMA E RESTITUZIONE DEL CONTROLLO AL SISTEMA OPERATIVO
    INT 21H                                                                                          
    
    .exit
code ends