#!/usr/bin/env zsh
# vim: ft=zsh
# Eseguito il porting da uno script in python, a sua volta
# portato da chissa' cosa, etc etc.
# Mi sembra ASSURDO chiamare l'interprete python per delle
# funzionalita' tanto BANALI.
# sand <daniel@spatof.org> - Ottobre 2009

# in zsh il primo elemento di un array e' 1, con questa opzione
# diventa 0, pero' cambia sintassi: $array[0] diventa ${array[0]}
setopt KSH_ARRAYS

# CONFIG
fuzzyness=1	# valori possibili: 1, 2, 3, 4

nomiMinuti=(
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

nomiOre=(
    "l'una"
    "e due"
    "e tre"
    "e quattro"
    "e cinque"
    "e sei"
    "e sette"
    "l'otto"
    "e nove"
    "e dieci"
    "l'unnici"
    "a mezza"
)

daytime=(
    "notte"
    "madina presto"
    "madina"
    "quasi la mezza"
    "la mezza"
    "pomeriggio"
    "sera"
    "sera tardi"
)

settimana=(
    "Inizio settimana"
    "Meta' settimana"
    "Fine della settimana"
    "Weekend!"
)

# MAIN()
ore=$(date +%H)
minuti=$(date +%M)
giorno=$(date +%w)
sector=0

parse_options() {
    o_fuzzyness=(-f 1)

    zparseopts -K -- f:=o_fuzzyness h=o_help
    if [[ $? != 0 || "$o_help" != "" ]]; then
	echo Usage: $(basename "$0") "[-f fuzzyness level]"
	exit 1
    fi

    fuzzyness=${o_fuzzyness[1]}
}

fuzzyClock() {
    fuzzyness=$1

    if (( $fuzzyness == 1 || $fuzzyness == 2 )); then
	if (( $fuzzyness == 1 )); then
	    if (( $minuti > 2 )); then
		((sector = (minuti - 3 ) / 5 + 1))
	    fi
	else
	    if (( $minuti > 6 )); then
		((sector = ((minuti - 7) / 15 + 1) * 3))
	    fi
	fi

	[[ ${nomiMinuti[$sector]} =~ "%[0-9]" ]]
	delta=${MATCH:s/%//}

	if (( (($ore + $delta) % 12 ) > 0 )); then
	    ((realhour = (ore + delta) % 12 - 1))
	else
	    ((realhour = 12 - ((ore + delta) % 12 + 1)))
	fi

	# WORKAROUNDS
	# "l'una spaccate" -> "l'una precisa"
	if (( $realhour == 0 )); then
	    nomiMinuti[0]="%0 precisa"
	fi

	sub="%[0-9]"
	fuzzyTime=${${nomiMinuti[$sector]}/${~sub}/${nomiOre[$realhour]}}

    elif (( $fuzzyness == 3 )); then
	fuzzyTime=${daytime[(($ore / 3))]}

    else
	if (( $giorno == 1 )); then
	    fuzzyTime=${settimana[0]}
	elif (( $giorno >= 2 && $giorno <= 4 )); then
	    fuzzyTime=${settimana[1]}
	elif [[ $giorno == 5 ]]; then
	    fuzzyTime=${settimana[2]}
	else
	    fuzzyTime=${settimana[3]}
	fi
    fi

    print $fuzzyTime
}

parse_options $*
fuzzyClock $fuzzyness
