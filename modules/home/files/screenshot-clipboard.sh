#!/usr/bin/env bash
# Captura de una zona seleccionada: se copia al portapapeles y se guarda en Pictures/Screenshots
f="$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"
area="$(slurp)" || exit 0
grim -g "$area" - | tee "$f" | wl-copy
