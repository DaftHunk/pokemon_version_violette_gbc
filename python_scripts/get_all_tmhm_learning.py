import os

# Liste des fichiers et des identifiants tmXX
fichiers = [
    "Abra", "Aerodactyl", "Alakazam", "Arbok", "Arcanine", "Articuno",
    "Beedrill", "Bellsprout", "Blastoise", "Bulbasaur", "Butterfree",
    "Caterpie", "Chansey", "Charizard", "Charmander", "Charmeleon",
    "Clefable", "Clefairy", "Cloyster", "Cubone", "Dewgong", "Diglett",
    "Ditto", "Dodrio", "Doduo", "Dragonair", "Dragonite", "Dratini",
    "Drowzee", "Dugtrio", "Eevee", "Ekans", "Electabuzz", "Electrode",
    "Exeggcute", "Exeggutor", "Farfetch'd", "Fearow", "Flareon", "Gastly",
    "Gengar", "Geodude", "Gloom", "Golbat", "Goldeen", "Golduck", "Golem",
    "Graveler", "Grimer", "Growlithe", "Gyarados", "Haunter", "Hitmonchan",
    "Hitmonlee", "Ho-Oh", "Horsea", "Hypno", "Ivysaur", "Jigglypuff",
    "Jolteon", "Jynx", "Kabuto", "Kabutops", "Kadabra", "Kakuna",
    "Kangaskhan", "Kingdra", "Kingler", "Koffing", "Krabby", "Lapras",
    "Larvitar", "Lickitung", "Machamp", "Machoke", "Machop", "Magikarp",
    "Magmar", "Magnemite", "Magneton", "Mankey", "Marowak", "Meowth",
    "Metapod", "Mew", "Mewtwo", "Misdreavus", "Moltres", "Mr_Mime", "Muk",
    "Nidoking", "Nidoqueen", "Nidoran F", "Nidoran M", "Nidorina",
    "Nidorino", "Ninetales", "Oddish", "Omanyte", "Omastar", "Onix",
    "Paras", "Parasect", "Persian", "Pidgeot", "Pidgeotto", "Pidgey",
    "Pikachu", "Pinsir", "Poliwag", "Poliwhirl", "Poliwrath", "Ponyta",
    "Porygon", "Primeape", "Psyduck", "Pupitar", "Raichu", "Rapidash",
    "Raticate", "Rattata", "Rhydon", "Rhyhorn", "Sandshrew", "Sandslash",
    "Scizor", "Scyther", "Seadra", "Seaking", "Seel", "Shellder",
    "Slowbro", "Slowpoke", "Sneasel", "Snorlax", "Spearow", "Squirtle",
    "Starmie", "Staryu", "Steelix", "Tangela", "Tauros", "Tentacool",
    "Tentacruel", "Tyranitar", "Umbreon", "Vaporeon", "Venomoth",
    "Venonat", "Venusaur", "Victreebel", "Vileplume", "Voltorb", "Vulpix",
    "Wartortle", "Weedle", "Weepinbell", "Weezing", "Wigglytuff", "Zaptos", "Zubat"
]

tm_ids = [f"tm{str(i).zfill(2)}" for i in range(1, 51)]

# Initialisation du tableau
tableau = {fichier: {tm_id: " " for tm_id in tm_ids} for fichier in fichiers}

# Vérification de la présence des identifiants tmXX dans chaque fichier
for fichier in fichiers:
    if os.path.exists(fichier + ".asm"):
        with open(fichier + ".asm", "r") as f:
            content = f.read()
            for tm_id in tm_ids:
                if tm_id in content:
                    tableau[fichier][tm_id] = "x"

# Affichage du tableau
for fichier, tms in tableau.items():
    print(f"{fichier}: {tms}")
    
input("enter to exit")