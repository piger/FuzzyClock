#!/opt/local/bin/zsh
# vim: ft=zsh
# Eseguito il porting da uno script in python, a sua volta
# portato da chissa' cosa, etc etc.
# Mi sembra ASSURDO chiamare l'interprete python per delle
# funzionalita' tanto BANALI.
# sand <daniel@spatof.org> - Ottobre 2009

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

# MAIN()
ore=$(date +%H)
minuti=$(date +%M)
sector=0

if [[ $fuzzyness == 1 || $fuzzyness == 2 ]]; then
    if [[ $fuzzyness == 1 ]]; then
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

    timeString=${nomiMinuti[$sector]}
    hourName=${nomiOre[$realhour]}
    sub="%[0-9]"
    #fuzzyTime=${timeString/${~sub}/$hourName}
    fuzzyTime=${${nomiMinuti[$sector]}/${~sub}/${nomiOre[$realhour]}}

elif [[ $fuzzyness == 3 ]]; then
    fuzzyTime=${daytime[(($ore / 3))]}

else
    fuzzyTime="stocazzo"
fi

print $fuzzyTime
