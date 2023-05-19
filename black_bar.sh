#!/bin/bash

# Überprüfen Sie, ob ffmpeg installiert ist
if ! command -v ffmpeg &> /dev/null
then
    echo "ffmpeg konnte nicht gefunden werden. Bitte installieren Sie es zuerst."
    exit
fi

# Videodatei, Startzeit und Endzeit anfordern
read -p "Geben Sie den Pfad zur Videodatei ein: " input_file

# Überprüfen, ob die Eingabedatei existiert
if [ ! -f "$input_file" ]; then
    echo "Die Datei '$input_file' konnte nicht gefunden werden."
    exit
fi

read -p "Geben Sie die Startzeit für den schwarzen Balken ein (Format: HH:MM:SS): " start_time
read -p "Geben Sie die Endzeit für den schwarzen Balken ein (Format: HH:MM:SS): " end_time

# Start- und Endzeit in Sekunden umwandeln
IFS=":" read start_hour start_min start_sec <<< "$start_time"
start_seconds=$((10#$start_hour*3600 + 10#$start_min*60 + 10#$start_sec))

IFS=":" read end_hour end_min end_sec <<< "$end_time"
end_seconds=$((10#$end_hour*3600 + 10#$end_min*60 + 10#$end_sec))

# Ausgabedateiname erstellen
filename=$(basename -- "$input_file")
extension="${filename##*.}"
filename="${filename%.*}"
dir=$(dirname "$input_file")
output_file="${dir}/${filename}_black-bar.${extension}"

# Schwarzen Balken mit ffmpeg hinzufügen
echo "Füge schwarzen Balken hinzu..."
if ! ffmpeg -i "$input_file" -vf "drawbox=x=878:y=611:w=1058-878:h=644-611:c=black:t=fill:enable='between(t,$start_seconds,$end_seconds)'" "$output_file"; then
    echo "Fehler beim Hinzufügen des schwarzen Balkens. Überprüfen Sie die Start- und Endzeiten und versuchen Sie es erneut."
    exit
fi

echo "Die Ausgabedatei wurde erstellt: $output_file"

# Warten auf Tastendruck, um das Skript zu beenden
read -n 1 -s -r -p "Drücken Sie eine beliebige Taste, um fortzufahren..."
