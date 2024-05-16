        .data
I_O     .half 0                                 # 16 bit volti a rappresentare input/output(impostati a 0)

        .text
            li $s0, 7200000                     # 50 km/h valore da controllare
            li $s1, 6500000                     # 55 km/h
            li $s2, 6000000                     # 60 km/h



inizio:     add $s3 $zero $zero                 #setto la variabile che rappresenta il numero 
            la $s6, IN_OUT                      #salvo l'indirizzo della cella IN_OUT nel registro s6
            li $s5, 268505088                   #(268505088 = 0x10011000)inserisco nel registro $s5, il numero con il 12 bit a 1, la mia mask.

						#cosi facendo settiamo i primi 12 bit a 1 e lasciamo i restanti 20 a 0


passo1:     lh $s4, 0($s6)                      #controllo con il registro s4 il contenuto(valore) della cella in memoria puntata da t0, il mio IN_OUT
                                                #settare il bit a 1 del sensore tramite il SetValue
                                                #passaggio della macchina
                                            
                                                #saranno tutte e due a 0  e attivo quindi i primo sensore
            and $t1, $s4, $s5       	        #controllo se la MASK e la cella hanno gli stessi bit corrispondenti, indicando il passaggio della macchina al primo sensore

	    bne $t1, $s5, passo1         
	
            li $s5, 268513280                    #(12288= 0x10013000) setto ad 1 il dodicesimo e il tredicesimo bit della Mask (i bit dei sensori)

# di base faccio lo stesso del primo passo ma la macchina essendo non ancora passata ma in viaggio aggiungo un ciclo per simulare il movimento della macchina

#inizio conteggio istruzioni
passo2:     lh $s4, 0($s6)                      #stesso controllo di prima anche sul secondo sensore
                                                #settare adesso il bit a 1 del sensore (senza spegnere il bit del primo sensore!)
                                                #immaginando che la macchina stia passando 
            and $t1, $s4, $s5         	        #confronto Mask e cella verifico se la macchina è passata dal secondo sensore

            addi $s3, $s3, 1        	        #ciclo fino a quando il confronto non si verifica, ad ogni ciclo aumento il contatore di un unità (registro s3).
	    
            bne $t1, $s5, passo2 
#fine conteggio istruzioni

            mul $s3, $s3, 4                    # moltiplico il valore di $s3 per 4, ora possiamo confrontare le istruzioni che sono state eseguite tra un sensore ed un altro

            slt $t0, $s0, $s3                   #verifico che il numero di cicli (il tempo) sia sia minore o maggiore rispetto a quelli a 50km/h
            bne $t0, $zero, reset  	            #se la velocità è minore, salto a reset, per poi controllare alre macchine al passaggio

        
            slt $t0, $s1, $s3                   #se il tempo di passaggio della vettura è maggiore di 55 (velocità compresa tra 50 e 55)	
            beq $t0, $zero, ricerca2    	
	    
            li $s5, 268513538                   #(268513538=0x10013102)in caso il tempo sia compreso tra 50 e 55, setto l'I_O attivando il bit in posizione 8, e attivamdo il bit in pos 1 della cella, 
            sh $s5, 0($s6) 	                    #indicando lo scatto della fotocamera, salvandola prima in un registro s5 e poi copiando i bit con una sh.
            
	    j fine                              #salto a fine


ricerca2:   slt $t0, $s2, $s3           #verifico che sia compresa tra 55 e 60,
            beq $t0, $zero, ricerca3    
            li $s5, 268513794           #(268513794=0x10013202)in caso il tempo sia compreso tra 80 e 90, setto l'in_out accendendo il bit in posizione 9, e attivo il bit in pos 1 della cella, 
            sh $s5, 0($s6)              #indicando lo scatto della fotocamera, salvandola prima in un registro s5 e poi copiando i bit con una sh.
            j fine                      #jumpo a fine

ricerca3:   li $s5, 268514050           #(268514050=0x10013302)i 2 casi precedenti non sono verificati, si entra in automatico nel caso della velocità maggiore di 90 
            sh $s5, 0($s6)              
            
fine:      li $t9, 25000000            #aspettiamo 0.1 secondi, tempo di scatto della fotocamera.     val=(txfck)/2= 25000000

loop2:      addi $t9, $t9, -1
            bne $t9, $zero, loop2
            
# resetto se viene superato qualche limite di velocità da una macchina per prepare il programma a un altro giro

            li $s5, -16                 #(-16=0x11111100), preparo una maschera per rimettere il bit 1 della cella a 0
            lh $s4, 0($s6)              #leggo e salvo in s4 i bit della cella IN_OUT
            and $t1, $s5, $s4           #rimetto il primo  bit della cella a 0 facendo una "and" tra il valore della mask e quello appena letto e salvato in s4, 
            sh $t1, 0($s6)              #così da indicare il completamento dello scatto. metto i nuovi bit (salvati a t1) nella cella IN_OUT tramite una sh
            
reset:      li $t1, 0                   #settare a 0 tutta la IN_OUT, così da poter tornare a inizio per poi leggere il tempo di una nuova vettura, 
            sh $t1, 0($s6)              #salvando in t1 il valore a 0 e poi andandolo a mettere in IN_OUT
            j inizio                    #salto a inizio, controllo la prossima vettura
