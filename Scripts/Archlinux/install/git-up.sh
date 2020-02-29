#!/bin/bash

# verifica se disponi degli ultimi file di github
echo "Verifica prima i file più recenti online"
git pull

# Esegue il backup di tutti i files nella cartella del progetto
git add --all .

# Dai un commento al commit
echo "####################################"
echo "Scrivi il tuo Commento!"
echo "####################################"

read input

# Effettua il commit nel repository locale con un messaggio contenente i dettagli dell'ora e il testo di commit

git commit -m "$input"

#  Invia i file locali a github

git push -u origin master

echo "################################################################"
echo "###################    Repository Aggiornato    ######################"
echo "################################################################"
