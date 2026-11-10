# FENIX - BRAISES PERDUES — VERSION FINALE

Projet Godot 4 composé de trois niveaux jouables successifs.

## Objectif
Fenix doit survivre dans trois arènes fermées en évitant les ennemis mobiles et les pointes. Le joueur dispose de trois cœurs pour toute la partie. Le chronomètre total continue entre les niveaux.

## Progression
- Niveau 1 — Braises calmes : survivre 25 secondes.
- Niveau 2 — Couloirs ardents : survivre 30 secondes.
- Niveau 3 — Cœur du Phénix : survivre 35 secondes.
- Après le niveau 3 : écran de victoire avec temps final et cœurs restants.
- À 0 cœur : écran Game Over avec temps de survie.

## Commandes
## Commandes
- WASD ou flèches : déplacement
- R : recommencer toute la partie
- Sur les écrans Game Over/Victoire : Entrée, Espace ou R pour rejouer

## Règles
- Un contact avec un ennemi ou une pointe retire un cœur.
- Après un dégât, Fenix revient au point de départ du niveau courant.
- Les ennemis reviennent également à leur position initiale.
- Fenix ne peut pas sortir de la zone visible.
- Les vies et le temps sont conservés lors du passage au niveau suivant.

## Structure
- `scenes/Level1.tscn`
- `scenes/Level2.tscn`
- `scenes/Level3.tscn`
- `scenes/Player.tscn`
- `scenes/Enemy.tscn`
- `scenes/Spike.tscn`
- `scenes/Wall.tscn`
- `scenes/GameOver.tscn`
- `scenes/Victory.tscn`
- `scripts/game_state.gd` : vies, temps total et niveau courant
- `scripts/level.gd` : logique commune aux trois niveaux
- `docs/GDD_Fenix_Braises_Perdues.pdf`

## MISE À JOUR 
- Écran START avant le jeu.
- Écran de présentation + « PRÊT ? » avant chacun des 3 niveaux.
- Niveau 2 et niveau 3 ont leur propre page d'introduction.
- Vitesse des ennemis progressive : niveau 1 < niveau 2 < niveau 3.
- Ennemis repositionnés loin du point de départ du joueur.
- Limites logiques renforcées : Fenix ne peut pas passer sous la limite basse de l'arène.
- Obstacles centraux espacés pour garder des trajectoires de fuite lisibles.


## CORRECTION APPORTER
- Le contact avec un ennemi retire maintenant toujours 1 coeur.
- Fenix revient ensuite au point de depart du niveau.
- Le minuteur total continue normalement.
