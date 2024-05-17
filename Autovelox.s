        .data
I_O     .half 0                                 # 16 bit volti a rappresentare input/output(impostati a 0)

        .text
            li $s0, 7200000                     # 50 km/h valore da controllare (72 secondi )
            li $s1, 6500000                     # 55 km/h
            li $s2, 6000000                     # 60 km/h

inizio:     add $s3 $zero $zero                 #setto la variabile che rappresenta il numero di istruzioni
            la $s6, I_O                         #salvo l'indirizzo della cella I_O nel registro s6
	    
	    
            li $s5, 32768                       #il numero con il 15esimo bit a 1, la mask che corrisponde al primo sensore attraversato
	
		

passaggio1: lh $s4, 0($s6) 			#per non sporcare il valore di s6 quando andremo ad inserire manualmente il passaggio della macchina, utilizziamo un registro terzo

						#ora settare il valore di $s4 simulando il passaggio della macchina dal primo sensore
	   
	and $t1, $s4, $s5 			#confronto mask e valore dei sensori

	bne $t1, $s5, passaggio1		#cicla fino a quando la macchina non è passata dal primo sensore

	li $s5, 49152				#settiamo la mask con il 14esimo e 15esimo bit a 1, per controllare il passaggio (setaccio)


passaggio2: lh $s4, 0($s6)                      #per non sporcare il valore di s6 quando andremo ad inserire manualmente il passaggio della macchina, utilizziamo un registro terzo
						#setta manualmente il bit relativo al secondo settore
	and $t1, $s4, $s5 			#confronto mask e valore dei sensori
      
        addi $s3, $s3, 4        	        #ciclo fino a quando il confronto non si verifica, ad ogni ciclo aumento il contatore di un unità (registro s3).

 	bne $t1, $s5, passaggio2 

	#fine conteggio istruzioni

	slt $t0, $s0, $s3			# controllo se il tempo che impiega la macchina a passare per il secondo sensore 
 		
  	bne $t0, $zero reset			# con il controllo precedente sappiamo che il tempo percorso è minore di 50km/h(7200000) è minore del tempo impiegato dalla macchina (1100 0000 1000 0000)

	li $t2, 25000000 			# aspetto un tempo di 0.5s che è il tempo che la macchina fotografica ci mette per fare il reset (VAL=(tck*fck)/2)
 loop:  addi $t2, $t2, -1			
	bne $t2, $zero, loop			# decremento il tempo di attesa finchè non è arrivato a 0, momento in cui la macchina è di nuovo pronta per fare la foto

	# controllo1
 	slt $t0, $s1, $s3			# controllo se il tempo impiegato dalla macchina è maggiore di 50km/h quindi compresa tra 50km/h e 55km/h 
 	beq $t0, $zero, controllo2

  	# la macchina ha superato i 50 ma non i 55
   
   	
	li $s5, 129				# velocità compresa tra 50 km/h e 55 km/h -> 0000 0000 1000 0001 (128+1 = 129)
	sh $s5, 0($s6)				# indico lo scatto della fotocamera salvandola in s5 e poi in memoria in s6
 	j fine


controllo2: slt $t0, $s2, $s3			# verifico che sia compreso tra 55 e 60, come ho fatto nel controllo prima
	    beq $t0, $zero, controllo3		
     	    li $s5, 130				# velocità compresa tra 55 km/h e 60 km/h -> 0000 0000 1000 0001 (128+2 = 130)
	    sh $s5, 0($s6)			# indico lo scatto della fotocamera salvandola in s5 e poi in memoria in s6
	    j fine

controllo3: li $s5, 131				# l'unica alternativa è che la velocità sia >60 km/h -> 0000 0000 1000 0011 (128+2+1 = 131)
	    sh $s5, 0($s6)			# indico lo scatto della fotocamera salvandola in s5 e poi in memoria in s6
  
reset:      
            sh $zero, 0($s6)              	#resetto il registro I_O
            j inizio                    	#salto a inizio, controllo la prossima vettura

