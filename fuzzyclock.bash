#!/bin/bash
# Fuzzyclock.zsh 1.2 - BASH VERSION!
# Un orologio approssimativo localizzato in romanaccio.
# Trattasi di porting dello script python FuzzyClock, dall'idea
# dell'applet per OS X FuzzyClock. Riscritto in zsh per "ottimizzare", e in bash per
# gli amici cacacazzi.
# Daniel Kertesz <daniel@spatof.org> - Novembre 2014

set -e

fuzzyness=1

minute_names=(
    "%0 spaccate"
    "%0 eccinque"
    "%0 eddieci"
    "%0 enquarto"
    "%0 evventi"
    "%0 evventicinque"
    "%0 emmezza"
    "%0 ettrentacinque"
    "%1 meno venti"
    "%1 menonquarto"
    "%1 meno dieci"
    "%1 meno cinque"
    "quasi che %1"
)

hour_names=(
    "l'una"
    "e due"
    "e tre"
    "e quattro"
    "e cinque"
    "'e sei"
    "e sette"
    "l'otto"
    "e nove"
    "e dieci"
    "l'unnici"
    "a mezza"
)

day_names=(
    "E' svario tardi"
    "E' madina presto"
    "E' madina"
    "E' quasi la mezza"
    "E' mezzoggiorno"
    "E' pomeriggio"
    "Er crepuscolo"
    "E' nnotte"
)

week_names=(
    "L'inizio de sta settimana demmerda"
    "In mezzo a sta cazzo de settimana"
    "Sta settimana demmerda che sta a fini'"
    "Weekend!"
)

timearray=($(date +"%H %M %w"))
cur_hour=${timearray[0]}
cur_minute=${timearray[1]}
cur_day=${timearray[2]}
sector=0

fuzzyclock() {
    if (( $fuzzyness == 1 || $fuzzyness == 2 )); then
        if (( $fuzzyness == 1 )); then
            if (( $cur_minute > 2 )); then
                ((sector = (cur_minute - 3) / 5 + 1))
            fi
        else
            if (( $cur_minute > 6 )); then
                ((sector = ((cur_minute - 7) / 15 + 1) * 3))
            fi
        fi

        delta=$(echo ${minute_names[$sector]} | tr -d "!'%a-z ")

        if (( (( $cur_hour + $delta ) % 12 ) > 0 )); then
            ((realhour = ( cur_hour + delta ) % 12 - 1 ))
        else
            ((realhour = 12 - (( cur_hour + delta ) % 12 + 1 )))
        fi

        # workaround
        if (( $realhour == 0 )); then
            minute_names[0]="%0 precisa"
        fi

        name=${minute_names[$sector]}
        repl=${hour_names[$realhour]}

        fuzzy_time=${name/"%$delta"/"$repl"}
    elif (( $fuzzyness == 3 )); then
        i=$(( $cur_hour / 3 ))
        fuzzy_time=${day_names[$i]}
    else
        if (( $cur_day == 1 )); then
            fuzzy_time=${week_names[0]}
        elif (( $cur_day >= 2 && $cur_day <= 4 )); then
            fuzzy_time=${week_names[1]}
        elif [[ $cur_day == 5 ]]; then
            fuzzy_time=${week_names[2]}
        else
            fuzzy_time=${week_names[3]}
        fi
    fi

    echo $fuzzy_time
}

usage() {
    printf "Fuzzyclock 1.2\n"
    printf "Usage: $(basename $0) [-f <1-4>]\n\n"
    echo "-f sets the fuzzyness level"
}

while getopts ":f:" opt; do
    case $opt in
        f)
            if (( $OPTARG > 4 )); then
                echo "Invalid fuzzyness level"
                exit 1
            fi
            fuzzyness=$OPTARG
            ;;
        \?)
            usage
            exit 1
            ;;
    esac
done

fuzzyclock
