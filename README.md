# Calcolatrice-x86
Calcolatrice per operazioni basilari in linguaggio Assembly x86
![Anteprima della calcolatrice](moltiplicazione-due-cifre.png)


## 📌 Funzionalità  
- Somma, sottrazione, moltiplicazione e divisione  
- Gestione di numeri positivi e negativi  
- Output su schermo  

## 🛠️ Struttura del codice
Il codice è diviso in due sezioni principali:  
1. **Data Segment** → Contiene variabili e messaggi di output.  
2. **Code Segment** → Gestisce l'input, esegue operazioni e stampa i risultati.

## 🏗️ Implementazione  
La calcolatrice utilizza le seguenti tecniche:  
- **Switch-case simulato** con istruzioni `CMP` e `JE` per selezionare l'operazione.  
- **Moltiplicazione simulata** tramite addizioni ripetute.  
- **Gestione dei numeri negativi** con `TEST BX, 8000H` per verificare il bit di segno.  
- **Divisione con gestione del resto** per mantenere precisione.  
- **Conversione ASCII** per stampare correttamente i numeri tramite `SUB AL, 48`.  

## 📌 Esempi di Utilizzo
Inserisci il primo numero (0-9): _
Inserisci il secondo numero (0-9): _
Scegli operazione (+,-,*,/): _
Risultato: _

## 🚀 Sfide Affrontate
Durante lo sviluppo ho riscontrato difficoltà con la gestione della stampa di numeri a più cifre, l'inversione dell'ordine delle cifre con lo stack e la simulazione di operazioni matematiche avanzate.
Grazie agli esperimenti ed alla teoria legata all'architettura del processore 8086, ho costruito un algoritmo che gestisce automaticamente numeri di varie grandezze e segni.

## 📦 Installazione e Esecuzione  
Per eseguire la calcolatrice, utilizzo **Emu8086**, un emulatore per il processore Intel 8086.
### 🔧 Passaggi
1. Scarica ed installa **Emu8086** dal sito ufficiale.
2. Clona la repository su GitHub:
   '''bash
   git clone https://github.com/Armill0/Calcolatrice-x86.git
3. Apri Emu8086 e carica il file calcolatrice.asm
4. Compila ed esegui il codice direttamente dall'ambiente Emu8086.
💡 Nota
Se vuoi eseguire il programma su un vero ambiente DOS, puoi compilare il codice con NASM e testarlo in DOSBox. 

## 💻 Autore: 
Armill0

## 📝 Contributi
Se vuoi migliorare il progetto, fai una pull request o apri una issue per suggerimenti e miglioramenti!

