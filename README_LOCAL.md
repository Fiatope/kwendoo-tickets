L'achat de plusieurs tickets ne fonctionne pas
Le markdown previewer ne fonctionne pas
Le lien vers le site de l'organisateur n'est affiché nulle part
Les hashtags ne sont affichés nulle part
On ne sait pas combien de places il reste


[10:06, 7/18/2017] UpworkH_Eric: STP la petite mission decrite hier est assez urgente. Dan's son cadre, faudrait aussi pusher la preprod tickets sur Heroku et puller Oltranz sur tickets. Si tu me Donne's tous Les fichiers modifies pour Oltranz, je pourrai faire le pull manuellement moi meme pour t'eviter de perdre le temps
/use/src/tickets
Du coup cette petite mission couterait combien?                        
[10:09, 7/18/2017] UpworkH_Eric: Voici ticketshttp://ns357509.ip-91-121-149.eu:84/                        
[10:10, 7/18/2017] +34 633 35 67 89: La petite mission sur Migs ça peut aller vite                        
[10:10, 7/18/2017] UpworkH_Eric: C un premier proto qu'on a fait rapidement ici pour repondre a la demande

pg_restore --verbose --create --clean --no-acl --no-owner -h localhost -U alexandre -d ticketskwendoo_development_pg_db latest.dump

ssh root@ns357509.ip-91-121-149.eu
Ban_seign-rw,19

lsof -wni tcp:3000
kill -9 6590
bin/rails server -d -p84 ENV=production
bin/rails server -d -p82 ENV=production


84: TICKETS
82: AGASEKE
82: FIATOPE
80: PIGGYBANK
bin/rails server -d -p80



