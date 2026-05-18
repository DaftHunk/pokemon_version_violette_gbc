import os
import re

def extraire_stats_pokemon(fichier):
    with open(fichier, 'r') as f:
        lignes = f.readlines()

    stats = {
        'hp': None,
        'attack': None,
        'defense': None,
        'speed': None,
        'special': None,
    }

    for ligne in lignes:
        ligne = ligne.strip()
        if ligne.startswith('db ') and ';' in ligne:
            valeur, commentaire = ligne.split(';', 1)
            valeur = valeur.replace('db ', '').strip()
            commentaire = commentaire.strip().lower()

            if 'base hp' in commentaire:
                stats['hp'] = valeur
            elif 'base attack' in commentaire:
                stats['attack'] = valeur
            elif 'base defense' in commentaire:
                stats['defense'] = valeur
            elif 'base speed' in commentaire:
                stats['speed'] = valeur
            elif 'base special' in commentaire:
                stats['special'] = valeur

    return stats

def generer_tableau_pokemon(dossier='.'):
    fichiers_asm = [f for f in os.listdir(dossier) if f.endswith('.asm')]
    tableau = []

    for fichier in fichiers_asm:
        nom_pokemon = os.path.splitext(fichier)[0].title()
        stats = extraire_stats_pokemon(fichier)
        ligne = [
            nom_pokemon,
            stats['hp'],
            stats['attack'],
            stats['defense'],
            stats['speed'],
            stats['special']
        ]
        tableau.append(ligne)

    return tableau

def ecrire_tableau_dans_fichier(tableau, nom_fichier='pokemon_stats.txt'):
    with open(nom_fichier, 'w') as f:
        en_tete = "ID|hp|attack|defense|speed|special\n"
        f.write(en_tete)
        for ligne in tableau:
            f.write("|".join(ligne) + "\n")

if __name__ == "__main__":
    tableau = generer_tableau_pokemon()
    ecrire_tableau_dans_fichier(tableau)
    print(f"Le tableau a été généré dans le fichier 'pokemon_stats.txt'.")