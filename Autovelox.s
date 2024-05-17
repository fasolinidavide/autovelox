        .data
I_O     .half 0                                 # 16 bit volti a rappresentare input/output(impostati a 0)

        .text
            li $s0, 7200000                     # 50 km/h valore da controllare
            li $s1, 6500000                     # 55 km/h
            li $s2, 6000000                     # 60 km/h

inizio:     add $s3 $zero $zero                 #setto la variabile che rappresenta il numero di istruzioni
            la $s6, I_O                         #salvo l'indirizzo della cella I_O nel registro s6
	    
	    
            li $s5, 32768                      #il numero con il 15esimo bit a 1, la mask che corrisponde al primo sensore attraversato
	
		

passo1: lh $s4, 0($s6) 				#per non sporcare il valore di s6 quando andremo ad inserire manualmente il passaggio della macchina, utilizziamo un registro terzo

						#ora settare il valore di $s4 simulando il passaggio della macchina dal primo sensore
	   
	and $t1, $s4, $s5 			#confronto mask e valore dei sensori

	bne $t1, $s5, passo1			#cicla fino a quando la macchina non è passata dal primo sensore

	li $s5, 49152				#settiamo la mask con il 14esimo e 15esimo bit a 1, per controllare il passaggio (setaccio)


passo2: lh $s4, 0($s6)                          #per non sporcare il valore di s6 quando andremo ad inserire manualmente il passaggio della macchina, utilizziamo un registro terzo
						#setta manualmente il bit relativo al secondo settore
	and $t1, $s4, $s5 			#confronto mask e valore dei sensori
      
        addi $s3, $s3, 1        	        #ciclo fino a quando il confronto non si verifica, ad ogni ciclo aumento il contatore di un unità (registro s3).

 	bne $t1, $s5, passo2 

	#fine conteggio istruzioni

        mul $s3, $s3, 4                    	# moltiplico il valore di $s3 per 4, ora possiamo confrontare le istruzioni che sono state eseguite tra un sensore ed un altro

	slt $t0, $s0, $s3			# controllo se il tempo che impiega la macchina a passare per il secondo sensore 
 		
  	bne $t0, $zero reset			# con il controllo precedente sappiamo che il tempo percorso è minore di 50km/h(7200000) è minore del tempo impiegato dalla macchina


	slt $t0, $s1, $s3			# controllo se il tempo impiegato dalla macchina è tra 



reset:      
            sh $zero, 0($s6)              #resetto il registro I_O
            j inizio                    #salto a inizio, controllo la prossima vettura

