        .data
I_O:     .half 0x0000                                 # 16 bit volti a rappresentare input/output(impostati a 0) 10010000

        .text
            li $s0, 7200000                     # 50 km/h -> 13,88 m/s -> (1 m / 13,88 m/s = 0,072 s) --> 0,072 * 100.000.000 = 7200000
            li $s1, 6500000                     # 55 km/h -> 15,27 m/s -> (1 m / 15,27 m/s = 0,065 s) --> 0,065 * 100.000.000 = 6500000
            li $s2, 6000000                     # 60 km/h -> 16,66 m/s -> (1 m / 16,66 m/s = 0,06 s) --> 0,06 * 100.000.000 = 6000000

inizio:     add $s3 $zero $zero                 #setto la variabile che rappresenta il numero di istruzioni
            la $s6, I_O                         #salvo l'indirizzo della cella I_O nel registro s6
	    
	    
            li $s5, 0x8000                       #il numero con il 15esimo bit a 1, la mask che corrisponde al primo sensore attraversato
	
		

passaggio1: lhu $s4, 0($s6) 			#per non sporcare il valore di s6 quando andremo ad inserire manualmente il passaggio della macchina, utilizziamo un registro terzo

						#ora settare il valore di $s4 simulando il passaggio della macchina dal primo sensore
	   
	    and $t1, $s4, $s5 			#confronto mask e valore dei sensori

	    bne $t1, $s5, passaggio1		#cicla fino a quando la macchina non è passata dal primo sensore

	    li $s5, 0xc000			#settiamo la mask con il 14esimo e 15esimo bit a 1, per controllare il passaggio (setaccio)


passaggio2: lhu $s4, 0($s6)                      #per non sporcare il valore di s6 quando andremo ad inserire manualmente il passaggio della macchina, utilizziamo un registro terzo
						#setta manualmente il bit relativo al secondo settore
	    and $t1, $s4, $s5 			#confronto mask e valore dei sensori
      
            addi $s3, $s3, 4        	        #ciclo fino a quando il confronto non si verifica, ad ogni ciclo aumento il contatore di un unità (registro s3).

 	    bne $t1, $s5, passaggio2 

	    #fine conteggio istruzioni

	    slt $t0, $s0, $s3			# controllo se il tempo che impiega la macchina a passare per il secondo sensore 
 		
  	    bne $t0, $zero reset		# con il controllo precedente sappiamo che il tempo percorso è minore di 50km/h(7200000) è minore del tempo impiegato dalla macchina (1100 0000 1000 0000)

	    li $t2, 100000000 			# aspetto un tempo di 1s che è il tempo che la macchina fotografica ci mette per fare il reset (VAL=(tx*fck)/2)
loop:       addi $t2, $t2, -1			
	    bne $t2, $zero, loop		# decremento il tempo di attesa finchè non è arrivato a 0, momento in cui la macchina è di nuovo pronta per fare la foto

 	    slt $t0, $s1, $s3			# controllo se il tempo impiegato dalla macchina è maggiore di 55km/h quindi compresa tra 50km/h e 55km/h 
 	    beq $t0, $zero, controllo2

  	    # la macchina ha superato i 50 ma non i 55
   
   	
	    li $s5, 129				# velocità compresa tra 50 km/h e 55 km/h -> 0000 0000 1000 0001 (128+1 = 129)
	    sh $s5, 0($s6)			# indico lo scatto della fotocamera salvandola in s5 e poi in memoria in s6
 	    j fine


controllo2: slt $t0, $s2, $s3			# verifico che sia compreso tra 55 e 60, come ho fatto nel controllo prima
	    beq $t0, $zero, controllo3		
     	    li $s5, 130				# velocità compresa tra 55 km/h e 60 km/h -> 0000 0000 1000 0001 (128+2 = 130)
	    sh $s5, 0($s6)			# indico lo scatto della fotocamera salvandola in s5 e poi in memoria in s6
	    j fine

controllo3: li $s5, 131				# l'unica alternativa è che la velocità sia >60 km/h -> 0000 0000 1000 0011 (128+2+1 = 131)
	    sh $s5, 0($s6)			# indico lo scatto della fotocamera salvandola in s5 e poi in memoria in s6

fine:	    li $t2, 5000000			# aspettiamo 0.05s, tempo di scatto della fotocamera. VAL = (tx*fck)/2 = 5000000
loop2:      addi $t2, $t2, -1
	    bne $t2, $zero, loop2		# decremento il tempo di scatto fino ad arrivare a 0, momento in cui posso preparare la maschera all'arrivo della successiva macchina

         
 	    
	      
reset:      
           add $s4, $zero, $zero
	   add $s5, $zero, $zero
           add $s6, $zero, $zero
            j inizio                    	#salto a inizio, controllo la prossima vettura

