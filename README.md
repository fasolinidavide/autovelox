# autovelox
basic autovelox in mips

Consegna:

Un sistema basato sul microprocessore MIPS R2000 (clock pari a 100 MHz) è incaricato della gestione di un sistema Autovelox per il rilevamento della velocità di autovetture.
Il sistema utilizza due sensori a distanza di un metro uno dall’altro in grado di rilevare la presenza di una autovettura.
Il programma di gestione per il microprocessore deve essere in grado di rivelare quando un’auto passa a velocità più elevata rispetto ai 50 km/h previsti dal codice della strada in un tratto urbano. Quando questo accade, dopo che è trascorso un secondo, il programma di gestione deve comandare lo scatto dell’otturatore di una macchina fotografica con un impulso di durata pari a 50 ms e poi ricominciare il controllo sulla prossima autovettura, ecc.
In particolare, le linee 15 e 14 della cella a 16 bit denominata I_O leggono i sensori che segnalano l’attraversamento quando dal livello logico basso ciascuna linea si porta al livello logico alto. La linea 15 è collegata al primo sensore che un’autovettura incontra nel senso di marcia.
La linea 7 della cella di memoria a 16 bit denominata I_O è utilizzata per comandare lo scatto della macchina fotografica.
Infine sulle linee 1 e 0 di I_O bisogna inviare un numero che rappresenta la velocità misurata secondo la seguente convenzione:
00: velocità < 50 km/h;
01: velocità compresa fra 50 e 55 km/h;
10: velocità compresa fra 55 e 60 km/h;
11: velocità > 60 km/h.
Tale informazione serve per far comparire sul fotogramma un’indicazione che permette di quantificare l’entità dell’infrazione.
Per semplicità si ipotizzi che una sola autovettura alla volta sia nella zona di misura- fotografia.
Alle celle di memoria sopra menzionate si assegnino indirizzi arbitrari che cadano, però, nell’area dei dati dell’architettura MIPS.
Il programma deve essere assemblato, linkato e sottoposto a simulazione. Si faccia una stampa commentata del sorgente del programma realizzato (corredata anche del relativo flow-chart).
