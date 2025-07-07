import os

def process_and_concat_asm_files(input_dir, output_file):
    with open(output_file, 'w') as outfile:
        for filename in os.listdir(input_dir):
            if filename.endswith('.asm'):
                filepath = os.path.join(input_dir, filename)
                with open(filepath, 'r') as readfile:
                    # Lire toutes les lignes du fichier
                    lines = readfile.readlines()

                    # Vérifier si la deuxième ligne contient uniquement "	db $00"
                    if lines[1].strip() == 'db $00':
                        continue
                    
                    outfile.write("\n")
                    
                    # Remplacer la première ligne par le nom du fichier sans l'extension
                    if lines:
                        file_name_without_extension = os.path.splitext(filename)[0]
                        lines[0] = f"{file_name_without_extension}\n"
                        
                    # Écrire les lignes modifiées dans le fichier de sortie
                    for line in lines:
                        # Supprimer "db" s'il est présent au début de la ligne
                        if line.startswith('	db '):
                            processed_line = line.replace('	db ', '', 1)
                            outfile.write(processed_line)
                        else:
                            outfile.write(line)
                    outfile.write("\n\n")

# Exemple d'utilisation
input_directory = '../data/wildPokemons/maps/'
output_filename = 'all_spawns.txt'
process_and_concat_asm_files(input_directory, output_filename)