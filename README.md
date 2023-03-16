# legacy-analysis-git-log
Pour expérimenter l'analyse de legacy code via les logs git, basé sur le livre "your code as a crime scene" d'A. Tornhill
Je vais essayer de reprendre les chapitres du livre un par un.

## Introduction
TL;DR: 
le profiling decriminel à la sauce "silence des agneaux" est hollywoodien, ce qui compte ce sont les informations géographiques (les lieux des meurtres permettent de savoir où vit le tueur).

Pour étudier du code, il faut en faire une carte géographique aussi. Et la donnée équivalente aux mouvements spatiaux mais concernant le code, ce sont les logs git.


## Les outils

### Git
l'analyse de la code base se base essentiellement sur les logs git.

### Code maat
L'outils d'Adam Tornhill (avec des lignes de commande utiles pour générer les historiques svn/git ect)
https://github.com/adamtornhill/code-maat

### Cloc
Outils pour compter les lignes de code (executables disponibles pour plusieurs plateformes)
https://github.com/AlDanial/cloc

### R-studio
https://posit.co/download/rstudio-desktop/

## En pratique

### Générer des logs git

L'analyse part des logs gits, il faut donc une liste des commits:
> git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat

Possibillité de rajouter une date à partir de laquelle parser avec --after=YYYY-MM-DD ou à partir de laquelle ne plus parser --before=YYYY-MM-DD

### Premiéres analyses

Il est possible d'avoir un résumé succin avec la commande:
> java -jar maat -l historique_git.log -c git -a summary

Qui permet de connaitre le nombre de contributeurs, d'entités et d'entités modifiées.

Ou d'avoir le nombre de commits par auteurs avec le fichier:
> ./count_authors_commit.sh historique_git.log


Différentes modes d'analyses sont possibles après l'option -a , dont :
- summary: donne des stats très globales sur les modifications
- age : permet de connaitre l'age en mois de chaque fichier
- revisions : le nombre de commits faits sur chaque classes 
- authors : donne le nombre de révisions et le nombre d'auteurs par classe
- coupling : trouve les couplages les plus forts entre 2 classes (couplage = modifiées ensembles)

### Croiser les données: Mes premiers "hotspots"

Nous pourrions croiser les données de révision avec les données de complexité (que nous simplifierons en prenant le nombre de ligne de code).

Utilisez cloc pour obtenir les stats de ligne de code:
> cloc ./ --by-file --csv --quiet

Vous obtiendrez pour chaque fichier son language et les nombres de lignes de code, de commentaire et de vide.

Obtenez le nombre de commit par fichier, soit avec code maat:
> java -jar maat -l historique_git.log -c git -a revisions

soit avec le script bash dans le projet:
> ./count_commits_by_files historique_git.log

Mergez les 2 fichiers:
> echo "file,nb_revision,language,nb_blank_lines,nb_comment_lines,nb_line_of_code" > cloc_and_revisions.csv
> awk -F "," 'FNR==NR {a[$2]=$1FS$3FS$4FS$5;next} $1 in a {print $0,a[$1]}' OFS="," cloc.csv commits_by_files.csv >> cloc_and_revisions.csv

(pour chaque ligne du fichier 1, on stocke dans un tableau a les données avec comme clé la colonne 2 (le nom de fichier). Puis pour chaque ligne du fichier 2, si on trouve la première colonne dans a, on écrit la ligne courante + le contenu de a pour cette clé)


Attention: 
les noms de fichiers doivent être les même, et on arrive au soucis des renommage: certaines données de commit n'auront pas leur équivalent en ligne de code, car le fichier ne porte plus le même nom.



